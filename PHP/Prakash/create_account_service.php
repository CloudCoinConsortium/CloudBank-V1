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
require_once('userservice.php');
require_once('logservice.php');
require_once('bin/access.php');

class CreateAccountServer extends ServiceServer
{
 	//use logger service trait
 	use LogService;

 	public $data=array();
	private $auth;
	//initialize constructor
 
 	public function __construct()
 	{
 	 	$this->data=array();
 	}

}

try{
	//create object for print welcome

	$objCreateAccountServer=new CreateAccountServer();
	
	//log service request
	
	$logfile=get_class($objCreateAccountServer).'.txt';
	$objCreateAccountServer->logToFile($logfile,json_encode($_SERVER));
	
	//check validity

	if (!empty($_GET['token']))
	{
			$auth = new userAuth();
			if( $auth->validToken($_GET['token']))
			{
						$objuserService=new userService();

						//to validate user id

						$uid=$_GET['uid'];
						if($uid=='')
						{
								$data=array(
											"server"=>SERVERNAME,
			 								"status"=>"added",
			 								"version"=>VERSION,
			 								"message"=>"Please provide User ID. ",
			 								"time"=>TIME
 									);								
								
								
								//return data
								$objCreateAccountServer->displayJSONResult($data);
								exit();
						
						}
						
						if($objuserService->validUserId($uid))
						{
							//check if user exists
							if($objuserService->createUser($uid))
							{
								
								 	 $data=array(
											"server"=>SERVERNAME,
			 								"status"=>"added",
			 								"version"=>VERSION,
			 								"message"=>"Account created for user ".$uid,
			 								"time"=>TIME
 									);								
								
								
								//return data
								$objCreateAccountServer->displayJSONResult($data);
							}
							else
								{
									
									$data=array(
											"server"=>SERVERNAME,
			 								"status"=>"success",
			 								"version"=>VERSION,
			 								"message"=>"Account exists already for user ".$uid,
			 								"time"=>TIME
 									);								
									//return data
									$objCreateAccountServer->displayJSONResult($data);
								}
						}
						else
						{
							
							 $data=array(
											"server"=>SERVERNAME,
			 								"status"=>"notadded",
			 								"version"=>VERSION,
			 								"message"=>"Account was not created for user ".$uid,
			 								"time"=>TIME
 									);								
							//return data
							$objCreateAccountServer->displayJSONResult($data);
						}		
		
			}
			else
			{
								 $data=array(
											"server"=>SERVERNAME,
			 								"status"=>"notauthorised",
			 								"version"=>VERSION,
			 								"message"=>"Unauthorised Access ",
			 								"time"=>TIME
 									);		
				//return data
				$objCreateAccountServer->displayJSONResult($data);
			}	
	}
	 else
	 {
			$data=array(
							"server"=>SERVERNAME,
			 				"status"=>"notauthorised",
			 				"version"=>VERSION,
			 				"message"=>"Unauthorised Access ",
			 				"time"=>TIME
 			);	
			//return data
			$objCreateAccountServer->displayJSONResult($data);
	}

}
catch(Exception $e){
	echo $e->getMessage();
}

?>