package cz.upol.jj.seminar4;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

public class TestMain {

    @Test
    public void testMortality() {
        Human h = new Human("Pepa", "Zdepa", "Pepa00", 10);
        Dog d = new Dog("Alik", 3, h);
        Pigeon p = new Pigeon("loubek", 2, h);
        Snake s = new Snake("kobra", 1);

        assertTrue(h.isAlive());
        assertTrue(d.isAlive());
        assertTrue(p.isAlive());

        d.die();
        h.die();
        s.bite(p);

        assertFalse(p.isAlive());
        assertFalse(h.isAlive());
        assertFalse(d.isAlive());


    }

    @Test
    public void testMessages() {
        Human h = new Human("Pepa", "Zdepa", "Pepa00", 10);
        Human stranger = new Human("Jozka", "Uprka", "guruslovacka", 80);
        Dog d = new Dog("Alik", 3, h);
        Pigeon p = new Pigeon("loubek", 2, h);


        assertTrue(h.sendMessage("sedni!", d));
        assertFalse(stranger.sendMessage("aport!", d));


        assertEquals(new Message(h, "sedni!"), d.getLastMessage());


        assertTrue(stranger.sendMessage("aport!", h));
        assertTrue(p.sendMessage("sokol pristal", h));
        assertTrue(h.sendMessage("zprava pro budouci ja", h));



        assertArrayEquals(
                new Message[]{new Message(stranger, "aport!"),
                        new Message(p, "sokol pristal"),
                        new Message(h, "zprava pro budouci ja")},
                h.getMessages());

    }


    @Test
    public void testAgeing() {
        Human h = new Human("Pepa", "Zdepa", "Pepa00", 10);
        Dog d = new Dog("Alik", 3, h);

        assertFalse(h.setAge(1));
        assertEquals(10, h.getAge());
        assertTrue(h.setAge(15));
        assertEquals(15, h.getAge());

        assertFalse(d.setAge(1));
        assertEquals(3, d.getAge());
        assertTrue(d.setAge(15000));
        assertEquals(15000, d.getAge());

    }

    @Test
    public void testHumanAttributes() {
        Human h = new Human("Pepa", "Zdepa", "Pepa00", 10);
        assertEquals("Pepa", h.getName());
        assertEquals("Zdepa", h.getSurname());
        assertEquals("Pepa Zdepa", h.getFullName());
        assertEquals("Pepa00", h.getID());

        h.setID("H4xoooooor");
        assertEquals("H4xooo", h.getID());

        h.setID("-");
        assertEquals("00000-", h.getID());
    }

    @Test
    public void testOwnership() {
        Human h = new Human("Pepa", "Zdepa", "Pepa00", 10);
        Human stranger = new Human("Jozka", "Uprka", "guruslovacka", 80);
        Dog d = new Dog("Alik", 3, h);

        assertEquals(h, d.getOwner());

        d.setOwner(stranger);

        assertEquals(stranger, d.getOwner());

        d.setOwner(h);

        assertEquals(h, d.getOwner());
    }


    @Test
    public void sanityChecks(){
        Human chuck = new Human("Chuck", "Norris", "doggod", Integer.MAX_VALUE);
        Pigeon pigeon = new Pigeon("lubicka", 10, chuck);
        Dog dog = new Dog("Robodog", 125, chuck);
        Snake semir = new Snake("Kobra", 11 );

        assertTrue(dog instanceof Animal);
        assertTrue(pigeon instanceof Animal);
        assertTrue(semir instanceof Animal);

        assertTrue(dog instanceof Receiver);
        assertTrue(chuck instanceof Sender);
        assertTrue(chuck instanceof Receiver);
        assertTrue(pigeon instanceof Sender);

        assertTrue(chuck instanceof Mortal);
        assertTrue(dog instanceof Mortal);
        assertTrue(pigeon instanceof Mortal);
        assertTrue(semir instanceof Mortal);


    }
}