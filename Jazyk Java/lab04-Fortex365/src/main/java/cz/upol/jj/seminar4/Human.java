package cz.upol.jj.seminar4;

import java.lang.reflect.Array;
import java.util.ArrayList;

public class Human extends Animal implements Sender, Receiver{
    private String surname;
    private String id;
    private ArrayList<Message> messages = new ArrayList<>();

    public Human(String name, String surname, String id, int age){
        super(name,age);
        this.surname = surname;
        this.id = id;
    }

    public String getSurname() {
        return surname;
    }

    public String getID() {
        return id;
    }

    public String getFullName(){
        return this.getName() + " " + getSurname();
    }

    public void setID(String id){
        StringBuilder s = new StringBuilder();
        if(id.length() > 6){
            for(int i = 0; i < 6; i++){
                s.append(id.charAt(i));
            }
        }
        else{
            int zeros = 0;
            for(int i = 0; i < (6 - id.length()); i++){
                s.append("0");
                zeros += 1;
            }
            for(int i = 0; i < 6 - zeros; i++){
                s.append(id.charAt(i));
            }
        }
        this.id = s.toString();
    }

    public boolean sendMessage(String message, Receiver receiver){
        Message m = new Message(this, message);
        return receiver.receive(m);
    }

    public boolean receive(Message m){
        if(m != null){
            addMessages(m);
            return true;
        }
        else{
            return false;
        }
    }

    public Message[] getMessages(){
        Message[] result = new Message[getM().size()];
        int i = 0;
        for (var m : this.messages
             ) {
            result[i] = m;
            i++;
        }
        return result;
    }

    private ArrayList<Message> getM(){
        return this.messages;
    }

    private void addMessages(Message messages){
        this.messages.add(messages);
    }

}
