package cz.upol.jj.seminar08;

import java.util.Comparator;
import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.function.Function;
import java.util.function.Predicate;
import java.util.stream.Stream;

public class Store {
    private List<Item> items;

    Store(List<Item> items){
        this.items = items;
    }

    private List<Item> getItems(){
        return items;
    }

    private void setItems(List<Item> newitems){
        this.items = newitems;
    }

    public boolean hasItem(String name){
        var itemStream = getItems().stream();
        var itemsList = itemStream.filter(x -> x.getName().equals(name)).
                toList();

        if(itemsList.isEmpty())
            return false;
        return true;
    }

    public int countItems(String name, Type type){
        var itemStream = getItems().stream();
        return itemStream.filter(x -> x.getName().equals(name) &&
                        x.getType().equals(type)).mapToInt(x -> x.getCount()).sum();
    }

    public double getTotalPrice(){
        var itemStream = getItems().stream();
        var price = itemStream.mapToDouble(x -> x.getPrice()
                * x.getCount()).sum();
        return price;
    }

    public double getTotalPriceOfType(Type type){
        var itemStream = getItems().stream();
        var price = itemStream.filter(x -> x.getType().equals(type))
                .mapToDouble(x -> x.getPrice() * x.getCount()).sum();
        return price;
    }

    public int countTotalItems(){
        var itemStream = getItems().stream();
        var cnt = itemStream.mapToInt(x -> x.getCount()).sum();
        return cnt;
    }

    public int countTypes(){
        var itemStream = getItems().stream();
        var itemsList = itemStream.filter(
                distinctByKey(Item::getType)).toList();
        return itemsList.size();
    }

    private static <T> Predicate<T> distinctByKey(Function<? super T, ?> keyExtractor) {
        Set<Object> seen = ConcurrentHashMap.newKeySet();
        return t -> seen.add(keyExtractor.apply(t));
    }

    public Stream<Item> cheaperThan(int price){
        var itemStream = getItems().stream();
        return itemStream.filter(x -> x.getPrice() < price);
    }

    public Optional<Item> mostExpensive(){
        var itemStream = getItems().stream();
        var out = itemStream.max(
                Comparator.comparing(Item::getPrice));
        return out;
    }
}
