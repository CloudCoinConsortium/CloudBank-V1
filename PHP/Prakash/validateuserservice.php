<?php
/**
 * Example of using the LoggerService class
 *
 * validate user service request
 *
 * @author Prakash
 */
	trait ValidateUserService {

    	public function validateUser($user, $pass) 
	   	{  
		   if ($user==USER && $pass==PASSWORD) {
		   	return true;
		   }
		   else
		   {
		   	return false;
		   }

	   	} 
}
?>