using System;

namespace Kolekce_Nezamestnanost_ZP3CS_Uloha5
{
    class Program
    {
        static void Main(string[] args)
        {
            //Čtyři první měsíce, vytvoření itemu
            Item l = new Item(4.7, Months.Leden);
            Item u = new Item(7.1, Months.Únor);
            Item b = new Item(10.7, Months.Březen);
            Item d = new Item(1.4, Months.Duben);

            Collection year2020 = new Collection();

            //Přidání itemu do kolekce year2020
            year2020.Add(l);
            year2020.Add(u);
            year2020.Add(b);
            year2020.Add(d);

            Console.WriteLine("Průměr v kolekci year2020 je {0} %", year2020.Avarage());

            Console.WriteLine("Minimální nezaměstnanost měsíce: {0}", year2020.findMin());

            Console.WriteLine("Maximální nezaměstnanost měsíce: {0}", year2020.findMax());
        }
    }
}
