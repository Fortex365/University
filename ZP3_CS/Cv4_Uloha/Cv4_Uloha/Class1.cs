using System;
using System.Collections.Generic;
using System.Text;

namespace Cv4_Uloha
{
    class Kvadr
    {
        //Sloty 
        public int a, b, c;

        //Konstruktory
        public Kvadr(int a, int b, int c)
        {
            this.a = a;
            this.b = b;
            this.c = c;
            Console.WriteLine("Objekt vytvořen se strany: a = {0}, b = {1}, c = {2}", a, b, c);
        }

        public Kvadr()
        {
            this.a = 1;
            this.b = 1;
            this.c = 1;
            Console.WriteLine("Objekt vytvořen se strany: a = {0}, b = {1}, c = {2}", this.a, this.b, this.c);
        }

        public Kvadr(int a)
        {
            this.a = a;
            this.b = 1;
            this.c = 1;
            Console.WriteLine("Objekt vytvořen se strany: a = {0}, b = {1}, c = {2}", a, this.b, this.c);
        }

        public Kvadr(int a, int b)
        {
            this.a = a;
            this.b = b;
            this.c = 1;
            Console.WriteLine("Objekt vytvořen se strany: a = {0}, b = {1}, c = {2}", a, b, this.c);
        }



        //Pro výpis slotů daného objektu
        public override string ToString()
        {
            return "a = " + a + "b = " + b + "c = " + c;
        }


        //Metody pro práci s objektem třídy kvádr
        public int SpoctiObjem()
        {
            return (a * b * c);
        }

        public int SpoctiPovrch()
        {
            return (2 * (a * b + b * c + a * c));
        }
    }
}
