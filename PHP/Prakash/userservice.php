<?php
/**
 * Example of using the UserService class
 *
 * User service request
 *
 * @author Prakash
 */
class userService {
	
	//this is the user id	

	private $uid;

	//constructor for the user service
		
 	public function __construct()
 	{
 	 	//default value not set
 	}
 	
 	//check if uid is valid
 	
 	public function validUserId($uid)
 	{
		// check for valid characters
		//if (!preg_match('/[^A-Za-z0-9]/', $uid)) 
		if (!preg_match('/[\'\/\*\<\>\?:"\|\\\]/', $uid))
		{
			return true;
		}
		else
		{
			return false;
		}
	}
	
	//create user if user id is valid
	
	public function createUser($uid)
	{
		if (!file_exists($uid))
		{
    		mkdir($uid, 0777, true);
    		mkdir($uid.'/Bank', 0777, true);
    		mkdir($uid.'/Broke', 0777, true);
    		mkdir($uid.'/Counterfeit', 0777, true);
    		mkdir($uid.'/Export', 0777, true);
    		mkdir($uid.'/Fracked', 0777, true);
    		mkdir($uid.'/Import', 0777, true);
    		mkdir($uid.'/Imported', 0777, true);
    		mkdir($uid.'/Logs', 0777, true);
    		mkdir($uid.'/Lost', 0777, true);
    		mkdir($uid.'/Suspect', 0777, true);
    		mkdir($uid.'/Templates', 0777, true);
    		mkdir($uid.'/Trash', 0777, true);
    		mkdir($uid.'/Waiting', 0777, true);
    		
			return true;
		}
		else 
		{			
			return false;
		}	 
	} 
}
?>