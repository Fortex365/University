package cz.upol.jj.seminar06;

import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;
import java.util.Optional;
import static cz.upol.jj.seminar06.Action.*;
import static org.junit.jupiter.api.Assertions.*;

public class TestMain {



    @Test
    public void stackPropertiesTest(){
        Stack<Integer> myStack = new Stack<>(2);
        assertEquals(0, myStack.length());
        assertEquals(2, myStack.getCapacity());
        assertTrue(myStack.isEmpty());
        try {
            myStack.push(1);
        } catch (FullStackException  e){
            fail("Plny stack, kde nemel byt.");
        }
        assertFalse(myStack.isEmpty());
        assertFalse(myStack.isFull());
        assertEquals(1, myStack.length());
        myStack.safePush(2);
        assertEquals(2, myStack.length());
        assertTrue(myStack.isFull());
        assertFalse(myStack.isEmpty());
        try {
            myStack.pop();
        } catch (EmptyStackException e){
            fail("Ti, co meli prijit, neprisli.");
        }
        assertEquals(1, myStack.length());
        myStack.safePop();
        assertEquals(0, myStack.length());
        assertFalse(myStack.isFull());
        assertTrue(myStack.isEmpty());

    }

    @Test
    public void unsafeStackTest(){
        Stack<Integer> myStack = new Stack<>(5);
        for(var i = 0; i < 5; i++){
            try {
                myStack.push(i);
            } catch (FullStackException e){
                fail("Plny stack, kde nemel byt.");
            }
        }
        Assertions.assertThrows(FullStackException.class, ()-> myStack.push(1));

        for(var i = 4; i >= 0 ;i--){
            try {
                assertEquals(myStack.peek(), i);
                assertEquals(myStack.pop(), i);
            } catch(EmptyStackException e){
                fail("Prazdny stack, kde nemel byt.");
            }
        }
        Assertions.assertThrows(EmptyStackException.class, () -> myStack.peek());
        Assertions.assertThrows(EmptyStackException.class, () -> myStack.pop());
    }

    @Test
    public void safeStackTest(){
        Stack<Integer> myStack = new Stack<>(5);
        for(var i = 0; i < 5; i++){
            assertTrue(myStack.safePush(i));
        }
        assertFalse(myStack.safePush(1));

        for(var i = 4; i >= 0; i--){
            assertEquals(myStack.safePeek(), Optional.of(i));
            assertEquals(myStack.safePop(), Optional.of(i));
        }
        assertEquals(Optional.empty(), myStack.safePeek());
        assertEquals(Optional.empty(), myStack.safePop());
    }

    @Test
    public void exceptionalRobotTest(){
        ExceptionalRobot r = new ExceptionalRobot("Karel", 5);
        assertFalse(r.hasProgram());
        Action[] actions = new Action[]{LEFT, RIGHT, LEFT, RIGHT, STEP};
        assertDoesNotThrow(() -> r.readActions(actions));
        assertTrue(r.hasProgram());
        for(var i = 4; i >= 0; i--) {
            try {
                assertEquals(actions[i], r.move());
            } catch (NoActionAvailableException e){
                fail("chybi akce");
            }
        }
        assertThrows(NoActionAvailableException.class, () -> r.nextStep());
        assertThrows(NoActionAvailableException.class, () -> r.move());
        assertFalse(r.hasProgram());

        assertThrows(TooManyActionsException.class, () -> r.readActions(new Action[]{LEFT, LEFT, LEFT, LEFT, LEFT, LEFT}));
        assertFalse(r.hasProgram());
        try {
            r.readActions(new Action[]{STEP});
        } catch (TooManyActionsException e){
            fail("Akce se nevlezou, ale mely by.");
        }
        assertEquals("Name: Karel, Action: 100:1000", r.toString());
        try {
            r.move();
        } catch (NoActionAvailableException e){
            fail("Mela byt akce, ale neni.");
        }
        assertEquals("Name: Karel, Action: NONE", r.toString());
    }

    @Test
    public void safeRobotTest(){
        SafeRobot r = new SafeRobot("Galen", 3);
        assertFalse(r.hasProgram());
        Action[] actions = new Action[]{LEFT, RIGHT, LEFT};
        r.readActions(actions);
        assertTrue(r.hasProgram());
        for(var i = 2; i >= 0; i--){
            assertEquals(Optional.of(actions[i]), r.move());
        }
        assertEquals(Optional.empty(), r.nextStep());
        assertEquals(Optional.empty(), r.move());
        assertFalse(r.hasProgram());
        assertFalse(r.readActions(new Action[]{LEFT, LEFT, LEFT, LEFT, LEFT, LEFT}));
        assertFalse(r.hasProgram());
        r.readActions(new Action[]{STEP});
        assertEquals("Name: Galen, Action: 100:1000", r.toString());
        r.move();
        assertEquals("Name: Galen, Action: NONE", r.toString());
    }
}