using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography.X509Certificates;
using System.Text;
using System.Threading.Tasks;

namespace zp3cs_4_tridy_1
{
    //Třída
    class Bod
    {
        //Její sloty
        private int x, y;
        private static int pocet = 0;

        //Její metody, toto je konstruktor
        public Bod(int x, int y)
        {
            this.x = x;
            this.y = y;
            Console.WriteLine("x={0}, y={1}", x, y);
            pocet++;
        }

        //Další metoda třídy bodu
        public override string ToString()
        {
            return "x=" + x + ", y=" + y;
        }

        public static int PocetBodu()
        {
            return pocet;
        }

        public double VzdalenostOd(Bod od)
        {
            int xdiff = this.x - od.x;
            int ydiff = this.y - od.x;
            return Math.Sqrt((xdiff * xdiff) + (ydiff * ydiff));
        }
    }
}
