<?php
 
require_once 'bin/access.php';
 
$auth = new userAuth();
 
if (!empty($_POST)) {
  $email = $_POST['email'];
  $pswd = $_POST['password'];
  //.......
  // do your data santization and validation here
  // Like check if values are empty or contain invalid characters
  //.......
 
  // If everything is valid, send the email
  $msg = $auth->getToken($email, $pswd);
 
} else if (!empty($_GET['token'])) {
  $token = $_GET['token'];
  //.......
  // do your data santization here
  //.......
 
  // pass along to be validated
  $msg = $auth->validToken($token);
}
 
if (isset($msg)) {
  echo $msg;
}
 
?>