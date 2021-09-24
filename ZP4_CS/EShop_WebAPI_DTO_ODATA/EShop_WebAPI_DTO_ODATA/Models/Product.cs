using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace EShop_WebAPI_DTO_ODATA.Models
{
    public class Product
    {
        //Produkt, který se navazuje na jeho historii (cena, datum)
        public int Id { get; set; }
        public string ProductName { get; set; }


        private ICollection<Customer> customers { get; set; }
        public virtual ICollection<Customer> Customers
        {
            get { return customers ?? (customers = new HashSet<Customer>()); }
            set { customers = value; }
        }

        private ICollection<PrizeAtThatTime> histories { get; set; }
        public virtual ICollection<PrizeAtThatTime> Histories
        {
            get { return histories ?? (histories = new HashSet<PrizeAtThatTime>()); }
            set { histories = value; }
        }
    }
}