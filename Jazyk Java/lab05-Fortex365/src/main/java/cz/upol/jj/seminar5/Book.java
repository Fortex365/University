package cz.upol.jj.seminar5;

import java.util.Objects;

public class Book extends Item implements Comparable<Book> {
    private String name;
    private String author;
    private int year;

    Book(String name, String author, int year){
        this.name = name;
        this.author = author;
        this.year = year;
    }

    public int compareTo(Book b){
        String ba = b.getAuthor();
        String ta = this.getAuthor();

        int compare = ba.compareTo(ta);

        if (compare < 0) {
            return -1;
        }
        else if (compare > 0) {
            return 1;
        }
        else {
            return 0;
        }
    }

    public String getAuthor() {
        return author;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Book book = (Book) o;
        return year == book.year && Objects.equals(name, book.name) && Objects.equals(author, book.author);
    }

    @Override
    public int hashCode() {
        return Objects.hash(name, author, year);
    }
}
