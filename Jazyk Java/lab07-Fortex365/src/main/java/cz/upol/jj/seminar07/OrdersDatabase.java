package cz.upol.jj.seminar07;

import java.io.*;
import java.sql.Array;
import java.util.ArrayList;
import java.util.List;

public class OrdersDatabase {
    private String filename;
    private OrdersDataStream ods;
    private File database = null;

    OrdersDatabase(String filename){
        this.filename = filename;
        try{
          this.database = new File(filename);
        }
        catch (NullPointerException e){
            return;
        }
    }

    public OrdersDataStream getOrdersDataStream(){
        return this.ods;
    }

    void setOrdersDataStream(OrdersDataStream ordersDataStream){
        this.ods = ordersDataStream;
    }

    Order loadOrder(DataInput di){
        Order out = null;

        int id, quantity;
        String customer, product;
        float price;
        try{
            id = di.readInt();
            customer = di.readUTF();
            product = di.readUTF();
            price = di.readFloat();
            quantity = di.readInt();

            out = new Order(id, customer, product, price, quantity);
        }
        catch (IOException e){
        }
        finally {
            return out;
        }
    }

    void loadNextOrder(){
        File file = new File(filename);
        Order order = null;
        FileOutputStream s = null;

        if( file.exists () && !file.isDirectory ()) {
            order = loadOrder(ods);
            try {
                s = new FileOutputStream (filename);
                s.write(order.toStringN().getBytes());
            }
            catch (FileNotFoundException e){
            }
            catch (IOException e){

            }
            finally
            {
                if (s != null ) {
                    try{
                    s.close();
                    }
                    catch (IOException e){

                    }
                }
            }
        }
    }

    void writeOrders(List<Order> orders, boolean append) throws IOException{
        File file = new File(filename);
        FileOutputStream s = null;

        if(append == true){
            if( file.exists () && !file.isDirectory ()){
                try{
                    s = new FileOutputStream (filename);
                }catch (FileNotFoundException e){
                }
                finally {
                    for (var o : orders){
                        try{
                            s.write(o.toStringN().getBytes());
                        }catch (IOException e){
                            throw new IOException(e);
                        }
                    }
                    if (s != null ) {
                        try{
                            s.close();
                        }
                        catch (IOException e){
                            throw new IOException(e);
                        }
                    }
                }
            }
        }
        else {
            file.delete();
            File newfile = new File(filename);

            if( newfile.exists () && !newfile.isDirectory ()){
                try{
                    s = new FileOutputStream (filename);
                }catch (FileNotFoundException e){
                }
                finally {
                    for (var o : orders){
                        try{
                            s.write(o.toStringN().getBytes());
                        }catch (IOException e){
                            throw new IOException(e);
                        }
                    }
                    if (s != null ) {
                        try{
                            s.close();
                        }
                        catch (IOException e){
                            throw new IOException(e);
                        }
                    }
                }
            }
        }

    }

    List<Order> readOrders() throws IOException{
        File file = new File(filename);
        FileInputStream s = null;
        ArrayList<StringBuilder> orders = new ArrayList<>();

        if( file.exists () && !file.isDirectory ()){
            try {
                s = new FileInputStream (filename);
                int c;
                StringBuilder order = new StringBuilder();
                while (( c = s.read ()) != -1) {
                    if((char)c == '\n'){
                        orders.add(order);
                        order = new StringBuilder();
                    }else {
                        order.append((char)c);
                    }
                }
            }
            catch (FileNotFoundException e){
            }
            catch (IOException e){
                throw new IOException(e);
            }
            finally {
                if ( s != null ) {
                    try{
                        s.close();
                    }
                    catch (IOException e){
                        throw new IOException(e);
                    }
                }
            }
        }
        //Nevím jak ze stringu udělat record třídy Order v orders
        ArrayList<Order> result = new ArrayList<>();
        for (var i: orders){
            Order o = new Order(
                    Integer.parseInt(getBetweenStrings(i.toString(),"index=", ",")),
                    getBetweenStrings(i.toString(),"customer=", ","),
                    getBetweenStrings(i.toString(),"product=", ","),
                    Float.parseFloat(getBetweenStrings(i.toString(),"price=", ",")),
                    Integer.parseInt(getBetweenStrings(i.toString(),"quantity=", "]"))
                    );
            result.add(o);
        }
        return result;
    }

    private String getBetweenStrings(String text, String textFrom, String textTo) {

        String result = "";

        result = text.substring(text.indexOf(textFrom) + textFrom.length(), text.length());

        result = result.substring(0, result.indexOf(textTo));

        return result;
    }

    boolean removeOrder(int id){
        List<Order> o = null;
        try{
            o = readOrders();
        }catch (IOException e){
        }

        for(var i : o){
            if(i.id() == id){
                return true;
            }
        }
        return false;
    }

    @Override
    public String toString() {
        List<Order> o = null;
        try{
            o = readOrders();
        }catch (IOException e){
        }


        StringBuilder s = new StringBuilder();
        s.append("{\n");
        for (var i : o){
            s.append(i.toStringN());
        }
        s.append("}\n");

        return s.toString();
    }
}
