using EShop_WebAPI_DTO_ODATA.DTO;
using Microsoft.AspNet.OData;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http;

namespace EShop_WebAPI_DTO_ODATA.Controllers
{
    public class ProductController : BaseController
    {
        [EnableQuery]
        public IQueryable<DTOProduct> Get()
        {
            return context.Products.Select(s => new DTOProduct() { Id = s.Id, Name = s.ProductName, Customers = s.Customers, Histories = s.Histories  });
        }

        [EnableQuery]
        public SingleResult<DTOProduct> Get([FromODataUri] int key)
        {
            IQueryable<DTOProduct> result = context.Products.Where(p => p.Id == key).Select(s => new DTOProduct() { Id = s.Id, Name = s.ProductName, Customers = s.Customers, Histories = s.Histories });
            return SingleResult.Create(result);
        }
    }
}