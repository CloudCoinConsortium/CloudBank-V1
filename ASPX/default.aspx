<%@ Page Language="C#" Debug="false"  %>
<%@ Import namespace="System.Web.Configuration" %>
<%@ Import namespace="System" %>
<%@ Import namespace="System.Data.SqlClient" %>
<%@ Import namespace="System.Web.Configuration" %>
<%@ Import namespace="System.Web.Script.Serialization" %>

<script language="c#" runat="server">
    /*
      print_welcome.aspx
      Version 9/27/2017
      Created by Navraj Singh
      Get's the bank's welcome information
      Usage: https://cloudcoin.global/bank/print_welcome.aspx
      This software is for use by CloudCoin Consortium Clients only. 
      All rights reserved.  
      */

    public class MoneyUnit
    {
        //fields
        protected string detectString = ConfigurationManager.ConnectionStrings["Detect"].ConnectionString;

        public int sn;
        public string an;
        public string pan;
        public int reportedDenomination;
        public int realDenomination;

        //Constructors
        public MoneyUnit(int sn, string an, string pan, int reportedDenomination)
        {
            this.sn = sn;
            this.an = an;
            this.pan = pan;
            this.reportedDenomination = reportedDenomination;
            if (sn < 1)
            {
                this.realDenomination = 0;
            }
            else if (sn > 0 && sn < 2097153)
            {
                this.realDenomination = 1;
            }
            else if (sn < 4194305)
            {
                this.realDenomination = 5;
            }
            else if (sn < 6291457)
            {
                this.realDenomination = 25;
            }
            else if (sn < 14680065)
            {
                this.realDenomination = 100;
            }
            else if (sn < 16777217)
            {
                this.realDenomination = 250;
            }
            else
            {
                this.realDenomination = 0;
            };
        }//end construct

        //Methods
        public bool detect()
        { //True if pass, false if authentication fails
            SqlConnection connection = new SqlConnection(detectString);
            SqlCommand cmd = new SqlCommand("usp_detect", connection);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.Add(new SqlParameter("@sn", sn));
            cmd.Parameters.Add(new SqlParameter("@an", an));
            cmd.Parameters.Add(new SqlParameter("@pan", pan));

            connection.Open();
            SqlDataReader rdr = cmd.ExecuteReader();

            String results = "fail";
            while (rdr.Read())
            {
                results = rdr["response"].ToString();
            }//end While
            connection.Close();
            if (results == "pass") { return true; }

            return false;
        }//end detect 


    }


    public class ServiceResponse
    {
        public string server;
        public string status;
        public string version;
        public string message;
        public string time;

    }

    public void Page_Load(object sender, EventArgs e)
    {
        //Usage: http://192.168.1.4/service/detect.aspx?sn=1&an=1836843d928347fb22c2142b49d772b5&pan=1836843d928347fb22c2142b49d772b5&denomination=1
        string servername = WebConfigurationManager.AppSettings["thisServerName"];
        string date = DateTime.Now.ToString("yyyy-mm-dd h:mm:tt");
        string message = "CloudCoin Bank. Used to Authenticate, Store and Payout CloudCoins." +
                "This Software is provided as is with all faults, defects and errors, and without warranty of any kind." +
                "Free from the CloudCoin Consortium.";
        //Response.Write("here");
        ServiceResponse response = new ServiceResponse();
        response.server = WebConfigurationManager.AppSettings["thisServerName"];
        response.time = DateTime.Now.ToString("yyyy-mm-dd h:mm:tt");
        response.message = message;

        //VALIDATE INPUT VARIABLES
        var json = new JavaScriptSerializer().Serialize(response);
        Response.Write(json);
        Response.End();





    }//End Page Load

</script>
