package cz.upol.jj.seminar4;

public abstract class Mortal
{
    private boolean isAlive = true;
    private int age;

    public Mortal(int age){
        this.age = age;
    }

    public boolean isAlive() {
        return isAlive;
    }

    public void die(){
        this.isAlive = false;
    }

    public int getAge() {
        return age;
    }

    public boolean setAge(int age) {
        if((age > this.getAge()) &&
                (isAlive() == true)){
            this.age = age;
            return true;
        }
        return false;
    }
}
