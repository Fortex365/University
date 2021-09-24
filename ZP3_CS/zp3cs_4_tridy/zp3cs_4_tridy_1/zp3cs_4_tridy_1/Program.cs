#region Using

using System;
using System.Collections.Generic;
using System.Security.Cryptography.X509Certificates;
using System.Text;

#endregion

namespace zp3cs_4_tridy_1
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
               
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }

            //Dva body pt, pt2
            Bod pt = new Bod(1,5);
            Bod pt2 = new Bod(2, 10);

            //Výpis počtu bodů skrz metodu PocetBodu()
            Console.WriteLine("Počet bodů je: {0}", Bod.PocetBodu());
            Console.Read();

            double vzdalenost = pt.VzdalenostOd(pt2);
            Console.WriteLine("Vzdálenost od bodu {0} je {1:F}", pt2.ToString(), vzdalenost);
            Console.Read();
        }
    }
}
