<?php
/**
 * Example of using the ServiceServer class
 *
 * Returns welcome service message
 *
 * @author Prakash
 */
abstract class ServiceServer
{
 //constructor
 public function __construct(){}
 
 //json result
 public function displayJSONResult($data)
 {
  header('Content-type: text/plain');
 
  echo json_encode($data);
 
  exit();
 }
}
?>