using EShop_WebAPI_DTO_ODATA.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace EShop_WebAPI_DTO_ODATA.DTO
{
    public class DTOPrizeAtThatTime
    {
        public int Id { get; set; }
        public int Prize { get; set; }
        public DateTime Date { get; set; }

        private ICollection<Product> products { get; set; }
        public virtual ICollection<Product> Products
        {
            get { return products ?? (products = new HashSet<Product>()); }
            set { products = value; }
        }
    }
}