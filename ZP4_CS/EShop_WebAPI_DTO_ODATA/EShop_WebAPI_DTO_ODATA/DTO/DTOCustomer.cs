using EShop_WebAPI_DTO_ODATA.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace EShop_WebAPI_DTO_ODATA.DTO
{
    public class DTOCustomer
    {
        public int Id { get; set; }
        public string Surname { get; set; }


        private ICollection<Product> boughtProducts { get; set; }
        public virtual ICollection<Product> BoughtProducts
        {
            get { return boughtProducts ?? (boughtProducts = new HashSet<Product>()); }
            set { boughtProducts = value; }
        }
    }
}