using Microsoft.VisualBasic;
using System;
using System.Collections.Generic;
using System.Text;

namespace Netreba_Ukol7
{
    class Rectangle : IShape, ICompare
    {
        //DEFAULTNÍ INCIALIZACE INSTANCE TŘÍDY
        private double mainSide = 1;
        private double minorSide = 1;

        //KONSTRUKTOR
        public Rectangle(int a, int b)
        {
            if((a > 0) && (b > 0))
            {
                this.mainSide = a;
                this.minorSide = b;

            }
            else
            {
                throw new ArgumentException("Error: Cannoct construct rectangle, invalid arguments.");
            }
        }

        public void setMainSide(int a)
        {
            this.mainSide = a;
        }

        //ROZHRANÍ
        public double Volume()
        {
            return Math.Round(this.mainSide * this.minorSide, 3);
        }

        public double Perimeter()
        {
            return Math.Round(2 * (this.mainSide + this.minorSide), 3);
        }

        public void largerVolume(object r)
        {
            Rectangle r2 = (Rectangle)r;
            double v1 = this.Volume();
            double v2 = r2.Volume();

            if(v1 > v2)
            {
                Console.WriteLine("První obdélník má větší obsah.");
            }
            else
            {
                Console.WriteLine("Druhý obdélník má větší obsah.");
            }
        }

        public void largerPerimeter(object r)
        {
            Rectangle r2 = (Rectangle)r;
            double p1 = this.Perimeter();
            double p2 = r2.Perimeter();

            if(p1 > p2)
            {
                Console.WriteLine("První obdélník má větší obvod.");
            }
            else
            {
                Console.WriteLine("Druhý obdélník má větší obvod.");
            }
        }


        //KONSTRUKTORY A SELECTORY
        public void setMinorSide(int a)
        {
            this.mainSide = a;
        }

        public double getMainSide()
        {
            return this.mainSide;
        }

        public double getMinorSide()
        {
            return this.minorSide;
        }

        //PRINT METODA
        public override string ToString()
        {
            return string.Format("Útvar je obdélník, obvod je: {0} obsah je {1}", this.Perimeter(), this.Volume());
        }
    }
}

