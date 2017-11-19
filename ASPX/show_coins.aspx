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
        public string server;
        public string status;
        public int ones;
        public int fives;
        public int twentyfives;
        public int hundreds;
        public int twohundredfifties;
        public string time;
    }//End Service Response class

	//Sample usage:
    // https://myname.cloudcoin.global/show_coins.aspx?k=0DECE3AF-83EC-435B-8C39-E2A5D0EA8676
	
    
    public void Page_Load(object sender, EventArgs e)
    {
		string path = Request.QueryString["k"];
	
		FileUtils fileUtils = FileUtils.GetInstance(@"H:\Banks\Preston\"+path+@"\");
	
        ServiceResponse response = new ServiceResponse();
        response.server = WebConfigurationManager.AppSettings["thisServerName"];
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
