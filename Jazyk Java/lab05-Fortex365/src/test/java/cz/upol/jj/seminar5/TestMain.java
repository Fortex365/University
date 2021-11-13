package cz.upol.jj.seminar5;

import org.junit.jupiter.api.Test;

import java.util.ArrayList;
import java.util.Iterator;

import static org.junit.jupiter.api.Assertions.*;

public class TestMain {

    @Test
    public void testBooks()
    {
        Book b1 = new Book("Game of thrones", "Martin R. R. George", 2010);
        Book b2 = new Book("Bible", "Collective of authors", 0);
        Book b3 = new Book("Bible", "Collective of authors", 0);
        assertNotEquals(b1, b2);
        assertNotEquals(b1, null);
        assertNotEquals(null, b2);
        assertEquals(b2, b3);
        assertTrue(b1.compareTo(b2) > 0);
        assertTrue(b2.compareTo(b3) == 0);
        assertTrue(b2.compareTo(b1) < 0);
    }

    @Test
    public void testCars()
    {
        Car c1 = new Car("Nissan", "Qashqai", 230000, 2012);
        Car c2 = new Car("Ferrari", "Enzo", 60000000, 2004);
        Car c3 = new Car("Ferrari", "Enzo", 60000000, 2004);
        assertNotEquals(c1, c2);
        assertNotEquals(c1, null);
        assertNotEquals(null, c2);
        assertEquals(c2, c3);
        assertTrue(c1.compareTo(c2) < 0);
        assertTrue(c2.compareTo(c2) == 0);
        assertTrue(c2.compareTo(c1) > 0);
    }

    @Test
    public void testRentalBooksSort()
    {
        Book b1 = new Book("Game of thrones", "Martin R. R. George", 2010);
        Book b2 = new Book("Bible", "Collective of authors", 0);
        Book b3 = new Book("Bible", "Collective of authors", 0);
        Book b4 = new Book("The Metaphysics", "Aristotle", -1000);
        Rental<Book> r = new Rental<>();
        r.add(b1, 10);
        r.add(b2, 20);
        r.add(b3, 20);
        r.add(b4, 5);

        r.sort();

        assertEquals(r.getItems().get(0).getItem(), b4);
        assertEquals(r.getItems().get(1).getItem(), b2);
        assertEquals(r.getItems().get(2).getItem(), b3);
        assertEquals(r.getItems().get(3).getItem(), b1);

        r.sortByPrice();

        assertEquals(r.getItems().get(0).getItem(), b4);
        assertEquals(r.getItems().get(1).getItem(), b1);
        assertEquals(r.getItems().get(2).getItem(), b2);
        assertEquals(r.getItems().get(3).getItem(), b3);
    }

    @Test
    public void testRentalBooksRent()
    {
        Book b1 = new Book("Game of thrones", "Martin R. R. George", 2010);
        Book b2 = new Book("Bible", "Collective of authors", 0);
        Book b3 = new Book("Bible", "Collective of authors", 0);
        Book b4 = new Book("The Metaphysics", "Aristotle", -1000);
        Rental<Book> r = new Rental<>();
        r.add(b1, 10);
        r.add(b2, 20);
        r.add(b3, 20);
        r.add(b4, 5);

        RentableItem<Book> rb1 = r.rent(b1);
        assertNotNull(rb1);
        assertNull(r.rent(b1));
        RentableItem<Book> rb2 = r.rent(b2);
        assertNotNull(rb2);
        RentableItem<Book> rb3 = r.rent(b2);
        assertNotNull(rb3);
        assertNull(r.rent(b2));

        assertEquals(50, r.getCash());

        assertTrue(rb1.isRented());
        r.retrieve(rb1);
        assertFalse(rb1.isRented());

        assertNotNull(r.rent(b1));

        assertEquals(60, r.getCash());

        assertEquals(0, r.count(b2));
        r.retrieve(rb2);
        assertEquals(1, r.count(b2));
        r.retrieve(rb3);
        assertEquals(2, r.count(b2));

        assertNull(r.find(b1, false));
        assertEquals(b1, r.find(b1, true).getItem());

        r.remove(rb1);
        assertNull(r.find(b1, true));

        Iterator<RentableItem<Book>> iterator = r.iterator();
        assertEquals(b2, iterator.next().getItem());
        assertEquals(b2, iterator.next().getItem());
        assertEquals(b4, iterator.next().getItem());
        assertFalse(iterator.hasNext());
    }

    @Test
    public void testRentalCars()
    {
        Car c1 = new Car("Nissan", "Qashqai", 230000, 2012);
        Car c2 = new Car("Ferrari", "Enzo", 60000000, 2004);
        Car c3 = new Car("Ferrari", "Enzo", 60000000, 2004);
        Car c4 = new Car("BMW", "X5", 500000, 2015);
        Rental<Car> r = new Rental<>();
        r.add(c1, 230);
        r.add(c2, 60000);
        r.add(c3, 60000);
        r.add(c4, 500);

        r.sort();

        assertEquals(r.getItems().get(0).getItem(), c1);
        assertEquals(r.getItems().get(1).getItem(), c4);
        assertEquals(r.getItems().get(2).getItem(), c2);
        assertEquals(r.getItems().get(3).getItem(), c3);
    }
}