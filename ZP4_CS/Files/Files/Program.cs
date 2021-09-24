using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Files
{
    class Program
    {
        const string path = @"C:\Users\Luky\Data\School\Vysoká\ZP4_CS\Files\test.txt";

        static void Main(string[] args)
        {
            var drivers = DriveInfo.GetDrives();
            printDriversInfo(drivers);

            Console.Write("Zadej vstupní adresář: ");
            string inputPath = Console.ReadLine();
            DirectoryInfo dir = new DirectoryInfo(inputPath);
            printDirectories(dir, inputPath);


            BinaryMatrix matrix = new BinaryMatrix(path); //Konstruktor třídy
            matrix.WriteMatrix("1 2 3\n4 5 6\n7 8 9\n", path); //Reprezentace stringem kde ' ' odděluje columns, a kde '\n' odděluje řádky
            Console.WriteLine("\n{0}", matrix.GetMatrix()); // Výpis matice

            matrix.Set('5',1,'9'); //Pětku, s prvním výskytem (čteno zleva doprava), změnit na devítku
            matrix.WriteMatrix(matrix.GetMatrix(), path); //Zápis do filu
            matrix.ReadMatrix(path); //Přečtení z filu
            Console.WriteLine("{0}", matrix.GetMatrix()); //Tisk

            Console.Read();
        }

       static void printDriversInfo(DriveInfo[] drives)
        {
            foreach(var i in drives)
            {
                try
                {
                    Console.Write("Jméno disku: {0} ", i.Name);
                    Console.Write("velikost: {0} bytes, ", i.TotalSize);
                    Console.Write("volné místo: {0} bytes.", i.AvailableFreeSpace);
                }
                catch(Exception e) 
                {
                    Console.Write("Error: {0}", e.Message);
                }
                Console.WriteLine();
            }
        }

       static void printDirectories(DirectoryInfo d, string path)
        {
            if(d.Exists == true)
            {
                DirectoryInfo[] insideDirectories = d.GetDirectories();
                FileInfo[] insideFiles = d.GetFiles();
                Console.WriteLine();
                try
                {
                    foreach(var i in insideDirectories)
                    {
                        Console.Write("{0}  ", i.Name);
                        Console.Write("{0}  ", i.CreationTime);
                        Console.WriteLine();
                    }

                    foreach (var i in insideFiles)
                    {
                        Console.Write("{0}  ", i.Name);
                        Console.Write("{0}  ", i.CreationTime);
                        Console.Write("{0}B", i.Length);
                        Console.WriteLine();
                    }
                }
                catch (Exception e)
                {
                    Console.Write("Error: {0}", e.Message);
                }
            }
            else
            {
                Console.WriteLine("Zadaná cesta {0} neexistuje.", path);
            }
        }

    }
}
