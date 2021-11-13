package cz.upol.jj.seminar07;

public record Order(int id, String customer, String product, float price, int quantity) {
    /*public byte[] getBytes(){
        String a = "Order[id=" + id + ", " + "customer=" + customer + ", " + "product=" + product + ", " +
                "price=" + price + ", " + "quantity=" + quantity + "]\n";
        return a.getBytes();
    }*/

    @Override
    public String toString() {
        return "Order[id=" + id + ", " + "customer=" + customer + ", " + "product=" + product + ", " +
                "price=" + price + ", " + "quantity=" + quantity + "]";
    }

    public String toStringN() {
        return "Order[id=" + id + ", " + "customer=" + customer + ", " + "product=" + product + ", " +
                "price=" + price + ", " + "quantity=" + quantity + "]" + System.lineSeparator();
    }
}
