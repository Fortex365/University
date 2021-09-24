using System;
using System.Collections.Generic;
using System.Drawing;
using System.IO;
using System.Security.Cryptography;
using System.Text;

namespace Netreba_Ukol7
{
    class Circle : IShape, ICompare
    {
        //DEFAULTNÍ INICIALIZACE INSTANCE TŘÍDY
        private Point center = new Point(0, 0);
        private int radius = 1;

        //KONSTRUKTOR
        public Circle(Point pt, int r)
        {
            if (r > 0)
            {
                this.center = pt;
                this.radius = r;

            }
            else
            {
                throw new ArgumentException("Error: Invalid circle radius.");
            }
        }

        //ROZHRANI
       public double Perimeter()
        {
            return Math.Round(2 * radius * Math.PI, 3);
        }

       public double Volume()
        {
            return Math.Round(Math.PI * Math.Pow(radius, 2), 3);
        }

       public void largerPerimeter(Object c) //První kruh, porovnáváme stylem c1.largerPrimeter(c2)
        {
            Circle c2 = (Circle)c;
            double p1 = this.Perimeter(); 
            double p2 = c2.Perimeter();

            if (p1 > p2)
            {
                Console.WriteLine("První kruh má větší obvod.");
            }
            else
            {
                Console.WriteLine("Druhý kruh má větší obvod.");
            }
            
        }

       public void largerVolume(Object c) //První kruh, porovnáváme stylem c1.largerVolume(c2)
        {
            Circle c2 = (Circle)c;
            double v1 = this.Perimeter();
            double v2 = c2.Perimeter();

            if(v1 > v2)
            {
                Console.WriteLine("První kruh má větší obsah.");

            }
            else
            {
                Console.WriteLine("Druhý kruh má větší obsah.");

            }
        }


        //KONSTRUKTORY A SELEKTORY
        public void setPoint(Point pt)
        {
            this.center = pt;
        }

        public void setRadius(int r)
        {
            this.radius = r;
        }

        public Point getPoint()
        {
            return this.center;
        }

        public int getRadius()
        {
            return this.radius;
        }

        //PRINT METODA
        public override string ToString()
        {
            return string.Format("Útvar je kruh, obvod je: {0} obsah je {1}", this.Perimeter(), this.Volume());
        }
    }
}
