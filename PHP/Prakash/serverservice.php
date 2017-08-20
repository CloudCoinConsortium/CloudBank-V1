<?php

abstract class ServiceServer
{
 
 public function __construct(){}
 
 public function displayJSONResult($data)
 {
  header('Content-type: text/plain');
 
  echo json_encode($data);
 
  exit();
 }
}
?>