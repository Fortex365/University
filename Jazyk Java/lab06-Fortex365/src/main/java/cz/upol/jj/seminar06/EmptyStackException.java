package cz.upol.jj.seminar06;

public class EmptyStackException extends Exception{
    EmptyStackException(Throwable e){
        super("Stack is empty.", e);
    }
}
