using EShop_WebAPI_DTO_ODATA.DTO;
using Microsoft.AspNet.OData;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http;

namespace EShop_WebAPI_DTO_ODATA.Controllers
{
    public class CustomerController : BaseController
    {
        [EnableQuery]
        public IQueryable<DTOCustomer> Get()
        {
            return context.Customers.Select(s => new DTOCustomer() { Id = s.Id, Surname = s.Surname, BoughtProducts = s.BoughtProducts });
        }

        [EnableQuery]
        public SingleResult<DTOCustomer> Get([FromODataUri] int key)
        {
            IQueryable<DTOCustomer> result = context.Customers.Where(p => p.Id == key).Select(s => new DTOCustomer() { Id = s.Id, Surname = s.Surname, BoughtProducts = s.BoughtProducts });
            return SingleResult.Create(result);
        }

    }
}