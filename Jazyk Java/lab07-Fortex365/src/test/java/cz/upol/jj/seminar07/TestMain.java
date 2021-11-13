package cz.upol.jj.seminar07;

import org.junit.jupiter.api.Test;

import java.io.*;
import java.util.ArrayList;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

public class TestMain {

    @Test
    public void testOrdersDatabase() {
        File file = new File("ordersDatabase.test");
        file.delete();

        OrdersDataStream ods = new OrdersDataStream();
        OrdersDataStream ods2 = new OrdersDataStream();
        ods2.setSeed(ods.getSeed());

        OrdersDatabase odb = new OrdersDatabase("ordersDatabase.test");
        odb.setOrdersDataStream(ods);

        for (int i = 0; i < 3; i++) {
            odb.loadNextOrder();
        }

        List<Order> saved = new ArrayList<>();
        try {
            Order order1 = odb.loadOrder(ods2);
            odb.removeOrder(order1.id());
            saved.add(odb.loadOrder(ods2));
            saved.add(odb.loadOrder(ods2));
        } catch (IOException e) {
            fail("Chyba vstupu/vystupu.");
        }

        OrdersDatabase odb2 = new OrdersDatabase("ordersDatabase.test");
        try {
            List<Order> orders = odb2.readOrders();
            assertEquals(2, orders.size());
            assertIterableEquals(saved, orders);
        } catch (IOException e) {
            fail("Chyba vstupu/vystupu.");
        }

        file = new File("ordersDatabase.test");
        file.delete();
    }

    @Test
    public void testClient() {
        File file = new File("ordersDatabase.test");
        file.delete();

        OrdersDataStream ods = new OrdersDataStream();

        InputStream systemIn = System.in;

        try {
            StringBuilder sb = new StringBuilder();
            sb.append(1);
            sb.append(System.lineSeparator());
            sb.append("ordersDatabase.test");
            sb.append(System.lineSeparator());
            sb.append(3);
            sb.append(System.lineSeparator());
            sb.append(3);
            sb.append(System.lineSeparator());
            sb.append(2);
            sb.append(System.lineSeparator());
            sb.append(4);
            sb.append(System.lineSeparator());
            sb.append(ods.getId() + 2);
            sb.append(System.lineSeparator());
            sb.append(0);
            sb.append(System.lineSeparator());

            ByteArrayInputStream in = new ByteArrayInputStream(sb.toString().getBytes());
            System.setIn(in);

            Client client = new Client();
            client.loop();

            ods.setSeed(client.getDatabase().getOrdersDataStream().getSeed());

            int id = ods.readInt();
            String customer = ods.readUTF();
            String product = ods.readUTF();
            float price = ods.readFloat();
            int quantity = ods.readInt();
            Order order = new Order(id, customer, product, price, quantity);
            List<Order> orders = new ArrayList<>();
            orders.add(order);
            assertEquals(1, client.getDatabase().readOrders().size());
            assertIterableEquals(orders, client.getDatabase().readOrders());

            System.setIn(systemIn);
        } catch (IOException e) {
            fail("Chyba vstupu/vystupu.");
        } finally {
            file = new File("ordersDatabase.test");
            file.delete();
        }
    }
}