<%@ Page Language="C#" Debug="true"  Async="true"%>
<%@ Import namespace="System.Web.Configuration" %>
<%@ Import namespace="System" %>
<%@ Import Namespace="System.IO" %>
<%@ Import namespace="System.Data.SqlClient" %>
<%@ Import namespace="System.Web.Configuration" %>
<%@ Import namespace="Founders" %>
<%@ Import namespace="System.Web.Script.Serialization" %>

<script language="c#" runat="server">
    public class ServiceResponse
    {
        public string bank_server;
        public string status;
        public string message;
        public int ones;
        public int fives;
        public int twentyfives;
        public int hundreds;
        public int twohundredfifties;
        public string time;
    }//End Service Response class


    //static string path = WebConfigurationManager.AppSettings["root"];


    public void Page_Load(object sender, EventArgs e)
    {
        //string path = Request.QueryString["k"];
        string path = Request["pk"];

        ServiceResponse response = new ServiceResponse();
        response.bank_server = WebConfigurationManager.AppSettings["thisServerName"];

        if (path == null)
        {
            //Response.Write("Request Error: Private key not specified");
            response.status = "fail";
            response.message = "Private key not specified";
            var serialjson = new JavaScriptSerializer().Serialize(response);
            Response.Write(serialjson);
            Response.End();
        }
        if (path != WebConfigurationManager.AppSettings["root"])
        {
            response.status = "fail";
            response.message = "Private key not correct";
            var serialjson = new JavaScriptSerializer().Serialize(response);
            Response.Write(serialjson);
            Response.End();
        }

        FileUtils fileUtils = FileUtils.GetInstance(HttpRuntime.AppDomainAppPath.ToString() + @"\" + path + @"\");
        //FileUtils fileUtils = FileUtils.GetInstance(@"H:\Banks\Preston\"+path+@"\");


        response.status = "coins_shown";
        response.time = DateTime.Now.ToString("yyyy-MM-dd h:mm:tt");
        Banker bank = new Banker(fileUtils);
        int[] bankTotals = bank.countCoins(fileUtils.bankFolder);
        int[] frackedTotals = bank.countCoins(fileUtils.frackedFolder);
        response.ones = bankTotals[1] + frackedTotals[1];
        response.fives = bankTotals[2] + frackedTotals[2];
        response.twentyfives = bankTotals[3] + frackedTotals[3];
        response.hundreds = bankTotals[4] + frackedTotals[4];
        response.twohundredfifties = bankTotals[5] + frackedTotals[5];
        var json = new JavaScriptSerializer().Serialize(response);
        Response.Write(json);
        Response.End();
    }



</script>
