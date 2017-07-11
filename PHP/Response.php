<?php
class Response
{
    var $fullRequest = "No request";
    var $fullResponse = "No response";
    var $success = false;
    var $outcome = "not used";
    var $milliseconds = 0;

    function __construct($success, $outcome, $milliseconds, $fullRequest, $fullResponse)
        {
            $this->success = $success;
            $this->outcome = $outcome;
            $this->milliseconds = $milliseconds;
            $this->fullRequest = $fullRequest;
            $this->fullResponse = $fullResponse;
        }

    function get_fullRequest()
    {
        return $this->fullRequest;
    }

    function set_fullRequest($new_fullRequest)
    {
        $this->fullRequest = $new_fullRequest;
    }
    
    function get_fullResponse()
    {
        return $this->fullResponse;
    }

    function set_fullResponse($new_fullResponse)
    {
        $this->fullResponse = $new_fullResponse;
    }

    function get_success()
    {
        return $this->success;
    }

    function set_success($new_success)
    {
        $this->success = $new_success;
    }

    function get_outcome()
    {
        return $this->outcome;
    }

    function set_outcome($new_outcome)
    {
        $this->outcome = $new_outcome;
    }

    function get_milliseconds()
    {
        return $this->milliseconds;
    }

    function set_milliseconds($new_milliseconds)
    {
        $this->milliseconds = $new_milliseconds;
    }

}

?>