package cz.upol.jj.seminar4;

public class Snake extends Animal {
    public Snake(String name, int age) {
        super(name, age);
    }

    public boolean bite(Mortal mortal) {
        mortal.die();
        if (!mortal.isAlive()) {
            return true;
        } else {
            return false;
        }
    }
}
