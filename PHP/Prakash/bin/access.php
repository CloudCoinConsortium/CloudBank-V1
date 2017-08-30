<?php
 
// require the autoloader that composer created
require_once 'vendor/autoload.php';
 
// use the firebase JWT Library previous installed using composer
use \Firebase\JWT\JWT;
 
// create a class for easy code structure and use
class userAuth {
	
	// create an empty id variable to hold the user id
	private $id;
	// create an empty email variable to hold the user email
	private $email;
	// key for JWT signing and validation, shouldn't be changed
	private $key = "secretSignKey";
	// create a dummy user for the tutorial
	private $user = array(
	  "id" => 77,
	  "email" => "pcmishra22@gmail.com",
	  "password" => "root1234"
	);



	// Checks if the user exists in the database
	private function validUser($email, $password) {
	  // doing a user exists check with minimal to no validation on user input
	  if ($email == $this->user['email'] && $password == $this->user['password']) {
	    // Add user email and id to empty email and id variable and return true
	    $this->id = $this->user['id'];
	    
	    $this->email = $this->user['email'];
	    
	    return true;
	  } else {
	    
	    return false;
	  }
	}
	// Generates and signs a JWT for User
	private function genJWT() {
	  // Make an array for the JWT Payload
	  $payload = array(
	    "id" => $this->id,
	    "email" => $this->email,
	    "exp" => time() + (60 * 60)
	  );
	 
	  // encode the payload using our secretkey and return the token
	  return JWT::encode($payload, $this->key);
	}
	// sends signed token in email to user if the user exists
	public function mailUser($email, $password) {
	  // check if the user exists
	  if ($this->validUser($email, $password)) {
	    // generate JSON web token and store as variable
	     $token = $this->genJWT();
	    // create email
	    echo $message = 'http://localhost/bankservice/index.php?token='.$token;
	    } 
	    /*
	    $mail = mail($this->email,"Authentication From localhost",$message);
	    
	    // if the email is successful, send feedback to user
	    
	    if ($mail) {
	      
	      return 'We Just Sent You An Email With Your Login Link';
	    } else {
	      
	      return 'An Error Occurred While Sending The Email';
	    }
	  } 
	  */
	  //else {
	    
	    //return 'We Couldn\'t Find You In Our Database. Maybe Wrong Email/Password Combination';
	  //}



	  
	}
	// Validates a given JWT from the user email
	  private function validJWT($token) {
	    $res = array(false, '');
	    // using a try and catch to verify
	    try {
	      //$decoded = JWT::decode($token, $this->key, array('HS256'));
	      $decoded = JWT::decode($token, $this->key, array('HS256'));
	    } catch (Exception $e) {
	      return $res;
	    }
	    $res['0'] = true;
	    $res['1'] = (array) $decoded;
	 
	    return $res;
	  }
	 
	 
	  public function validMail($token) {
	    // checks if an email is valid
	    $tokenVal = $this->validJWT($token);
	 
	    // check if the first array value is true
	    if ($tokenVal['0']) {
	      // create user session and all that good stuff
	      return "Everything went well, time to serve you what you need.";
	    } else {
	      return "There was an error validating your email. Send another link";
	    }
	  }

 
}
 
?>