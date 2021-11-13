package cz.upol.jj.seminar06;

import java.util.Optional;

public class SafeRobot {
    private String name;
    private Stack<Action> program;

    SafeRobot(String name, int memorySize){
        this.name = name;
        this.program = new Stack<Action>(memorySize);
    }

    public boolean addActions(Action[] actions){
        // clear actual stack
        int currentSize = this.program.getCapacity();
        this.program = new Stack<Action>(currentSize);

        // reverse
        int actionsSize = actions.length;
        Action[] reversed_actions = new Action[actionsSize];
        actionsSize -= 1;
        for (var a: actions
        ) {
            reversed_actions[actionsSize] = a;
            actionsSize--;
        }

        // push to cleared stack
        for(var a : reversed_actions){
            boolean passed = this.program.safePush(a);
            if(passed == false){
                return false;
            }
        }
        return true;
    }

    public boolean readActions(Action[] actions){
        // clear actual stack
        int currentSize = this.program.getCapacity();
        this.program = new Stack<Action>(currentSize);

        // reverse
        int actionsSize = actions.length;
        Action[] reversed_actions = new Action[actionsSize];
        actionsSize -= 1;
        for (var a: actions
        ) {
            reversed_actions[actionsSize] = a;
            actionsSize--;
        }

        // push to cleared stack
        for (var a : reversed_actions) {
            boolean ret = this.program.safePush(a);
            if (ret == false){
                this.program = new Stack<Action>(currentSize);
                return false;
            }
        }
        return true;
    }

    public Optional<Action> move(){
        Optional<Action> res = this.program.safePop();
        return res;
    }

    public Optional<Action> nextStep(){
        var p = this.program.safePeek();
        return p;
    }

    @Override
    public String toString() {
        var a = this.program.safePeek();
        if(a.isPresent()){
            String c = a.get().toString();
            return "Name: " + name +
                    ", Action: " + c;
        }
        else {
            return "Name: " + name +
                    ", Action: " + "NONE";
        }
    }

    public boolean hasProgram(){
        var a = this.program.safePeek();
        if(a.isPresent()){
            return true;
        }
        else{
            return false;
        }
    }
}
