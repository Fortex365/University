package cz.upol.jj.seminar4;

public class Pigeon extends OwnedAnimal implements Sender{
    public Pigeon(String name, int age, Human human){
        super(human,name,age);
    }

    public boolean sendMessage(String message, Receiver receiver){
        Message m = new Message(this, message);
        return receiver.receive(m);
    }
}
