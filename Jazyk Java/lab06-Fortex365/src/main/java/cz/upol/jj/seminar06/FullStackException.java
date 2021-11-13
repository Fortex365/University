package cz.upol.jj.seminar06;

public class FullStackException extends Exception {
    FullStackException(Throwable e){
        super("Stack is full.", e);
    }
}

