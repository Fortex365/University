package cz.upol.jj.seminar07;

import java.io.DataInput;
import java.io.IOException;
import java.util.Random;
import java.util.prefs.Preferences;

public class OrdersDataStream implements DataInput {
    private long seed;
    private int turn = -1;
    private Random random;
    private int id = 1;
    private String[] products = {"phone", "book", "jacket", "shoes", "television", "camera", "glasses", "table", "chair", "fridge"};
    private String[] names = {"Shakespeare", "Orwell", "Lewis", "Tolkien", "Pratchett"};
    private final int turns = 5;

    public OrdersDataStream() {
        random = new Random();
        seed = random.nextLong();
        random.setSeed(seed);
        Preferences prefs = Preferences.userNodeForPackage(OrdersDataStream.class);
        id = prefs.getInt("id", 0);

    }

    public long getSeed() {
        return seed;
    }

    public void setSeed(long seed) {
        this.seed = seed;
        random.setSeed(seed);
    }

    public int getId() {
        return id;
    }

    @Override
    public void readFully(byte[] b) throws IOException {

    }

    @Override
    public void readFully(byte[] b, int off, int len) throws IOException {

    }

    @Override
    public int skipBytes(int n) throws IOException {
        return 0;
    }

    @Override
    public boolean readBoolean() throws IOException {
        return false;
    }

    @Override
    public byte readByte() throws IOException {
        return 0;
    }

    @Override
    public int readUnsignedByte() throws IOException {
        return 0;
    }

    @Override
    public short readShort() throws IOException {
        return 0;
    }

    @Override
    public int readUnsignedShort() throws IOException {
        return 0;
    }

    @Override
    public char readChar() throws IOException {
        return 0;
    }

    @Override
    public int readInt() throws IOException {
        turn++;
        if (turn % turns == 0) {
            Preferences prefs = Preferences.userNodeForPackage(OrdersDataStream.class);
            prefs.putInt("id", ++id);
            return id;
        } else if (turn % turns == 4)
            return random.nextInt(5) + 1;
        return 0;
    }

    @Override
    public long readLong() throws IOException {
        return 0;
    }

    @Override
    public float readFloat() throws IOException {
        turn++;
        if (turn % turns == 3) {
            return 50 + (float)(Math.round(200 * random.nextFloat() * 10.0) / 10.0);
        }
        return 0;
    }

    @Override
    public double readDouble() throws IOException {
        return 0;
    }

    @Override
    public String readLine() throws IOException {
        return null;
    }

    @Override
    public String readUTF() throws IOException {
        turn++;
        if (turn % turns == 1) {
            return names[random.nextInt(names.length)];
        } else if (turn % turns == 2) {
            return products[random.nextInt(products.length)];
        }
        return null;
    }
}
