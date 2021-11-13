package cz.upol.jj.seminar06;

public class TooManyActionsException extends Exception {
    public TooManyActionsException(Throwable e){
        super("Too many actions.", e);
    }
}
