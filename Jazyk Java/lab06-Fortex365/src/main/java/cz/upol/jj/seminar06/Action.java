package cz.upol.jj.seminar06;

public enum Action {
    STEP(100,1000), BACK(200,1000), LEFT(10,10), RIGHT(20,10);

    private int code;
    private int price;

    Action(int code, int price){
        this.code = code;
        this.price = price;
    }

    public int getPrice() {
        return price;
    }

    public int getCode() {
        return code;
    }

    @Override
    public String toString() {
        return code + ":" + price;
    }
}
