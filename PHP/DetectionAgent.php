<?php include("Response.php"); ?>
<?php
class DetectionAgent
{
    var $readTimeout;
    var $RAIDANumber;
    var $fullUrl;

    function __construct($RAIDANumber, $readTimeout)
    {
        $this->RAIDANumber = $RAIDANumber;
        $this->fullUrl = "https://RAIDA" . $RAIDANumber . ".cloudcoin.global/service/";
        $this->readTimeout = $readTimeout;
    }

    function echo($raidaID)
    {
        $echoResponse = new Response();
        $echoResponse->set_fullRequest($this->fullUrl . "echo?b=t");
        $r = new HttpRequest($echoResponse->get_fullRequest(), HttpRequest::METH_GET);
        $before = time();
        try
        {
            $r->send();
            $echoResponse->set_fullResponse($r->getResponseBody());
            if(strpos($echoResponse->get_fullResponse(), "ready") !== false)
            {
                $echoResponse->set_success(true);
                $echoResponse->set_outcome("ready");
            }else{
                $echoResponse->set_success(false);
                $echoResponse->set_outcome("error");
            }

        }
        catch(HttpException $ex){
            $echoResponse->set_success(false);
            $echoResponse->set_outcome("error");
            $echoResponse->set_fullResponse($ex);
        }
        $after = time();
        $ts = $after - $before;
        $echoResponse->set_milliseconds($ts);
        return $echoResponse;
    }

    function detect($nn, $sn, $an, $pan, $d)
    {
        $detectResponse = new Response();
        $detectResponse->set_fullRequest($this->fullUrl."detect?nn=".$nn."&sn=".$sn."&an=".$an."&pan=".$pan."&denomination=".$d);
        $r = new HttpRequest($detectResponse->get_fullRequest(), HttpRequest::METH_GET);
        $before = time();
        try
        {
            $r->send();
            $detectResponse->set_fullResponse($r->getResponseBody());
            $after = time();
        $ts = $after - $before;
        $detectResponse->set_milliseconds($ts);
            if(strpos($detectResponse->get_fullResponse(), "pass") !== false)
            {
                $detectResponse->set_success(true);
                $detectResponse->set_outcome("pass");
            }else if(strpos($detectResponse->get_fullResponse(), "fail") !== false){

            }else{
                $detectResponse->set_success(false);
                $detectResponse->set_outcome("fail");
            }

        }
        catch(HttpException $ex){
            $detectResponse->set_success(false);
            $detectResponse->set_outcome("error");
            $detectResponse->set_fullResponse($ex);
        }
        
        return $detectResponse;

    }

    function get_ticket($nn, $sn, $an, $d)
    {
        $get_ticketResponse = new Response();
        $get_ticketResponse->set_fullRequest($this->fullUrl."get_ticket?nn=".$nn."&sn=".$sn."&an=".$an."&pan=".$an."&denomination".$d);
        $r = new HttpRequest($get_ticketResponse->get_fullRequest(), HttpRequest::METH_GET);
        $before = time();
        try
        {
            $r->send();
            $get_ticketResponse->set_fullResponse($r->getResponseBody());
            $after = time();
        $ts = $after - $before;
        $get_ticketResponse->set_milliseconds($ts);
            if(strpos($get_ticketResponse->get_fullResponse(), "ticket") !== false)
            {
                $get_ticketResponse->set_success(true);
                $responseArray = json_decode($get_ticketResponse->get_fullResponse(), true);

                $get_ticketResponse->set_outcome($responseArray["message"]);
            }else{
                $get_ticketResponse->set_success(false);
                
            }

        }
        catch(HttpException $ex){
            $get_ticketResponse->set_success(false);
            $get_ticketResponse->set_outcome("error");
            $get_ticketResponse->set_fullResponse($ex);
        }
        
        return $get_ticketResponse;
    }

    function fix($triad, $m1, $m2, $m3, $pan)
    {
        $fixResponse = new Response();
        $before = time();
        $fixResponse->set_fullRequest($this->fullUrl."fix?fromserver1=".$triad[0]."&message1=".$m1.
        "&fromserver2=".$triad[1]."&message2=".$m2."&fromserver3=".$triad[2]."&message3=".$m3."&pan=".$pan);
        $r = new HttpRequest($fixResponse->get_fullRequest(), HttpRequest::METH_GET);
        try
        {
            $r->send();
            $fixResponse->set_fullResponse($r->getResponseBody());
            $after = time();
        $ts = $after - $before;
        $fixResponse->set_milliseconds($ts);
            if(strpos($fixResponse->get_fullResponse(), "success") !== false)
            {
                $fixResponse->set_success(true);
                $fixResponse->set_outcome("success");
            }else{
                $fixResponse->set_success(false);
                $fixResponse->set_outcome("fail");
            }
        }
        catch(HttpException $ex)
        {
            $fixResponse->set_outcome("error");
            $fixResponse->set_fullResponse($ex);
            $fixResponse->set_success(false);
        }
        return $fixResponse;
    }
}



?>