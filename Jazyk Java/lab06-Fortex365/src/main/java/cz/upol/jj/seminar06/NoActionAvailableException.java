package cz.upol.jj.seminar06;

public class NoActionAvailableException extends Exception{
    public NoActionAvailableException(Throwable e){
        super("No action available.", e);
    }
}
