<%@ Page Language="C#" Debug="true"  Async="true"%>
<%@ Import namespace="System.Web.Configuration" %>
<%@ Import namespace="System" %>
<%@ Import Namespace="System.IO" %>
<%@ Import namespace="System.Data.SqlClient" %>
<%@ Import namespace="System.Web.Configuration" %>
<%@ Import namespace="Founders" %>
<%@ Import namespace="System.Web.Script.Serialization" %>

<script language="c#" runat="server">
    public void Page_Load(object sender, EventArgs e)
    {
        string id = Request["rn"];
        string path = AppDomain.CurrentDomain.BaseDirectory + Path.DirectorySeparatorChar + "Reciepts"+ Path.DirectorySeparatorChar + id + ".json";
        if(id == null)
        {
            Response.Write("Error: No Receipt Id in Request.");
            Response.End();
        }else if(!File.Exists(path))
        {
            Response.Write("Error: File not Found " + id + ".json");
            Response.End();
        }
        else
        {
            string json = "";
            using (StreamReader sr = File.OpenText(path))
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
