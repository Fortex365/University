package cz.upol.jj.seminar4;

public record Message(Sender sender, String message){
}

/*
public class Message
{
    private String message;
    private Sender sender;

    public Message(Sender sender, String message){
        this.message = message;
        this.sender = sender;
    }

    public String message() {
        return message;
    }

    public Sender sender() {
        return sender;
    }

    @Override
    public boolean equals(Object o) {
        Message message1 = (Message) o;
        return message1.message.equals(message) && message1.sender.equals(sender);
    }
}
*/

