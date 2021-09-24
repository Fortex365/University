using System;

namespace Cv4_Uloha
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {

            }
            catch(Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
            finally
            {
            //Zadat parametry zde
            Console.WriteLine("Objekt kva1:");
            Kvadr kva1 = new Kvadr(2);

            //Objem
            Console.WriteLine("Objem kvadru je: {0}", kva1.SpoctiObjem());
            
            //Povrch
            Console.WriteLine("Povrch kvadru je: {0}", kva1.SpoctiPovrch());
            //Console.Read(); 
            }
        }
    }
}
