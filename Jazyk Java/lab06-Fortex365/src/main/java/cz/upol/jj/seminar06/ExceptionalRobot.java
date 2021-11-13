package cz.upol.jj.seminar06;

public class ExceptionalRobot {
    private String name;
    private Stack<Action> program;

    ExceptionalRobot(String name, int memorySize){
        this.name = name;
        this.program = new Stack<Action>(memorySize);
    }

    public void readActions(Action[] actions) throws TooManyActionsException{
        // clear actual stack
        int currentSize = this.program.getCapacity();
        this.program = new Stack<Action>(currentSize);

        // reverse
        /*
        int actionsSize = actions.length;
        Action[] reversed_actions = new Action[actionsSize];
        actionsSize -= 1;
        for (var a: actions
             ) {
            reversed_actions[actionsSize] = a;
            actionsSize--;
        }*/

        // push to cleared stack
        try{
            for (var a : actions
            ) {
                this.program.push(a);
            }
        }
        catch(FullStackException e){
            this.program = new Stack<Action>(currentSize);
            throw new TooManyActionsException(e);
        }
    }

    public Action move() throws NoActionAvailableException{
        try{
            return this.program.pop();
        }
        catch(EmptyStackException e){
            throw new NoActionAvailableException(e);
        }
    }

    public Action nextStep() throws NoActionAvailableException{
        var p = this.program.safePeek();
        if(p.isPresent()){
            return p.get();
        }
        else{
            throw new NoActionAvailableException(new Exception());
        }
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
