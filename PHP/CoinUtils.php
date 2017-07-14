<?php include("CloudCoin.php") ?>
<?php
class CoinUtils
{
    var $cc;
    var $pans = array();
    var $edHex;
    var $hp;
    var $fileName;
    var $json;
    var $jpeg;
    var $YEARSTILEXPIRE = 2;
    var $Folder =array("Suspect"=>0, "Counterfeit"=>1, "Fracked"=>2, "Bank"=>3, "Trash"=>4);
    var $folder;
    var $gradeStatus = array();

    function __construct($cc)
    {
        $this->cc = $cc;
        for($x = 0; $x < 25; $x++)
        {
            $this->pans[$x] = $this->generate_pan();
        }
        $this->edHex = "FF";
        $this->hp =25;
        $this->fileName = $this->getDenomination() . ".CloudCoin." . $cc->get_nn() . "." . $cc->get_sn() . ".";
        $this->json = "";
        $this->jpeg = null;
    }

    function get_fileName()
    {
        return $this->fileName;
    }
    function set_fileName($new)
    {
        $this->fileName = $new;
    }

    function getPastStatus($raida_id)
    {
        $returnString = "";
        $pownArray = str_split($this->cc->get_pown()); //php tochararray
        switch($pownArray[$raida_id])
        {
            case 'e': $returnString = "error"; break;
            case 'f': $returnString = "fail"; break;
            case 'p': $returnString = "pass"; break;
            case 'u': $returnString = "undetected"; break;
            case 'n': $returnString = "noresponse"; break;
        }
        return $returnString;
    }

    function setPastStatus($status, $raida_id)
    {
        $pownArray = str_split($this->cc->get_pown());
        switch($status)
        {
            case "error": $pownArray[$raida_id] = 'e';  break;
            case "fail": $pownArray[$raida_id] = 'f';  break;
            case "pass": $pownArray[$raida_id] = 'p'; break;
            case "undetected": $pownArray[$raida_id] = 'u';  break;
            case "noresponse": $pownArray[$raida_id] = 'n';  break;
        }
        $this->cc->set_pown(implode($pownArray));
        return true;
    }

    function getFolder()
    {
        $returnString = "";
        switch ($this->folder)
            {
                case $this->Folder["Bank"]: $returnString = "Bank"; break;
                case $this->Folder["Counterfeit"]: $returnString = "Counterfeit"; break;
                case $this->Folder["Fracked"]: $returnString = "Fracked"; break;
                case $this->Folder["Suspect"]: $returnString = "Suspect"; break;
                case $this->Folder["Trash"]: $returnString = "Trash"; break;
            }//end switch
            return $returnString;
    }

    function setFolder($folderName)
    {
        $setGood = false;
        switch (strtolower($folderName))
            {
                case "bank": $this->folder = $this->Folder["Bank"]; break;
                case "counterfeit": $this->folder = $this->Folder["Counterfeit"]; break;
                case "fracked": $this->folder = $this->Folder["Fracked"]; break;
                case "suspect": $this->folder = $this->Folder["Suspect"]; break;
                case "trash": $this->folder = $this->Folder["Trash"]; break;
            }//end switch
            return $setGood;
    }

    function getDenomination()
    {
        $nom = 0;
        if (($this->cc->get_sn() < 1))
            {
                $nom = 0;
            }
            else if (($this->cc->sn < 2097153))
            {
                $nom = 1;
            }
            else if (($this->cc->sn < 4194305))
            {
                $nom = 5;
            }
            else if (($this->cc->sn < 6291457))
            {
                $nom = 25;
            }
            else if (($this->cc->sn < 14680065))
            {
                $nom = 100;
            }
            else if (($this->cc->sn < 16777217))
            {
               $nom = 250;
            }
            else
            {
                $nom = '0';
            }

            return $nom;
    }

    function calculateHP()
    {
        $this->hp = 25
        $pownArray = str_split($cc->get_pown());
        for($x=0;$x<25;$x++)
        {
            if($pownArray[$x] == 'f')
            {
                $this->hp--;
            }
        }
    }

    function calcExpirationDate()
    {
        $expirationDate = date_add(date_create(),date_interval_create_from_date_string("2 years"));
        $this->cc->set_ed(date_format($expirationDate, "m-Y"));
        $zeroDate = date_create("2016-10-01");
        $monthsAfterZero = date_diff($zeroDate, $expirationDate);
        $this->ehHex = dechex($monthsAfterZero->format("%m"));
    }

    function grade()
    {
        $passed = 0;
        $failed = 0;
        $other = 0;
        $passedDesc = "";
        $failedDesc = "";
        $otherDesc = "";
        $pownArray = str_split($this->cc->get_pown());
        for($x=0;$x<25;$x++)
        {
            if($pownArray[$x] == 'p')
            {
                $passed++;
            }
            else if ($pownArray[$x] == 'f')
            {
                $failed++;
            }
            else
            {
                $other++;
            }
        }
        if ($passed == 25)
            {
                $passedDesc = "100% Passed!";
            }
            else if ($passed > 17)
            {
                $passedDesc = "Super Majority";
            }
            else if ($passed > 13)
            {
                $passedDesc = "Majority";
            }
            else if ($passed == 0)
            {
                $passedDesc = "None";
            }
            else if ($passed < 5)
            {
                $passedDesc = "Super Minority";
            }
            else
            {
                $passedDesc = "Minority";
            }

            // Calculate failed
            if ($failed == 25)
            {
                $failedDesc = "100% Failed!";
            }
            else if ($failed > 17)
            {
                $failedDesc = "Super Majority";
            }
            else if ($failed > 13)
            {
                $failedDesc = "Majority";
            }
            else if ($failed == 0)
            {
                $failedDesc = "None";
            }
            else if ($failed < 5)
            {
                $failedDesc = "Super Minority";
            }
            else
            {
                $failedDesc = "Minority";
            }

            // Calcualte Other RAIDA Servers did not help. 
            switch ($other)
            {
                case 0:
                    $otherDesc = "100% of RAIDA responded";
                    break;
                case 1:
                case 2:
                    $otherDesc = "Two or less RAIDA errors";
                    break;
                case 3:
                case 4:
                    $otherDesc = "Four or less RAIDA errors";
                    break;
                case 5:
                case 6:
                    $otherDesc = "Six or less RAIDA errors";
                    break;
                case 7:
                case 8:
                case 9:
                case 10:
                case 11:
                case 12:
                    $otherDesc = "Between 7 and 12 RAIDA errors";
                    break;
                case 13:
                case 14:
                case 15:
                case 16:
                case 17:
                case 18:
                case 19:
                case 20:
                case 21:
                case 22:
                case 23:
                case 24:
                case 25:
                    $otherDesc = "RAIDA total failure";
                    break;
                default:
                    $otherDesc = "FAILED TO EVALUATE RAIDA HEALTH";
                    break;
            }
            // end RAIDA other errors and unknowns
            // Coin will go to bank, counterfeit or fracked
            if ($other > 12)
            {
                // not enough RAIDA to have a quorum
                $this->folder = $this->Folder["Suspect"];
            }
            else if ($failed > $passed)
            {
                // failed out numbers passed with a quorum: Counterfeit
                $this->folder = $this->Folder["Counterfeit"];
            }
            else if ($failed > 0)
            {
                // The quorum majority said the coin passed but some disagreed: fracked. 
                $this->folder = $this->Folder["Fracked"];
            }
            else
            {
                // No fails, all passes: bank
                $folder = $this->Folder["Bank"];
            }

            $this->gradeStatus[0] = $passedDesc;
            $this->gradeStatus[1] = $failedDesc;
            $this->gradeStatus[2] = $otherDesc;
            return $this->gradeStatus;
    }

    function setAnsToPans()
    {
        for($x=0;$x<25;$x++)
        {
            $this->pans[$x] = $this->cc->get_an($x);
        }
    }

    function setAnsToPansIfPassed()
    {
        $pownArray = str_split($this->cc->get_pown());
        for ($i = 0; ($i < 25); $i++)
            {
                if ($pownArray[$i] == 'p')//1 means pass
                {
                    $this->cc->set_an($i, $this->pans[$i]);
                }
                
                else
                {
                    // Just keep the ans and do not change. Hopefully they are not fracked. 
                }
            }
    }

    function generatePan()
    {
        $pan = com_create_guid();
        $pan = str_replace("-", "", $pan);
        return $pan;
    }


}


?>