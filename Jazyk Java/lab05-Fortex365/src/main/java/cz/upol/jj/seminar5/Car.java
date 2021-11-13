package cz.upol.jj.seminar5;

import java.util.Objects;

public class Car extends Item implements Comparable<Car> {
    private String manufacturer;
    private String model;
    private float price;
    private int year;

    Car(String manufacturer, String model, float price, int year){
        this.manufacturer = manufacturer;
        this.model = model;
        this.price = price;
        this.year = year;
    }

    public int compareTo(Car c){
        if(c.getPrice() > this.getPrice()){
            return 1;
        }
        else if(c.getPrice() < this.getPrice()){
            return -1;
        }
        return 0;
    }

    public float getPrice() {
        return price;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Car car = (Car) o;
        return Float.compare(car.price, price) == 0 && year == car.year && Objects.equals(manufacturer, car.manufacturer) && Objects.equals(model, car.model);
    }

    @Override
    public int hashCode() {
        return Objects.hash(manufacturer, model, price, year);
    }

    public void setPrice(float price) {
        this.price = price;
    }
}
