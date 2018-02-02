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
        public string time;
    }//End Service Response class

    public void Page_Load(object sender, EventArgs e)
    {
        ServiceResponse ServiceResponse = new ServiceResponse();
        ServiceResponse.bank_server = WebConfigurationManager.AppSettings["thisServerName"];
        ServiceResponse.time = DateTime.Now.ToString();

        string payto = CheckParameter("payto");
        string sendtoemail = CheckParameter("sendtoemail");
        string memo = CheckParameter("memo");
        string daytopay = CheckParameter("daytopay");
        double amount = 0;
        try
        {
            amount = double.Parse(CheckParameter("amount"));
        }
        catch(Exception ex)
        {
            ServiceResponse.status = "fail";
            ServiceResponse.message = "amount could not be parsed";
            var json = new JavaScriptSerializer().Serialize(ServiceResponse);
            Response.Write(json);
            Response.End();
        }
        string signedby = CheckParameter("signedby");
        string youremail = CheckParameter("fromemail");
        string contactinfo = CheckParameter("contactinfo");
        int daysexpiresafter = 0;
        try
        {
            daysexpiresafter = int.Parse(CheckParameter("daysexpiresafter"));
        }
        catch(Exception ex)
        {
            ServiceResponse.status = "fail";
            ServiceResponse.message = "days expires after could not be parsed";
            var json = new JavaScriptSerializer().Serialize(ServiceResponse);
            Response.Write(json);
            Response.End();
        }

        string type = CheckParameter("type");

        BankExcelUtils bxu = new BankExcelUtils();

        if (type == "PayOnce")
        {
            bxu.AddToPayOnce(payto, sendtoemail, memo, daytopay, amount, signedby, youremail, contactinfo, daysexpiresafter);
        }
        else if (type == "Reocurring")
        {
            bxu.AddToReoccuring(payto, sendtoemail, memo, daytopay, amount, signedby, youremail, contactinfo, daysexpiresafter);
        }
        else
        {
            ServiceResponse.status = "fail";
            ServiceResponse.message = "Type not recognized. Type should be PayOnce or Reocurring.";
            var json = new JavaScriptSerializer().Serialize(ServiceResponse);
            Response.Write(json);
            Response.End();
        }


    }

    string CheckParameter(string param)
    {
        if (Request[param] != null)
            return Request[param];
        else
            return "";
    }

</script>
