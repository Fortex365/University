package cz.upol.jj.seminar2;

public class Person {
    int id;
    String firstname;
    String lastname;
    int age;
    String phone;
    Country country;


    public Person(int id, String firstname, String lastname, int age, String phone, Country country){
        this.id = id;
        this.firstname = firstname;
        this.lastname = lastname;
        this.age = age;
        this.phone = phone;
        this.country = country;
    }

    public String getStatus(){
        if (this.age < 18){
            return "junior";
        }
        else if (this.age >= 65){
            return "senior";
        }
        else {
            return "dospely";
        }
    }

    public Country getCountry() {
        return this.country;
    }

    public String getPhone() {
        if (this.country != null){
            String prefix = this.getCountry().getPhoneCode();
            return prefix + this.phone;
        }
        else {
            return this.phone;
        }
    }

    @Override
    public String toString() {
        String c = null;
        if (this.country == null){
            c = "neznamy";
        }
        else{
            c = this.country.getName();
        }
        return "Osoba{" +
                "id=" + id +
                ", jmeno=" + firstname +
                ", prijmeni=" + lastname +
                ", vek=" + age +
                ", telefon=" + this.getPhone() +
                ", status=" + this.getStatus() +
                ", stat=" + c +
                '}';
    }

    public String indexString() {
        return "Osoba{" +
                "id=" + id +
                ", jmeno=" + firstname +
                ", prijmeni=" + lastname +
                ", telefon=" + this.getPhone() +
                '}';
    }

    public void print(){
        String p = this.toString();
        System.out.println(p);
    }

    public String getFirstname() {
        return this.firstname;
    }

    public String getLastname() {
        return this.lastname;
    }

    public int getId() {
        return this.id;
    }

    public void setCountry(Country country) {
        this.country = country;
    }
}
