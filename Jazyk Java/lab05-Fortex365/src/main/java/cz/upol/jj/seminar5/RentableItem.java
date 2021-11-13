package cz.upol.jj.seminar5;

public class RentableItem<T extends Item & Comparable> implements Comparable{
    private T item;
    private int price;
    private boolean rented = false;

    RentableItem(T item, int price){
        this.item = item;
        this.price = price;
    }

    public void setItem(T item) {
        this.item = item;
    }

    public T getItem() {
        return item;
    }

    public int compareTo(RentableItem ri){
        if(ri.getItem().equals(this.getItem())){
            return 1;
        }
        else{
            return -1;
        }
    }

    public void setPrice(int price) {
        this.price = price;
    }

    public boolean isRented(){
        return this.rented;
    }

    public void setRented(boolean rented){
        this.rented = rented;
    }

    public float getPrice(){
        return (float)this.price;
    }
}
