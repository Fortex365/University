using System;

namespace Cv8_Uloha
{
    class Program
    {
        static void Main(string[] args)
        {
            Person me = new Person("Lukáš", "Netřeba", "J.A.Komenského XXX", 20);
            Person friend0 = new Person("Petr", "Neznámý", "B. Němcové XXX", 21);
            Person friend1 = new Person("Filip", "Neznámý", "Palacká XXX", 22);


            Console.WriteLine("{0}", me.ToString());
            Console.WriteLine("{0}", friend0.ToString());
            Console.WriteLine("{0}", friend1.ToString());


            personCollection classStudents = new personCollection();

            classStudents.Add(me);
            classStudents.Add(friend0);
            classStudents.Add(friend1);


            Console.WriteLine("\nHledané jméno je na indexu {0}", classStudents["Filip Neznámý"]);
        }
    }
}
