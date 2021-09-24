using System;

namespace zp3cs_6_dedicnost_1
{
    class Program
    {
        

        static void Main()
        {
            try
            {
               

            }
            catch (Exception ex)
            {
                Console.WriteLine("Exception: {0}", ex.Message);
            }

            Vozidlo v1 = new Vozidlo();
            Console.WriteLine(v1.ToString());

            Auto a1 = new Auto();
            Console.WriteLine(a1.ToString());

            Letadlo l1 = new Letadlo();
            Console.Write(l1.ToString());
            Console.Read();
        }
    }
}
