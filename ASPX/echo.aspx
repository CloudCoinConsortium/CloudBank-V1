<%@ Page Language="C#" Debug="false"  %>
<%@ Import namespace="System.Web.Configuration" %>
<%@ Import namespace="System" %>
<%@ Import namespace="System.Data.SqlClient" %>
<%@ Import namespace="System.Web.Configuration" %>

<script language="c#" runat="server">
    /*
      detect.aspx
      Version 1/28/2017
      Created by Sean H. Worthington
      Updates ANs table. Sets AN = to PAN WHERE the AN in the database = AN sent by user and where denomination is correct. 
      Usage: https://cloudcoin.global/service/detect.php?nn=1&sn=6&an=B78663C4E328CD643151AE238566B121&pan=B78663C4E328CD643151AE238566B121&denomination=1
      This software is for use by CloudCoin Consortium RAIDA Administrators only. 
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




    public void Page_Load(object sender, EventArgs e)
    {
        //Usage: http://192.168.1.4/service/detect.aspx?sn=1&an=1836843d928347fb22c2142b49d772b5&pan=1836843d928347fb22c2142b49d772b5&denomination=1
        string sname = WebConfigurationManager.AppSettings["thisServerName"];
        string date = DateTime.Now.ToString("yyyy-mm-dd h:mm:tt");
        //Response.Write("here");
        //GET INPUT VARIABLES
        int sn = Convert.ToInt32(Request.QueryString["sn"]) ;
        string an = Request.QueryString["an"];
        string pan = Request.QueryString["pan"];
        int denomination = Convert.ToInt32(Request.QueryString["denomination"]);
        int[] denominations = { 1,5,25,100,250 };

        //VALIDATE INPUT VARIABLES
        if ( sn > 0 && sn < 16777217  ) { /*Live*/  } else {
            if (!string.IsNullOrWhiteSpace(Request.QueryString["b"]))
            {
                Response.Write("fail");
                Response.End();
            }
            else
            {
                Response.Write(@"{""server"":""" + sname + @""",""status"":""fail"",""message"":""SN: The unit's serial number was out of range."",""time"":""" + date + @"""}");
                Response.End();
            }
        }//end if not in range

        if ( an.Length != 32 && IsHex(an)){
            if (!string.IsNullOrWhiteSpace(Request.QueryString["b"]))
            {
                Response.Write("fail");
                Response.End();
            }
            else
            {
                Response.Write(@"{""server"":""" + sname + @""",""status"":""fail"",""message"":""AN: The unit's Authenticity Number was out of range."",""time"":""" + date + @"""}");
                Response.End();
            }
        }//end if not 32 and hexidecimal
        if ( pan.Length != 32 && IsHex(an)){
            if (!string.IsNullOrWhiteSpace(Request.QueryString["b"]))
            {
                Response.Write("fail");
                Response.End();
            }
            else
            {
                Response.Write(@"{""server"":""" + sname + @""",""status"":""fail"",""message"":""PAN: The unit's Proposed Authenticity Number was out of range."",""time"":""" + date + @"""}");
                Response.End();
            }
        }//end if not 32 and hexidecimal
        if ( !denominations.Contains(denomination) ) {
            if (!string.IsNullOrWhiteSpace(Request.QueryString["b"]))
            {
                Response.Write("fail");
                Response.End();
            }
            else
            {
                Response.Write(@"{""server"":""" + sname + @""",""status"":""fail"",""message"":""Denomination: The unit's Denomination was out of range."",""time"":""" + date + @"""}");
                Response.End();
            }
        }//end if not in acceptable denominations

        //CREATE A MONEY UNIT OBJECT
        MoneyUnit cake = new MoneyUnit( sn, an, pan, denomination);

        // CHECK IF DENOMINATION IS CORRECT 
        if (cake.reportedDenomination != cake.realDenomination) {
            if (!string.IsNullOrWhiteSpace(Request.QueryString["b"]))
            {
                Response.Write("fail");
                Response.End();
            }
            else
            {
                Response.Write(@"{""server"":""" + sname + @""",""status"":""fail"",""message"":""Denomination: The item you are authenticating is a " +
                cake.realDenomination + @" units. However, the request was for a " + denomination +
                @" units. Someone may be trying to pass you a money unit that is not of the true value "",""time"":""" + date + @"""}");
                Response.End();
            }
        }

        if( !cake.detect() ){
            if (!string.IsNullOrWhiteSpace(Request.QueryString["b"]))
            {
                Response.Write("fail");
                Response.End();
            }
            else
            {
                Response.Write(@"{""server"":""" + sname + @""",""sn"":""" + sn + @""",""status"":""fail"",""message"":""Counterfeit: The unit failed to authenticate on this server. You may need to fix it on other servers."",""time"":""" + date + @"""}");
                Response.End();
            }
        } else{
            if (!string.IsNullOrWhiteSpace(Request.QueryString["b"]))
            {
                Response.Write("pass");
                Response.End();
            }
            else
            {
                Response.Write(@"{""server"":""" + sname + @""",""sn"":""" + sn + @""",""status"":""pass"",""message"":""Authentic: The unit is an authentic " + cake.realDenomination + @"-unit. Your Proposed Authenticity Number is now the new Authenticty Number. Update your file."",""time"":""" + date + @"""}");
                Response.End();
            }
        }
    }//End Page Load

    private bool IsHex(IEnumerable<char> chars){
        bool isHex;
        foreach(var c in chars)
        {
            isHex = ((c >= '0' && c <= '9') ||
                     (c >= 'a' && c <= 'f') ||
                     (c >= 'A' && c <= 'F'));

            if(!isHex)
                return false;
        }
        return true;
    }
</script>
