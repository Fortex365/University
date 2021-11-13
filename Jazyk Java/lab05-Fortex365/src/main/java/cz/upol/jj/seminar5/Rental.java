package cz.upol.jj.seminar5;

import javax.management.relation.Relation;
import java.sql.Array;
import java.util.ArrayList;

public class Rental<T extends Item & Comparable<T>> implements Iterable<RentableItem> {
    private ArrayList<RentableItem> Items = new ArrayList<>();
    private float Cash = 0;

    public ArrayList<RentableItem> getItems() {
        return Items;
    }

    public void sort(){

    }

    public void sortByPrice(){

    }

    public RentableItem add(T item, int price){
        RentableItem<T> i = new RentableItem(item,price);
        this.Items.add(i);
        return i;
    }

    public boolean remove(RentableItem rentableItem){
        boolean result = this.Items.remove(rentableItem);
        if(result == true){
            return true;
        }
        else{
            return false;
        }
    }

    public RentableItem find(T item, boolean rented){
        for (var i: this.Items
             ) {
            if(item.equals(i) && (i.isRented() == rented)){
                return i;
            }
        }
        return null;
    }

    public int count(T item){
        int count = 0;
        for (var i: this.Items
             ) {
            if(i.isRented() == false){
                count++;
            }
        }
        return count;
    }

    public RentableItem rent(T item){
        RentableItem findI = find(item, false);
        if(findI == null){
            return null;
        }
        findI.setRented(true);
        float price = findI.getPrice();
        this.Cash += price;
        return findI;
    }

    public boolean retrieve(RentableItem rentableItem){
        for (var i: this.Items
        ) {
            if(rentableItem.equals(i)){
                i.setRented(false);
                return true;
            }
        }
        return false;
    }

    public float getCash() {
        return Cash;
    }

    public Iterator<RentableItem<T>> iterator(){
        return this.Items.iterator();
    }
}
