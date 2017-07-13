<?php include("DetectionAgent.php") ?>
<?php include("RAIDA_Status.php") ?>
<?php
class RAIDA
{
    var $agent = array();
    var $returnCoin;
    var $responseArray = array();
    private $working_triad = array(0,1,2);
    var $raidaIsDetecting = array(true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true);
    var $lastDetectStatus = array("notdetected", "notdetected", "notdetected", "notdetected", "notdetected", "notdetected", "notdetected", "notdetected", "notdetected", "notdetected", "notdetected", "notdetected", "notdetected", "notdetected", "notdetected", "notdetected", "notdetected", "notdetected", "notdetected", "notdetected", "notdetected", "notdetected", "notdetected", "notdetected", "notdetected");
    var $echoStatus = array("noreply", "noreply", "noreply", "noreply", "noreply", "noreply", "noreply", "noreply", "noreply", "noreply", "noreply", "noreply", "noreply", "noreply", "noreply", "noreply", "noreply", "noreply", "noreply", "noreply", "noreply", "noreply", "noreply", "noreply", "noreply");
    var $raida_status = new RAIDA_Status();

    function __construct($milliSecondsToTimeOut)
    {
        for($x=0;$x<25;$x++)
        {
            $this->agent[$x] = new DetectionAgent($x, $milliSecondsToTimeOut);
            $this->responseArray[$x] = new Response();
        }
    }

    function echoOne($raida_id)
    {
        $this->responseArray[$raida_id] = $this->agent[$raida_id]->echo();
    }

    function echoAll($milliSecondsToTimeOut)
    {
        for($x=0;$x<25;$x++)
        {
            $this->echoOne($x);
        }
    }

    function detectOne($raida_id, $nn, $sn, $an, $pan, $d)
    {
        $this->responseArray[$raida_id] = $this->agent[$raida_id]->detect($nn, $sn, $an, $pan, $d);

    }

    function detectCoin($cu, $milliSecondsToTimeOut)
    {
        $cu->generatePan();
        for($x=0;$x<25;$x++)
        {
            $this->detectOne($x, $cu->cc->get_nn(), $cu->cc->get_sn(),$cu->cc->get_an($x),$cu->pans[$x],$cu->getDenomination());
            if($this->responseArray[$x] !== null)
            {
                $cu->setPastStatus($this->responseArray[$x]->get_outcome(), $x);
            } else {
                $cu->setPastStatus("undetected", $x);
            }
        }
        $cu->setAnsToPansIfPassed();
        $cu->calculateHP();
        $cu->calcExpirationDate();
        $cu->grade();

        return $cu;
    }

    function get_Ticket($i, $raida_id, $nn, $sn, $an, $d)
    {
        $this->responseArray[$raida_id] = $this->agent[$raida_id]->get_ticket($nn, $sn, $an, $d);
        $this->raida_status->set_hasTicket($raida_id, true);
        $this->raida_status->set_tickets($raida_id, $this->responseArray[$raida_id]->get_outcome());
    }

    function get_Tickets($triad, $ans, $nn, $sn, $d, $milliSecondsToTimeOut)
    {
        $this->get_Ticket(0, $triad[0], $nn, $sn, $ans[0], $d);
        $this->get_Ticket(1, $triad[1], $nn, $sn, $ans[1], $d);
        $this->get_Ticket(2, $triad[2], $nn, $sn, $ans[2], $d);
    }
}

?>