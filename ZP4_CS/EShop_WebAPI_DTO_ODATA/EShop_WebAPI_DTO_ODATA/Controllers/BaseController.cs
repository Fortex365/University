using EShop_WebAPI_DTO_ODATA.Models;
using Microsoft.AspNet.OData;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace EShop_WebAPI_DTO_ODATA.Controllers
{
    public class BaseController : ODataController
    {
        protected EshopContext context;

        public BaseController()
        {
            context = new EshopContext();
        }
    }
}