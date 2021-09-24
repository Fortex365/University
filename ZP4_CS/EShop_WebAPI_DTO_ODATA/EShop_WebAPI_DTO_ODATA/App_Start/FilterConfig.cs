using System.Web;
using System.Web.Mvc;

namespace EShop_WebAPI_DTO_ODATA
{
    public class FilterConfig
    {
        public static void RegisterGlobalFilters(GlobalFilterCollection filters)
        {
            filters.Add(new HandleErrorAttribute());
        }
    }
}
