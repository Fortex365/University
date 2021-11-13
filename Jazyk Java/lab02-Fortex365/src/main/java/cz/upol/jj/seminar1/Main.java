package cz.upol.jj.seminar1;

import javax.sound.midi.SysexMessage;

public class Main {
    public static void main(String[] args) {
    }

    public static void prvocisla(int toN){
        for(int i = 0; i < toN; i++){
            if(jePrvocislo(i)){
                System.out.print(i + ", ");
            }
        }
    }

    public static boolean jePrvocislo(int number) {
        int i,v=1;
        // iterate through 2 to a/2
        for (i=2;i<=number/2;i++)
        {
            v = number%i;
            // if remainder is zero, the number is not prime
            if(v==0)
                break;
        }
        if (v==0 || number==1 || number == 0 || number < 0)
            return false;
        else
            return true;
    }

    public static int nasobHelp(int number, int times) {
        if (number == 0 || times == 0) {
            return 0;
        }
        if (times == 1) {
            return number;
        }
        if (number == 1) {
            return times;
        }
        return number + nasobHelp(number, times - 1);
    }

    public static int nasob(int number, int times) {
        int m = nasobHelp(number, Math.abs(times));
        return (times < 0) ? -m : m;
    }

    public static void ctverec(int size){
        if(size <= 0){
            System.out.print("");
        }
        else {
            if(size == 1){
                System.out.print(" -\n| |\n -\n");
            }
            else{
                // Print head
                System.out.print(" ");
                for(int i = 0; i < size; i++){
                    System.out.print("-");
                }
                System.out.println();

                // Print body
                for(int rows = 0; rows < size; rows++){
                    for(int columns = 0; columns < size; columns++){
                        if(columns == 0){
                            System.out.print("| ");
                        }
                        else if(columns == size-1){
                            System.out.print(" |");
                        }
                        else {
                            System.out.print(" ");
                        }
                    }
                    System.out.println();
                }

                // Print back
                System.out.print(" ");
                for(int i = 0; i < size; i++){
                    System.out.print("-");
                }
                System.out.println();
            }
        }
    }

    public static String slovo(int n){
        String result;
        switch (n){
            case 1:
                result = "jedna";
                return result;
            case 2:
                result = "dva";
                return result;
            case 3:
                result = "tři";
                return result;
            case 4:
                result = "čtyři";
                return result;
            case 5:
                result = "pět";
                return result;
            case 6:
                result = "šest";
                return result;
            case 7:
                result = "sedm";
                return result;
            case 8:
                result = "osm";
                return result;
            case 9:
                result = "devět";
                return result;
            case 10:
                result = "deset";
                return result;
            default:
                result = "neznám";
                return result;
        }
    }
}
