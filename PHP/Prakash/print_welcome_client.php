<?php
/**
 * ServiceClient
 *
 *
 * @author Prakash
 *
 */

//Configuration variables
require_once('config.php');

//Abstract class for client service.
require_once('clientservice.php');


class PrintWelcomeClient extends ServiceClient
{
 
   	public $params;
 	public function __construct()
 	{
 		$this->params='';
 	}
 
	public function sendRequest($data)
	{
 		echo $this->doPostRequest(URL, $this->params);
	}
}

//create object

$objPrintWelcomeClient=new PrintWelcomeClient();
//call method

$objPrintWelcomeClient->sendRequest();

?>