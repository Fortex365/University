package cz.upol.jj.seminar1;

import org.junit.jupiter.api.Test;

import java.io.ByteArrayOutputStream;
import java.io.PrintStream;

import static org.junit.jupiter.api.Assertions.assertEquals;

public class TestMain {

    @Test
    public void testPrvocisla() {
        /* Napište funkci prvocisla beroucí jeden argument typu int, která vypíše všechna prvočísla menší než zadaný argument oddělená čárkou a mezerou (ve standardním pořadí). Za posledním vypsaným číslem bude taktéž čárka a maezera.
         * Příklad: prvocisla(10); vypíše: "2, 3, 5, 7, ".*/
        PrintStream originalOut = System.out;
        ByteArrayOutputStream bos = new ByteArrayOutputStream();
        System.setOut(new PrintStream(bos));


        Main.prvocisla(100);

        assertEquals("2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, ", bos.toString());

        System.setOut(originalOut);
    }

    @Test
    public void testNasob() {
        /* Napište funkci nasob beroucí dva argumenty typu int vracející jejich součin, ale používající z aritmetických operací pouze sčítání a odčítání.
        Mohou se hodit funkce z knihovny Math (vizte dokumentaci). Příklad: nasob(5,6) vrátí 30.
         */
        assertEquals(1, Main.nasob(1, 1));
        assertEquals(0, Main.nasob(0, 10));
        assertEquals(100, Main.nasob(10, 10));
        assertEquals(21540000, Main.nasob(10000, 2154));
        assertEquals(-300, Main.nasob(-25, 12));
        assertEquals(14, Main.nasob(-1, -14));
        assertEquals(0, Main.nasob(-1, 0));
    }

    @Test
    public void testCtverec() {
        /* Napište funkci ctverec beroucí jeden argument typu int, která na obrazovku vytiskne čtverec zadané velikost.
           Tj printSquare(3) vytiskne
             ---
            |   |
            |   |
            |   |
             ---
             Tedy čtverec z mezer velikosti 3x3 ohraničený znakem - shora a zespoda a znakem | zprava a zleva. Pozor, v levých rozích je mezera pro odsazení a na konci výpisu je nový řádek.
            Pro neplatná zadání funkce neudělá nic.
        */

        PrintStream originalOut = System.out;
        ByteArrayOutputStream bos = new ByteArrayOutputStream();
        System.setOut(new PrintStream(bos));

        Main.ctverec(1);
        Main.ctverec(2);
        Main.ctverec(8);


        assertEquals("""
                 -
                | |
                 -
                 --
                |  |
                |  |
                 --
                 --------
                |        |
                |        |
                |        |
                |        |
                |        |
                |        |
                |        |
                |        |
                 --------
                 """, bos.toString());

        bos = new ByteArrayOutputStream();

        System.setOut(new PrintStream(bos));

        Main.ctverec(0);
        Main.ctverec(-1);

        assertEquals("", bos.toString());

        System.setOut(originalOut);
    }

    @Test
    public void testSlovo() {
        /* Napište funkci slovo vracející pro zadané číslo v rozsahu 1 až 10 jemu odpovídající české slovo a pro čísla mimo zadaný rozsah vrátí slovo "neznám".

           Příklad slovo(3) vrátí String  "tři".
        */
        assertEquals("jedna", Main.slovo(1));
        assertEquals("dva", Main.slovo(2));
        assertEquals("tři", Main.slovo(3));
        assertEquals("čtyři", Main.slovo(4));
        assertEquals("pět", Main.slovo(5));
        assertEquals("šest", Main.slovo(6));
        assertEquals("sedm", Main.slovo(7));
        assertEquals("osm", Main.slovo(8));
        assertEquals("devět", Main.slovo(9));
        assertEquals("deset", Main.slovo(10));
        assertEquals("neznám", Main.slovo(-1));
        assertEquals("neznám", Main.slovo(11));
    }

}