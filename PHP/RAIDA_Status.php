<?php
class RAIDA_Status
{
    var $failsEcho;
    var $echoTime;
    var $failsDetect;
    var $failsFix;
    var $hasTicket;
    var $tickets;

    function __construct()
    {
        $this->failsEcho = array(false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false);
        $this->echoTime = array( 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 );
        $this->failsDetect = array(false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false);
        $this->failsFix = array(false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false);
        $this->hasTicket = array(false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false);
        $this->tickets = array("", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "");

    }

    function resetTickets()
    {
        for($x=0;$x<25;$x++)
        {
            $this->tickets[$x] = "";
            $this->hasTicket[$x] = false;
        }
    }

    function newCoin()
    {
        for($x=0;$x<25;$x++)
        {
            $this->tickets[$x] = "";
            $this->hasTicket[$x] = false;
            $this->failsDetect[$x] = false;
        }
    }

    function resetEcho()
    {
        for($x=0;$x<25;$x++)
        {
            $this->failsEcho[$x] = false;
        }
    }

    function get_failsEcho($i)
    {
        return $this->failsEcho[$i];
    }
    function set_failsEcho($i, $new)
    {
        $this->failsEcho[$i] = $new;
    }

    function get_echoTime($i)
    {
        return $this->echoTime[$i];
    }
    function set_echoTime($i, $new)
    {
        $this->echoTime[$i] = $new;
    }

    function get_failsDetect($i)
    {
        return $this->failsDetect[$i];
    }
    function set_failsDetect($i, $new)
    {
        $this->failsDetect[$i] = $new;
    }

    function get_failsFix($i)
    {
        return $this->failsFix[$i];
    }
    function set_failsFix($i, $new)
    {
        $this->failsFix[$i] = $new;
    }

    function get_hasTicket($i)
    {
        return $this->hasTicket[$i];
    }
    function set_hasTicket($i, $new)
    {
        $this->hasTicket[$i] = $new;
    }

    function get_tickets($i)
    {
        return $this->tickets[$i];
    }
    function set_tickets($i, $new)
    {
        $this->tickets[$i] = $new;
    }
}


?>