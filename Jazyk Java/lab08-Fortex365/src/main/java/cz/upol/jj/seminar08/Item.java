package cz.upol.jj.seminar08;

public class Item {
    private String name;
    private Type type;
    private int count;
    private double price;

    Item(String name, Type type, int count, double price){
        this.name = name;
        this.type = type;
        this.count = count;
        this.price = price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setCount(int count) {
        this.count = count;
    }

    public void setType(Type type) {
        this.type = type;
    }

    public String getName() {
        return name;
    }

    public double getPrice() {
        return price;
    }

    public Type getType() {
        return type;
    }

    public int getCount() {
        return count;
    }

    @Override
    public String toString() {
        return "Item{" +
                "name=" + name +
                ", type=" + type +
                ", count=" + count +
                ", price=" + price +
                '}';
    }
}
