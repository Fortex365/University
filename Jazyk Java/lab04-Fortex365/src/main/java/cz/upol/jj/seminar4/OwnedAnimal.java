package cz.upol.jj.seminar4;

public abstract class OwnedAnimal extends Animal
{
    private Human human;

    public Human getOwner() {
        return human;
    }

    public void setOwner(Human human) {
        this.human = human;
    }

    public OwnedAnimal(Human human, String name, int age){
        super(name,age);
        this.human = human;
    }
}
