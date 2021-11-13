package cz.upol.jj.seminar4;

public class Dog extends OwnedAnimal implements Receiver{
    private Message message;

    public Dog(String name, int age, Human human){
        super(human,name,age);
    }

    public boolean receive(Message m){
        if(!(m.sender().equals(this.getOwner()))){
            return false;
        }
        this.message = m;
        return true;
    }

    public Message getLastMessage(){
        return this.message;
    }
}
