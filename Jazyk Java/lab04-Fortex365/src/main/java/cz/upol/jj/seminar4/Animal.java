package cz.upol.jj.seminar4;

public abstract class Animal extends Mortal {
    private String name;

    public Animal(String name, int age){
        super(age);
        this.name = name;
    }

    public String getName() {
        return name;
    }
}
