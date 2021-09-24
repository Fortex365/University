
using System;
using System.Collections.Generic;
using System.Text;

namespace Honorare
{
    class Program
    {
        static void Main(string[] args)
        {
            double dailyRate = nactiDouble("Zadej denní sazbu: ");
            int noOfDays = nactiInt("Zadej počet dnů: ");
            zapisHonorar(spocitejHonorar(dailyRate, noOfDays));
            //zapisHonorar((int)10);
            //zapisHonorar(spocitejHonorar());
            //zapisHonorar(spocitejHonorar(dailyRate:100));

        }

        //Hlavni metoda vracejici double
        private static void zapisHonorar(double v)
        {
            Console.WriteLine("Plat konzultanta je: {0}", v * 1.1);
           
        }

        //Přetížená metoda vracející pokud metoda zapisHoronar bude volana s parametrem (vlastně je to objekt) typu int
        private static void zapisHonorar(int v)
        {
            Console.WriteLine("Plat konzultanta je: {0}", v * 1);

        }

        //Přetížená metoda vracející 0 pokud metoda zapisHoronar bude volana s prazdnym parametrem
        private static void zapisHonorar()
        {
            Console.Write("Plat konzultanta je: 0\n metoda volána bez parametrů");
        }

        private static double spocitejHonorar(double dailyRate=200, int noOfDays=30)
        {
            return dailyRate * noOfDays;
        }

        private static int nactiInt(string p)
        {
            Console.Write(p);
            string line = Console.ReadLine();
            return int.Parse(line);
        }

        private static double nactiDouble(string p)
        {
            Console.Write(p);
            string line = Console.ReadLine();
            return double.Parse(line);

        }
    }
}
