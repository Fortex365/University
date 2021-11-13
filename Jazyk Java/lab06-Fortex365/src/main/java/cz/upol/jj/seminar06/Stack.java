package cz.upol.jj.seminar06;

import java.util.Optional;
import java.util.ArrayList;

public class Stack<T> {
    private ArrayList<T> stack = new ArrayList<>();
    private int capacity;

    Stack(int capacity){
        this.capacity = capacity;
    }

    public int getCapacity(){
        return capacity;
    }

    public int length(){
        return this.stack.size();
    }

    public boolean isFull(){
        if(this.length() == this.capacity){
            return true;
        }
        else {
            return false;
        }
    }

    public boolean isEmpty(){
        if(this.length() == 0){
            return true;
        }
        else{
            return false;
        }
    }

    public void push(T element) throws FullStackException{
        if(this.length() >= this.capacity){
            throw new FullStackException(new Exception());
        }
        else {
            this.stack.add(element);
        }
    }

    public boolean safePush(T element){
        if(this.length() >= this.capacity){
            return false;
        }
        else {
            this.stack.add(element);
            return true;
        }
    }

    public T peek() throws  EmptyStackException{
        try{
            return this.stack.get(this.length()-1);
        }
        catch(IndexOutOfBoundsException e){
            throw new EmptyStackException(e);
        }
    }

    public Optional<T> safePeek(){
        try{
            T ret = this.stack.get(this.length()-1);
            Optional<T> opt = Optional.of(ret);
            return opt;
        }
        catch(IndexOutOfBoundsException e){
            T ret = null;
            Optional<T> opt = Optional.ofNullable(ret);
            return opt;
        }
    }

    public T pop() throws  EmptyStackException{
        try{
            T ret = this.stack.get(this.length()-1);
            this.stack.remove(this.length()-1);
            return ret;
        }
        catch(IndexOutOfBoundsException e){
            throw new EmptyStackException(e);
        }
    }


    public Optional<T> safePop(){
        try{
        T ret = this.stack.get(this.length()-1);
        this.stack.remove(this.length()-1);
        Optional<T>  opt = Optional.of(ret);
        return opt;
        }
        catch(IndexOutOfBoundsException e){
            T ret = null;
            Optional<T> opt = Optional.ofNullable(ret);
            return opt;
        }
    }
}
