using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace EShop_WebAPI_DTO_ODATA.Models
{
    public class Customer
    {
        //Zákazník, který obsahuje informace o sobě a všechny produkty, které zakoupil
        public int Id { get; set; }
        public string Name { get; set; }
        public string Surname { get; set; }
        public string PhoneNumber { get; set; }
        public string Email { get; set; }
        public string Address { get; set; }


        private ICollection<Product> boughtProducts { get; set; }
        public virtual ICollection<Product> BoughtProducts
        {
            get { return boughtProducts ?? (boughtProducts = new HashSet<Product>()); }
            set { boughtProducts = value; }
        }
    }
}