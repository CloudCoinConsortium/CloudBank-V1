<%@ Page Language="C#" Debug="true"  Async="true"%>
<%@ Import namespace="System.Web.Configuration" %>
<%@ Import namespace="System" %>
<%@ Import Namespace="System.IO" %>
<%@ Import namespace="System.Data.SqlClient" %>
<%@ Import namespace="System.Web.Configuration" %>
<%@ Import namespace="Founders" %>
<%@ Import namespace="System.Web.Script.Serialization" %>

<script language="c#" runat="server">

    //static string path = WebConfigurationManager.AppSettings["root"];
    //static FileUtils fileUtils = FileUtils.GetInstance( Directory.GetCurrentDirectory()+ path+@"\");
    public class ServiceResponse
    {
        public string bank_server;
        public string status;
        public string message;
        public string time;
    }



    public void Page_Load(object sender, EventArgs e)
    {
        ServiceResponse serviceResponse = new ServiceResponse();
        serviceResponse.bank_server = WebConfigurationManager.AppSettings["thisServerName"];
        serviceResponse.status = "fail";
        serviceResponse.time = DateTime.Now.ToString();

        string path = Page.Request.Form["pk"];
        if (path == null)
        {
            serviceResponse.message = "Request Error: Private key not specified";
            var json = new JavaScriptSerializer().Serialize(serviceResponse);
            Response.Write(json);
            Response.End();
        }
        FileUtils fileUtils = FileUtils.GetInstance( Directory.GetCurrentDirectory()+ path+@"\");

        string id = Request["rn"];
        string FileLocation = AppDomain.CurrentDomain.BaseDirectory + @"\" + path + @"\Receipts\" + id + ".json";

        

        if(id == null)
        {
            serviceResponse.message = "Error: No Receipt Id in Request.";
            var json = new JavaScriptSerializer().Serialize(serviceResponse);
            Response.Write(json);
            Response.End();
        }else if(!File.Exists(FileLocation))
        {
            serviceResponse.message = "Error: File not Found " + AppDomain.CurrentDomain.BaseDirectory + @"\" + path+@"\Receipts\"+ id + ".json";
            var json = new JavaScriptSerializer().Serialize(serviceResponse);
            Response.Write(json);
            Response.End();
        }
        else
        {
            string json = "";
            using (StreamReader sr = File.OpenText(FileLocation))
            {

                while (!sr.EndOfStream)
                {
                    json += sr.ReadLine();
                }
            }
            Response.Write(json);
            Response.End();
        }
    }



</script>
