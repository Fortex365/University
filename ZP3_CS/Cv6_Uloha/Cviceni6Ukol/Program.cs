using System;

namespace Cviceni6Ukol
{
    class Program
    {
        static void Main(string[] args)
        {
            Person me = new Person("Lukáš Netřeba", "xxxxxx/xxxx", "Male");
            me.personPrint();
            Console.Write("\n");

            Student_School me1 = new Student_School("Lukáš Netřeba", "xxxxxx/xxxx", "Male", "PřF UPOL");
            me1.personPrint();
            Console.Write("\n");

            Student me2 = new Student("Lukáš Netřeba", "xxxxxx/xxxx", "Male", "PřF UPOL", "Informatika");
            me2.personPrint();
            Console.Write("\n");

        }
    }
}
