<%@ Page Language="C#" Debug="true"  Async="true"%>
<%@ Import namespace="System.Web.Configuration" %>
<%@ Import namespace="System" %>
<%@ Import namespace="System.Data.SqlClient" %>
<%@ Import namespace="System.Web.Configuration" %>
<%@ Import namespace="Founders" %>
<%@ Import namespace="System.Web.Script.Serialization" %>
<%@ Import Namespace="System.Security.Cryptography" %>
<%@ Import Namespace="System.Threading.Tasks" %>


<script language="c#" runat="server">
  class ServiceResponse
    {
        public string server;
        public string status;
        public string message;
        public string time;
    }//End Service Response class

    static FileUtils fileUtils = FileUtils.GetInstance(AppDomain.CurrentDomain.BaseDirectory);



    public void Page_Load(object sender, EventArgs e)
    {

    Response.Write( "{  	\"server\": \"ccc.cloudcoin.global\", \"status\": \"added\", 	\"message\":\"Account was created for user e24b3a755916472f8768e4e9992827a0. Username and Password sent to email provided.\",  \"time\": \"2016-40-21 10:40:PM\"  }" );
  //  Response.Write("Fuck ""you"" too");

    }//end of dummmy respons. 
	
        /* SHOW POST VARAIBLES */
	    //string[] keys = Request.Form.AllKeys;
        //for (int i= 0; i < keys.Length; i++) 
        //{
        //   Response.Write(keys[i] + ": " + Request.Form[keys[i]] + "<br>");
        //}



        /* GET POST VARIABLE 
        string command =  Request.Form["command"];
        string uid = Request.Form["uid"];
        string pw = Request.Form["pw"];
        string newpw = Request.Form["newpw"];
        string email = Request.Form["email"];
        string newemail = Request.Form["newemail"];


        /* VALIDATE POST VARIABLES 
        bool hasUid =  checkGUIDValidity( uid );
        bool hasPw =  checkGUIDValidity( pw );
        bool hasNewPw =  checkGUIDValidity( newpw );
        bool email =  checkGUIDValidity( email );
        bool newemail =  checkGUIDValidity( newemail );


        /* Figure out what to do 
        switch( command )
        {
            case "add": addAccount(); break;
            case "updateemail": updateEmail(); break;
            case "updatepassword": updatePassword(); break;
            case "recoveremail": recoverEmail(); break;
            case "recoverpassword": recoverPassword(); break;
            case "delete": deleteAccount(); break;
        }//end switch

        addAccount()
        {
            if( accountExists(uid) )
            {
                makeFolder(uid);

                returnGoodAdd();   
            }
            else
            {
                returnGoodAdd();//say the same thing if the file exists or not so hackers cannot guess
            }//end if account exists
        }//end add Account

        updateEmail()
        {
            if( accountExists(uid) )
            {
                changeFolder();
                returnGoodEmailChange();   
            }
            else
            {
                returnBad();//say the same thing if the file exists or not so hackers cannot guess
            }//end if account exists
        }//end updateEmail

        updatePassword(){
        if( accountExists(uid) )
            {
                changeFolder();
                returnGoodEmailChange();   
            }
            else
            {
                returnBad();//say the same thing if the file exists or not so hackers cannot guess
            }//end if account exists
        }//end updatePassword

        recoverEmail(){
        if( accountExists(uid) )
            {
                changeFolder();
                returnGoodEmailChange();   
            }
            else
            {
                returnBad();//say the same thing if the file exists or not so hackers cannot guess
            }//end if account exists
        }//end recoverEmail

        recoverPassword(){
        if( accountExists(uid) )
            {
                changeFolder();
                returnGoodEmailChange();   
            }
            else
            {
                returnBad();//say the same thing if the file exists or not so hackers cannot guess
            }//end if account exists
        }//end recoverPassword

        deleteAccount(){
        if( accountExists(uid) )
            {
                changeFolder();
                returnGoodEmailChange();   
            }
            else
            {
                returnBad();//say the same thing if the file exists or not so hackers cannot guess
            }//end if account exists
        }//end deleteAccount

		
    }//End Page Load

    bool checkGUIDValidity( stringGuid ){
      bool isValid = false
        try {
            Guid newGuid = Guid.ParseExact(stringGuid, "N");
            isValid = true;
         }   
         catch (ArgumentNullException) { 
            //not valid
         }   
         catch (FormatException) {
           //not valid
         } //End try catch 
    return isValid;
    }//end check validity


    bool IsValidEmail(string email)
    {
        try {
            var addr = new System.Net.Mail.MailAddress(email);
            return addr.Address == email;
        }
        catch {
            return false;
        }
    }//end check valid email

    string makeFolder(string name){
        string returnString = "error"
     // Specify the directory you want to manipulate.
        string path = @"h:\ccc\teller\acccounts\" + name;
        try 
        {
            // Determine whether the directory exists.
            if (Directory.Exists(path)) 
            {
                returnString = "exists";
                return returnString;
            }
            // Try to create the directory.
            DirectoryInfo di = Directory.CreateDirectory(path);
             returnString = "success";
        } 
        catch (Exception e) 
        {
             returnString = "error";
        } 
        finally {}
    }//End makeFolders
    */

</script>