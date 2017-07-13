<?php include("RAIDA.php") ?>
<?php include("FileUtils.php") ?>
<?php include("FixerHelper.php") ?>
<?php
class Frack_Fixer()
{
    private $fileUtils
    private $totalValueToBank;
    private $totalValueToFractured;
    private $totalValueToCounterfeit;
    private $raida;

    function __construct($fileUtils, $timeout)
    {
        $this->fileUtils = $fileUtils;
        $this->raida = new RAIDA($timeout);
        $this->totalValueToBank = 0;
        $this->totalValueToCounterfeit = 0;
        $this->totalValeuToFractured = 0;
    }

    function fixOneGuidCorner($raida_ID, $cc, $corner, $trustedTriad)
    {
        $cu = new CoinUtils($cc);
        $status = $this->raida->raida_status;

        if($status->get_failsFix($raida_ID) || $status->get_failsEcho($raida_ID))
        {
            echo "RAIDA Fails Echo of Fix. Try again when RAIDA online."
            return "RAIDA Fails Echo of Fix. Try again when RAIDA online.";
        }
        else
        {
            if($status->get_failsEcho($trustedTriad[0]) === false || $status->get_failsDetect($trustedTriad[0]) === false || $status->get_failsEcho($trustedTriad[1])=== false || $status->get_failsDetect($trustedTriad[1]) === false || $status->get_failsEcho($trustedTriad[2]) === false || $status->get_failsDetect($trustedTriad[2]) === false)
            {
                $ans = array($cc->get_an($trustedTriad[0]), $cc->get_an($trustedTriad[1]), $cc->get_an($trustedTriad[2]));
                $this->raida->get_Tickets($trustedTriad, $ans, $cc->get_nn(), $cc->get_sn(), $cu->getDenomination(), 3000);

                if($status->get_hasTicket($trustedTriad[0]) === true && $status->get_hasTicket($trustedTriad[1]) === true && $status->get_hasTicket($trustedTriad[2]) === true)
                {
                    $fixResponse = $this->raida->agent[$raida_ID]->fix($trustedTriad, $status->get_tickets($trustedTriad[0]), $status->get_tickets($trustedTriad[1]), $status->get_tickets($trustedTriad[2]), $cc->get_sn());
                    if($fixResponse->get_success === true)
                    {
                        echo "RAIDA".$raida_ID." unfracked successfully.";
                        return "RAIDA".$raida_ID." unfracked successfully.";
                    } else
                    {
                        echo "RAIDA failed to accept tickets on corner ".$corner;
                        return "RAIDA failed to accept tickets on corner ".$corner;
                    }
                } else {
                    echo "RAIDA failed to accept tickets on corner ".$corner;
                    return "RAIDA failed to accept tickets on corner ".$corner;
                } //end if all good
            }// end if trusted triad will echo and detect
            echo "One or more of the trusted triad will not echo and detect.So not trying";
            return "One or more of the trusted triad will not echo and detect. So not trying";
        }
    }


    function fixAll()
    {
        $results = array();
        $frackedFileNames = scandir($this->fileUtils->frackedFolder);
        if(count($frackedFileNames) < 0)
        echo "You have no fracked coins."

        for($x = 0; $x < count($frackedFileNames); $x++)
        {
            echo "UnFracking coin ".x+1." of ". count($frackedFileNames);
            try
            {
                $frackedCC = $this->fileUtils->loadOneCloudCoinFromJsonFile($this->fileUtils->frackedFolder.$frackedFileNames[$x]);
                $cu = new CoinUtils($frackedCC);
                $value = $frackedCC->get_pown();

                #consoleReport

                $fixedCC = $this->fixCoin($frackedCC);

                #consoleReport
                switch(strtolower($fixedCC->getFolder()))
                {
                   case "bank":
                            $this->totalValueToBank++;
                            $this->fileUtils->overWrite($this->fileUtils->bankFolder, $fixedCC->cc);
                            $this->deleteCoin($this->fileUtils->frackedFolder . $frackedFileNames[$x]);
                            echo "CloudCoin was moved to Bank.";
                            break;
                        case "counterfeit":
                            $this->totalValueToCounterfeit++;
                            $this->fileUtils->overWrite($this->fileUtils->counterfeitFolder, $fixedCC->cc);
                            $this->deleteCoin($this->fileUtils->frackedFolder . $frackedFileNames[$x]);
                            echo "CloudCoin was moved to Trash.";
                            break;
                        default://Move back to fracked folder
                            $this->totalValueToFractured++;
                            $this->deleteCoin($this->fileUtils->frackedFolder . $frackedFileNames[$x]);
                            $this->fileUtils->overWrite($this->fileUtils->frackedFolder, $fixedCC->cc);
                            echo "CloudCoin was moved back to Fraked folder.";
                            break;
                }
            }
            catch(Exception $ex)
            {
                echo $ex;
            }
        }
        $results[0] = $this->totalValueToBank;
        $results[1] = $this->totalValueToCounterfeit;
        $results[2] = $this->totalValueToFracktured;
        return $results;
    }//end fix all

    function deleteCoin($path)
    {
        $deleted = false;
        try
        {
            delete($path);
        }
        catch (Exception $e)
        {
            echo $e;
        }
        return $deleted;
    }

    function fixCoin($brokeCoin)
    {
        $cu = new CoinUtils($brokeCoin);
        $this->raida->raida_status->resetTickets();
        $this->raida->raida_status->newCoin();

        $cu->setAnsToPans();
        $before = time();

        $fix_result = "";
        
        $corner = 1;

        for($raida_ID = 0; $raida_ID < 25; $raida_ID++)
        {
            if(strtolower($cu->getPastStatus($raida_ID)) == "fail")
            {
                echo "Attempting to fix RAIDA " . $raida_ID;
                $fixer = new FixitHelper($raida_ID, $brokeCoin->get_an());
                corner = 1;
                while($fixer->finnished === false)
                {
                    echo " Using corner ".corner;
                    $fix_result = $this->fixOneGuidCorner($raida_ID, $brokeCoin, $corner, $fixer->currentTriad);
                    if(strpos($fix_result, "success") !== false)
                    {
                        $cu->setPastStatus("pass", $raida_ID);
                        $fixer->finnished = true;
                        $corner = 1;
                    }
                    else
                    {
                        $corner++;
                        $fixer->setCornerToCheck($corner);
                    }
                }
            }
        }
        $after = time();
        $ts = $after - $before;
        echo "Time spent fixing RAIDA in milliseconds: " . $ts;

        $cu->calculateHP();
        $cu->grade();
        $cu->calcExpirationDate();
        return $cu;
    }
}

?>