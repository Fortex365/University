using System;
using System.Drawing;

namespace Netreba_Ukol7
{
    class Program
    {
        static void Main(string[] args) //      !!!Desetinná místa zaokrouhluju na 3 pozice!!!
        {
            //Kruhy
            Point pt = new Point(1, 1);

            Circle c1 = new Circle(pt, 10);
            Console.WriteLine("{0}", c1.ToString());

            Circle c2 = new Circle(pt, 100);
            Console.WriteLine("{0}", c2.ToString());

            c1.largerPerimeter(c2);
            c1.largerVolume(c2);
            Console.Write("\n");

            //Obdélníky
            Rectangle r1 = new Rectangle(50, 100);
            Console.WriteLine("{0}", r1.ToString());

            Rectangle r2 = new Rectangle(5, 10);
            Console.WriteLine("{0}", r2.ToString());

            r1.largerPerimeter(r2);
            r1.largerVolume(r2);
            Console.Read();

        }
    }
}
