<?php
/**
 * Example of using the ServiceServer class
 *
 * Returns welcome service message
 *
 * @author Prakash
 */

require_once('config.php');
require_once('serverservice.php');
require_once('logservice.php');
require_once('validateuserservice.php');

class PrintWelcomeServer extends ServiceServer
{
 //use logger service trait
 use LogService,ValidateUserService;

 public $data=array();

//initialize constructor
 
 public function __construct()
 {
 	 	$this->data=array();
 }
 
 //set data

 public function setData()
 {
 	 	$this->data=array(
					"server"=>SERVERNAME,
			 		"status"=>"welcome",
			 		"version"=>VERSION,
			 		"message"=>"CloudCoin Bank. Used to Authenticate, Store and Payout CloudCoins. 
								This Software is provided as is with all faults, defects and errors, and 
								without warranty of any kind.Free from the CloudCoin Consortium.",
			 		"time"=>TIME
 		);
 }

 //fetch data
 public function getData()
 {
 	return $this->data;
 }

}

try{
	//create object for print welcome

	$objPrintWelcomeServer=new PrintWelcomeServer();

	//get the data needed to response

	$data=$objPrintWelcomeServer->setData();

	//log service request
	
	$logfile=get_class($objPrintWelcomeServer).'.txt';

	$objPrintWelcomeServer->logToFile($logfile,json_encode($_SERVER));


	if($objPrintWelcomeServer->validateUser('user','password'))
	{
		//get the data needed to response

		$data=$objPrintWelcomeServer->getData();
		
		//return data

		$objPrintWelcomeServer->displayJSONResult($data);
	}
	else
	{
		echo 'Unauthorised Access';
	}


}
catch(Exception $e){
	echo $e->getMessage();
}

?>