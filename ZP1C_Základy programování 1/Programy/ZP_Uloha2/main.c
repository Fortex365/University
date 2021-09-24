#include <stdio.h>
#include <stdlib.h>
#include <string.h>
typedef enum {
    TRUE = 1,
    FALSE = 0 } Bool;
#define velikostDatabaze 100
#define tiskFormat "||%10s %10s || %30s || %2d. %2d. %4d || %9s || %25s||\n"

typedef struct {
    char den;
    char mesic;
    int rok;
} date;

typedef struct {
    char jmeno[64];
    char prijmeni[64];
    char adresa[64];
    date datum;
    char telefon[10];
    char email[128];
} osoba;

osoba vytvor_osobu(char jmeno[], char prijmeni[], char adresa[], char den, char mesic,
                   int rok, char telefon[], char email[]);

void vytvor_seznam(osoba s[]){
    for (int i = 0; i < velikostDatabaze; i++) {
        s[i] = vytvor_osobu("", "", "", 0, 0, 0, "", "");
    }
}

osoba vytvor_osobu(char jmeno[], char prijmeni[], char adresa[], char den, char mesic,
                   int rok, char telefon[], char email[]){
    osoba osoba;
    strcpy(osoba.jmeno, jmeno);
    strcpy(osoba.prijmeni, prijmeni);
    strcpy(osoba.adresa, adresa);
    osoba.datum.den = den;
    osoba.datum.mesic = mesic;
    osoba.datum.rok = rok;
    strcpy(osoba.telefon, telefon);
    strcpy(osoba.email, email);
    return osoba;
}

void vloz(osoba s[], osoba o){
    int i = 0;
    while(strcmp(s[i].jmeno, "") != 0){
        i++;
    }
    s[i] = o;
}

Bool najdi_osobu(char kde[], char co[], osoba s[]){
    int i = 0;
    if (strcmp(kde, "jmeno") == 0) {
        while(strcmp(s[i].jmeno, "") != 0){
            if(strcmp(s[i].jmeno, co) == 0){
                return TRUE;
            }
            i++;
        }
    }
    else if (strcmp(kde, "prijmeni") == 0) {
        while(strcmp(s[i].jmeno, "") != 0){
            if(strcmp(s[i].prijmeni, co) == 0){
                return TRUE;
            }
            i++;
        }
    }
    else if (strcmp(kde, "adresa") == 0) {
        while(strcmp(s[i].jmeno, "") != 0){
            if(strcmp(s[i].adresa, co) == 0){
                return TRUE;
            }
            i++;
        }
    }
    else if (strcmp(kde, "email") == 0) {
        while(strcmp(s[i].jmeno, "") != 0){
            if(strcmp(s[i].email, co) == 0){
                return TRUE;
            }
            i++;
        }
    }
    else if (strcmp(kde, "telefon") == 0) {
        while(strcmp(s[i].jmeno, "") != 0){
            if(strcmp(s[i].telefon, co) == 0){
                return TRUE;
            }
            i++;
        }
    }
    return FALSE;
}

void tiskDatabaZeNadpis(){
    printf("||%10s %10s || %30s || %2s. %2s. %4s || %9s || %25s||\n", "Jmeno", "Prijmeni", "Adresa", "d", "m", "rok", "Telefon", "Email");
}

void tisk(osoba s[]){
    int i = 0;
    tiskDatabaZeNadpis();
    while(strcmp(s[i].jmeno, "") != 0){
        printf(tiskFormat, s[i].jmeno, s[i].prijmeni, s[i].adresa, s[i].datum.den, s[i].datum.mesic, s[i].datum.rok, s[i].telefon, s[i].email);
        i++;
    }
}

void tiskOsoby(osoba s){
    tiskDatabaZeNadpis();
    printf(tiskFormat, s.jmeno, s.prijmeni, s.adresa, s.datum.den, s.datum.mesic, s.datum.rok, s.telefon, s.email);
}

void tiskNajdu(char kde[], char co[], osoba s[]){
    printf("najdi_osobu(\"%s\", \"%s\", databaze); => %s\n", kde, co, najdi_osobu(kde, co, s) ? "TRUE" : "FALSE");
}

osoba nejmladsi(osoba s[]){
    int i = 1;
    osoba o = s[0];
    while (strcmp(s[i].jmeno, "") != 0) {
        if (s[i].datum.rok < o.datum.rok) {
            o = s[i];
        }
        else if (s[i].datum.rok == o.datum.rok){
            if (s[i].datum.mesic < o.datum.mesic) {
                o = s[i];
            }
            else if (s[i].datum.mesic == o.datum.mesic){
                if (s[i].datum.den < o.datum.den) {
                    o = s[i];
                }
            }
        }
        i++;
    }
    return o;
}

int main(int argc, const char * argv[]) {
    osoba databaze[velikostDatabaze];
    vytvor_seznam(databaze);
    
    vloz(databaze, vytvor_osobu("Ivan", "Houska", "U Diry 4, Brno", 1, 1, 1111, "111222333", "ih@kocourkov.gov"));
    vloz(databaze, vytvor_osobu("Jan", "Horvat", "Nova Ulice 22, Olomouc", 2, 1, 1211, "121222333", "jh@kocourkov.gov"));
    vloz(databaze, vytvor_osobu("Petr", "Novak", "Hlavni 44, Prerov", 11, 3, 1121, "111222343", "pn@kocourkov.gov"));
    vloz(databaze, vytvor_osobu("Martin", "Kobliha", "Vedlejsi 11, Brno", 7, 8, 2222, "111222353", "mk@kocourkov.gov"));
    vloz(databaze, vytvor_osobu("Tomas", "Babovka", "Bezdomovec", 8, 9, 1191, "111222339", "tb@kocourkov.gov"));
    vloz(databaze, vytvor_osobu("Michal", "Krajic", "U Hute 66, Opava", 11, 12, 1221, "111222883", "mk@kocourkov.gov"));
    vloz(databaze, vytvor_osobu("Pavel", "Chleba", "U Kocoura 24, Modrice", 9, 3, 3311, "111222773", "pch@kocourkov.gov"));
    vloz(databaze, vytvor_osobu("Rychar", "Bageta", "Hospodska 114, Kundice", 7, 2, 1321, "111226633", "rb@kocourkov.gov"));
    vloz(databaze, vytvor_osobu("Roman", "Rohlik", "Zatacka 88, Havirov", 22, 1, 2331, "111255333", "rr@kocourkov.gov"));
    
    tisk(databaze);
    osoba nej = nejmladsi(databaze);
    printf("\nNejmladsi:\n");
    tiskOsoby(nej);
    
    printf("\n");
    tiskNajdu("jmeno", "Roman", databaze);
    tiskNajdu("prijmeni", "Krajic", databaze);
    tiskNajdu("adresa", "U Kocoura 24, Modrice", databaze);
    tiskNajdu("email", "rr@kocourkov.gov", databaze);
    tiskNajdu("telefon", "111222339", databaze);
    tiskNajdu("telefon", "777777777", databaze);
    tiskNajdu("haf", "111222339", databaze);
    
    return 0;
}
