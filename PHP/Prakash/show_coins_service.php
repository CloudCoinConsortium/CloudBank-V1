<?php
/**
 * Example of using the ServiceServer class
 *
 * Returns countries or cities
 *
 * @author Prakash
 */

require_once('config.php');
require_once('serverservice.php');

class PrintWelcomeServer extends ServiceServer
{
 
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
					"server"=>"www.myBank.com",
			 		"status"=>"welcome",
			 		"version"=>"4.07.17",
			 		"message"=>"CloudCoin Bank. Used to Authenticate, Store and Payout CloudCoins. 
								This Software is provided as is with all faults, defects and errors, and 
								without warranty of any kind.Free from the CloudCoin Consortium.",
			 		"time"=>"2016-40-21 10:40:PM"
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

//get the data needed to response

$data=$objPrintWelcomeServer->getData();

//return data

$objPrintWelcomeServer->displayJSONResult($data);
}
catch(Exception $e){
	echo $e->getMessage();
}

?>