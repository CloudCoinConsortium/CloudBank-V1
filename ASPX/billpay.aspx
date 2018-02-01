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




        string type = CheckParameter("type");

        if (type == "PayOnce")
        {

        }
        else if (type == "Reocurring")
        {

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
