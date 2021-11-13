package cz.upol.jj.seminar2;

public class Country {
    // Sloty třídy
    String name;
    String phoneCode;

    // Metody
    public Country(String name, String phoneCode){
        this.name = name;
        this.phoneCode = phoneCode;
    }

    public void print(){
        System.out.println("Stat{jmeno=" + this.name + ", predvolba=" + this.phoneCode + "}");
    }

    // Gettery
    public String getPhoneCode(){
        return this.phoneCode;
    }

    public String getName() {
        return this.name;
    }

}
