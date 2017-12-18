<%@ Page Language="C#" Debug="true"  Async="true"%>
<%@ Import namespace="System.Web.Configuration" %>
<%@ Import namespace="System" %>
<%@ Import Namespace="System.IO" %>
<%@ Import namespace="System.Data.SqlClient" %>
<%@ Import namespace="System.Web.Configuration" %>
<%@ Import namespace="Founders" %>
<%@ Import namespace="System.Web.Script.Serialization" %>
<%@ Import Namespace="System.Net.Mail" %>
<%@ Import Namespace="System.Net.Mime" %>



<script language="c#" runat="server">



    static string path = WebConfigurationManager.AppSettings["root"];
    static FileUtils fileUtils = FileUtils.GetInstance(@"H:\Banks\Preston\"+path+@"\");



    public class ServiceResponse
    {
        public string server;
        public string status;

        public string message;
        public string time;
    }//End Service Response class

    public void Page_Load(object sender, EventArgs e)
    {

        ServiceResponse response = new ServiceResponse();
        response.server = "Preston.CloudCoin.global";
        response.time = DateTime.Now.ToString("yyyy-MM-dd h:mm:tt");

        string receive = CheckParameter("receive");
        string id = CheckParameter("id");

        //
        if(id == "")
        {
            response.status = "nonexistent";
            response.message="Please supply a check ID.";
            var json = new JavaScriptSerializer().Serialize(response);
            Response.Write(json);
            Response.End();
        }
        else if(File.Exists(fileUtils.rootFolder + Path.DirectorySeparatorChar + "Checks" + Path.DirectorySeparatorChar + "CloudCoins." + id+ ".stack"))
        {
            response.status = "nonexistent";
            response.message="The check you requested was not found on the server. It may have been cashed, canceled or you have provided an id that is incorrect. Did you type the right number?";
            var json = new JavaScriptSerializer().Serialize(response);
            Response.Write(json);
            Response.End();
        }


        string check_path = fileUtils.rootFolder + Path.DirectorySeparatorChar + "Checks" + Path.DirectorySeparatorChar +  "CloudCoins." + id + ".stack";



        switch (receive)
        {
            case "json":
                
                string json = "";
            using (StreamReader sr = File.OpenText(check_path))
            {

                while (!sr.EndOfStream)
                {
                    json += sr.ReadLine();
                }
            }
            Response.Write(json);
            Response.End();
                break;
            case "sms":
                response.status = "not yet implemented";
            response.message="receiving checks by sms not yet implemented";
            var sjson = new JavaScriptSerializer().Serialize(response);
            Response.Write(sjson);
            Response.End();
                break;
            case "email":
                string emailto = CheckParameter("email");
                string from = CheckParameter("from");
                SmtpClient cli = new SmtpClient();
            MailAddress MAfrom = new MailAddress(from);
            MailAddress to = new MailAddress(emailto);
            MailMessage message = new MailMessage(MAfrom, to);
            
            message.Subject = "CloudCoins Stack sent from Check";
                ContentType type = new ContentType();
                type.MediaType = MediaTypeNames.Text.Plain;
                type.Name = "CloudCoins." + id + ".stack";
                message.Attachments.Add(new Attachment(check_path, type));

            cli.SendAsync(message, "CloudBank Check");

                response.status = "success";
            response.message="CloudCoin stack file sent via email and has been deleted from this server.";
            var ejson = new JavaScriptSerializer().Serialize(response);
            Response.Write(ejson);
            Response.End();
                break;
            default:
            case "download":
                Response.Clear();
                Response.AppendHeader("Content-Disposition", "attachment; filename=CloudCoins." + id+".stack" );
                Response.TransmitFile(check_path);
                Response.End();
                break;
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