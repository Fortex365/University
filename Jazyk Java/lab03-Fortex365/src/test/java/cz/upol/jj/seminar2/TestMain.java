package cz.upol.jj.seminar2;

import org.junit.jupiter.api.Test;

import java.io.ByteArrayOutputStream;
import java.io.PrintStream;

import static org.junit.jupiter.api.Assertions.*;

public class TestMain {

    private Country[] getCountries() {
        Country c1 = new Country("Ceska republika", "+420");
        Country c2 = new Country("Slovenska republika", "+421");
        Country c3 = new Country("USA", "+1");
        Country[] countries = {c1, c2, c3};
        return countries;
    }

    private Person[] getPersons() {
        Country[] countries = getCountries();
        Person p1 = new Person(0, "Prokop", "Dvere", 24, "555444333", countries[0]);
        Person p2 = new Person(1, "Tomas", "Putna", 50, "999888777", countries[0]);
        Person p3 = new Person(2, "Fero", "Dunaj", 65, "123456789", countries[1]);
        Person p4 = new Person(3, "Johnny", "Cash", 71, "987654321", countries[2]);
        Person p5 = new Person(4, "Tomas", "Putna", 15, "111222333", null);
        Person[] persons = {p1, p2, p3, p4, p5};
        return persons;
    }

    @Test
    public void testCountryPrint()
    {
        /* Vytvorte tridu Country(String name, String phoneCode), ktera reprezentuje stat. Objekty maji dva atributy - name (jmeno statu) a phoneCode (telefonni predvolba, napr. +420).
        Dale definujte metodu print, ktera vypise zemi ve formatu Stat{jmeno=xxx, predvolba=xxx} a ukonci radek.
         */

        PrintStream originalOut = System.out;
        ByteArrayOutputStream bos = new ByteArrayOutputStream();
        System.setOut(new PrintStream(bos));

        Country[] countries = getCountries();
        countries[0].print();
        assertEquals("Stat{jmeno=Ceska republika, predvolba=+420}" + System.lineSeparator(), bos.toString());
        bos.reset();
        countries[1].print();
        assertEquals("Stat{jmeno=Slovenska republika, predvolba=+421}" + System.lineSeparator(), bos.toString());
        bos.reset();
        countries[2].print();
        assertEquals("Stat{jmeno=USA, predvolba=+1}" + System.lineSeparator(), bos.toString());

        System.setOut(originalOut);
    }

    @Test
    public void testPersonGetStatus()
    {
        /* Vytvorte tridu Person(int id, String firstname, String lastname, int age, String phone, Country country), ktera reprezentuje osobu. Objekty maji atributy: id (unikatni identifikator), firstname (jmeno), lastname (prijmeni), age (vek), phone (telefon), country (stat).
        Dale definujte metodu getStatus, ktera vrati status osoby: pokud je vek mensi nez 18, vrati status "junior", pokud vetsi nebo roven 65, vrati status "senior", jinak vrati status "dospely".
         */

        Person[] persons = getPersons();

        assertEquals("senior", persons[2].getStatus());
        assertEquals("junior", persons[4].getStatus());
        assertEquals("dospely", persons[1].getStatus());
    }

    @Test
    public void testPersonGetPhone()
    {
        // Tride Person definujte metodu, ktera vrati telefonni Cislo i s predvolbou. Pokud osoba nema stat prirazeny, vrati Cislo bez predvolby.

        Person[] persons = getPersons();

        assertEquals("+1987654321", persons[3].getPhone());
        assertEquals("+420555444333", persons[0].getPhone());
        assertEquals("+421123456789", persons[2].getPhone());
        assertEquals("111222333", persons[4].getPhone());
    }

    @Test
    public void testPersonPrint()
    {
        /* Tride Person definujte metodu print, ktera vypise osobu ve formatu Osoba{id=xxx, jmeno=xxx, prijmeni=xxx, vek=xxx, telefon=xxx, status=xxx, stat=xxx} a ukonCi radek.
        Pokud osoba nema stat prirazeny, vypise stat=neznamy.
        */

        PrintStream originalOut = System.out;
        ByteArrayOutputStream bos = new ByteArrayOutputStream();
        System.setOut(new PrintStream(bos));

        Person[] persons = getPersons();
        persons[0].print();
        assertEquals("Osoba{id=0, jmeno=Prokop, prijmeni=Dvere, vek=24, telefon=+420555444333, status=dospely, stat=Ceska republika}" + System.lineSeparator(), bos.toString());
        bos.reset();

        persons[4].print();
        assertEquals("Osoba{id=4, jmeno=Tomas, prijmeni=Putna, vek=15, telefon=111222333, status=junior, stat=neznamy}" + System.lineSeparator(), bos.toString());
        bos.reset();

        System.setOut(originalOut);
    }

    @Test
    public void testIndexCount1()
    {
        /* Vytvorte tridu Index(Person[] persons, Country[] countries), ktera reprezentuje rejstrik. Rejstrik obsahuje pole osob a pole statu.
        Dale definujte metodu count(String countryName), ktera vraci pocet osob, zijicich v urcitem state.
         */

        Person[] persons = getPersons();
        Country[] countries = getCountries();
        Index index = new Index(persons, countries);

        assertEquals(2, index.count("Ceska republika"));
        assertEquals(1, index.count("USA"));
        persons[2].country = countries[0];
        assertEquals(3, index.count("Ceska republika"));
    }

    @Test
    public void testIndexCount2()
    {
        // Tride Index definujte metodu count(String firstname, String lastname), ktera vrati pocet osob se stejnym jmenem a prijmenim.

        Person[] persons = getPersons();
        Country[] countries = getCountries();
        Index index = new Index(persons, countries);

        assertEquals(2, index.count("Tomas", "Putna"));
        assertEquals(1, index.count("Johnny", "Cash"));
        persons[1].firstname = "Johnny";
        persons[1].lastname = "Cash";
        assertEquals(2, index.count("Johnny", "Cash"));
    }

    @Test
    public void testIndexSearch1()
    {
        // Tride Index definujte metodu search, ktera vyhleda osobu s urcitym id.

        Person[] persons = getPersons();
        Country[] countries = getCountries();
        Index index = new Index(persons, countries);

        assertEquals(persons[1], index.search(1));
        assertEquals(persons[4], index.search(4));
        assertEquals(persons[1], index.search(1));
        persons[1].id = 10;
        assertEquals(persons[1], index.search(10));
        assertNull(index.search(12));
    }

    @Test
    public void testIndexSearch2()
    {
        // Tride Index definujte metodu search(String countryName), ktera vyhleda vsechny osoby zijici v urcitem state.

        Person[] persons = getPersons();
        Country[] countries = getCountries();
        Index index = new Index(persons, countries);

        assertArrayEquals(new Person[]{persons[0], persons[1]}, index.search("Ceska republika"));
        assertArrayEquals(new Person[]{persons[3]}, index.search("USA"));
        persons[2].country = countries[0];
        assertArrayEquals(new Person[]{persons[0], persons[1], persons[2]}, index.search("Ceska republika"));
        assertArrayEquals(new Person[]{}, index.search("Ukrajina"));
    }

    @Test
    public void testIndexSearch3()
    {
        // Tride Index definujte metodu search(String firstname, String lastname), ktera vyhleda vsechny osoby se stejnym jmenem a prijmenim.

        Person[] persons = getPersons();
        Country[] countries = getCountries();
        Index index = new Index(persons, countries);

        assertArrayEquals(new Person[]{persons[1], persons[4]}, index.search("Tomas", "Putna"));
        assertArrayEquals(new Person[]{persons[3]}, index.search("Johnny", "Cash"));
        persons[1].firstname = "Johnny";
        persons[1].lastname = "Cash";
        assertArrayEquals(new Person[]{persons[1], persons[3]}, index.search("Johnny", "Cash"));
    }

    @Test
    public void testIndexSetPhoneCode()
    {
        /* Tride Index definujte metodu setPhoneCode(Person person, String phoneCode), ktera osobe nastavi zemi podle telefonni predvolby.
        Pokud je predvolba neplatna, neudela nic a vrati hodnotu false (jinak true).
         */

        Person[] persons = getPersons();
        Country[] countries = getCountries();
        Index index = new Index(persons, countries);

        assertEquals("+420555444333", persons[0].getPhone());
        assertTrue(index.setPhoneCode(persons[0], "+421"));
        assertEquals("+421555444333", persons[0].getPhone());
        assertFalse(index.setPhoneCode(persons[0], "+2"));
        assertEquals("+421555444333", persons[0].getPhone());
    }

    @Test
    public void testIndexPrint()
    {
        /* Tride Index definujte metodu print, ktera vypise (efektivnim zpusobem!) obsah rejstriku viz:

        Rejstrik{
        Osoba{id=0, jmeno=Prokop, prijmeni=Dvere, telefon=+420555444333}
        Osoba{id=1, jmeno=Tomas, prijmeni=Putna, telefon=+420999888777}
        Osoba{id=2, jmeno=Fero, prijmeni=Dunaj, telefon=+421123456789}
        Osoba{id=3, jmeno=Johnny, prijmeni=Cash, telefon=+1987654321}
        Osoba{id=4, jmeno=Tomas, prijmeni=Putna, telefon=111222333}
        }

        a ukonCi radek.
        */

        PrintStream originalOut = System.out;
        ByteArrayOutputStream bos = new ByteArrayOutputStream();
        System.setOut(new PrintStream(bos));

        Person[] persons = getPersons();
        Country[] countries = getCountries();
        Index index = new Index(persons, countries);

        index.print();

        assertEquals("Rejstrik{" + System.lineSeparator()
        + "Osoba{id=0, jmeno=Prokop, prijmeni=Dvere, telefon=+420555444333}" + System.lineSeparator()
        + "Osoba{id=1, jmeno=Tomas, prijmeni=Putna, telefon=+420999888777}"  + System.lineSeparator()
        + "Osoba{id=2, jmeno=Fero, prijmeni=Dunaj, telefon=+421123456789}"  + System.lineSeparator()
        + "Osoba{id=3, jmeno=Johnny, prijmeni=Cash, telefon=+1987654321}"  + System.lineSeparator()
        + "Osoba{id=4, jmeno=Tomas, prijmeni=Putna, telefon=111222333}"  + System.lineSeparator()
        +"}"  + System.lineSeparator()
        , bos.toString());

        System.setOut(originalOut);
    }
}