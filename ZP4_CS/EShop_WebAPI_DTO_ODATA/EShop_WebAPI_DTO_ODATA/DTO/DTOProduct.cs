using EShop_WebAPI_DTO_ODATA.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace EShop_WebAPI_DTO_ODATA.DTO
{
    //Velice pravděpodobně by se mělo i zde v kolekcích odkazovat na DTO třídy, všiml jsem si toho až u napojení na druhé aplikace, kde se 
    //skrze produkt dostanu na jeho DTO, ale uvnitř jej se dostanu na celého zákazníka např.
    public class DTOProduct
    {
        public int Id { get; set; }
        public string Name { get; set; }

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