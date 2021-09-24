using EShop_WebAPI_DTO_ODATA.DTO;
using Microsoft.AspNet.OData;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http;

namespace EShop_WebAPI_DTO_ODATA.Controllers
{
    public class PriceHistoryController : BaseController
    {
        [EnableQuery]
        public IQueryable<DTOPrizeAtThatTime> Get()
        {
            return context.Histories.Select(s => new DTOPrizeAtThatTime() { Id = s.Id, Products = s.Products, Date = s.Date, Prize = s.Prize});
        }

        [EnableQuery]
        public SingleResult<DTOPrizeAtThatTime> Get([FromODataUri] int key)
        {
            IQueryable<DTOPrizeAtThatTime> result = context.Histories.Where(p => p.Id == key).Select(s => new DTOPrizeAtThatTime() { Id = s.Id, Products = s.Products, Date = s.Date, Prize = s.Prize });
            return SingleResult.Create(result);
        }

    }
}