
//This is a rough draft

    class CloudCoinSender
    {
        

        // Fields /
        // Constructors /
        constructor( cloudBankURL)
        {
        this.rawStack = "";
        this.rawReceipt = "";
        this.cloudBankURL = cloudBankURL;
        }//end constructor

        // METHODS /
        loadStackFromFile( filename )
        {
            rawStack = fs.readFileSync(filename);
        }

        sendStackToCloudBank( )
        {
			
          let CloudBankFeedback = "";
		   var xhttp = new XMLHttpRequest();
           xhttp.onreadystatechange = function() {
          if (this.readyState == 4 && this.status == 200) {
                rawReceipt = this.responseText;
            }
		  };
		  xhttp.open("POST", "cloudBankURL", true);
		  xhttp.send(encodeURI('stack=' + rawStack));
		 
        }

        interpretReceipt(){
            string interpretation = "";
            if (rawReceipt.Contains("Error"))
            {
                //parse out message
                interpretation = rawReceipt;
            }else{
                //tell the client how many coins were uploaded how many counterfeit, etc.
                var deserialReceipt = JsonConvert.DeserializeObject<Receipt>(rawReceipt);
                int totalNotes = deserialReceipt.total_authentic + deserialReceipt.total_fracked;
                int totalCoins = 0;
                for (int i = 0; i < deserialReceipt.rd.Length; i++)
                    if (deserialReceipt.rd[i].status == "authentic")
                        totalCoins += getDenomination(deserialReceipt.rd[i].sn);
                interpretation ="receipt number: " + deserialReceipt.receipt_id + " total authentic notes: " + totalNotes + " total authentic coins: " + totalCoins;


         }//end if error
            return interpretation;
        }

        getDenomination( sn)
        {
            int nom = 0;
            if ((sn < 1))
            {
                nom = 0;
            }
            else if ((sn < 2097153))
            {
                nom = 1;
            }
            else if ((sn < 4194305))
            {
                nom = 5;
            }
            else if ((sn < 6291457))
            {
                nom = 25;
            }
            else if ((sn < 14680065))
            {
                nom = 100;
            }
            else if ((sn < 16777217))
            {
                nom = 250;
            }
            else
            {
                nom = '0';
            }

            return nom;
        }//end get denomination

    }//end Class CloudCoinSender
        
