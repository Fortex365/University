package cz.upol.jj.seminar2;

import java.util.ArrayList;

public class Index {
    private Person[] persons;
    private Country[] countries;

    public Index(Person[] p, Country[] c){
        this.persons = p;
        this.countries = c;
    }

    public Country[] getCountries() {
        return this.countries;
    }

    public Person[] getPersons() {
        return this.persons;
    }
    
    public int count(String countryName){
        int cnt = 0;

        for (var p: this.persons
             ) {
            // p in persons can have null country
            try{
                if(p.getCountry().getName().equals(countryName)){
                    cnt += 1;
                }
            }
            catch (Exception e){
                // Ignoring right now
            }
        }
        return cnt;
    }

    public int count(String firstname, String lastname){
        int cnt = 0;
        for (var p: this.persons
             ) {
            try{
                if ((p.getFirstname().equals(firstname)) &&
                        (p.getLastname().equals(lastname))){
                    cnt += 1;
                }
            }
            catch (Exception e){
                // Ignoring right now
            }
        }
        return cnt;
    }

    public Person search(int id){
        for (var p: this.persons
             ) {
            if(p.getId() == id){
                return p;
            }
        }
        return null;
    }

    public Person[] search(String countryName){
        ArrayList<Person> ps = new ArrayList<Person>();
        for (var p: this.persons
             ) {
            // getCountry muze vratit null
            try {
                if(p.getCountry().getName().equals(countryName)){
                    ps.add(p);
                }
            }
            catch(Exception e){
                // Ignoring right now
            }
        }

        var i = 0;
        Person[] pers = new Person[ps.size()];
        for (var p: ps
             ) {
            pers[i] = p;
            i += 1;
        }
        return pers;
    }

    public Person[] search(String firstname, String lastname){
        ArrayList<Person> ps = new ArrayList<Person>();
        for (var p: this.persons
        ) {
            try{
                if((p.getFirstname().equals(firstname)) &&
                        (p.getLastname().equals(lastname))){
                    ps.add(p);

                }
            }
            catch (Exception e){
                // Ignoring right now
            }
        }

        var i = 0;
        Person[] pers = new Person[ps.size()];
        for (var p: ps
        ) {
            pers[i] = p;
            i += 1;
        }
        return pers;
    }

    public boolean setPhoneCode(Person person, String phoneCode){
        for (var p: this.persons
             ) {
            if(p == person){
                for (var c: this.countries
                     ) {
                    if(c.getPhoneCode().equals(phoneCode)){
                       p.setCountry(c);
                       return true;
                    }
                }
            }
        }
        return false;
    }

    public void print(){
        System.out.println("Rejstrik{");
        for (var p: this.persons
             ) {
            System.out.println(p.indexString());
        }
        System.out.println("}");
    }
}
