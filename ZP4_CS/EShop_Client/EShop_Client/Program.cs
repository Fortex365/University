using Default;
using EShop_WebAPI_DTO_ODATA.DTO;
using EShop_WebAPI_DTO_ODATA.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EShop_Client
{
    class Program
    {
        static void Main(string[] args)
        {
            Container c = new Container(new Uri("https://localhost:44308/"));
            var products = c.Product.Where(p => p.Name == "Kolo");
            Console.WriteLine("Kolo:");
            foreach (DTOProduct s in products)
            {
                Console.WriteLine("Historie:");
                var history = s.Histories;
                foreach(PrizeAtThatTime d in history)
                {
                    Console.WriteLine($"Cena: {d.Prize}, Datum: {d.Date}");
                }
                Console.WriteLine();

                Console.WriteLine("Zakoupeno od:");
                var customers = s.Customers;
                foreach(Customer p in customers)
                {
                    Console.WriteLine($"Prijmeni: {p.Surname}, ID: {p.Id}");
                }
                Console.Read();
            }
        }
    }
}
