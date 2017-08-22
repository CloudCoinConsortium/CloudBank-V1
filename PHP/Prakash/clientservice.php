<?php
 
/**
 * ServiceClient
 *
 *
 * @author Prakash
 *
 */
 
class ServiceClient
{
 
 public function __construct(){}
 
 /**
  * do a post request to a service
  *
  * the params parameter must be a string with the format:
  * key=val&key2=val2&key3=val3
  *
  * @param string $url
  * @param string $params
  */
 public function doPostRequest($url, $params)
 {
  $ch = curl_init($url);  
  curl_setopt($ch, CURLOPT_SSL_VERIFYPEER , false);
  curl_setopt($ch, CURLOPT_RETURNTRANSFER , true);
  curl_setopt($ch, CURLOPT_POST   , 1);
   curl_setopt($ch, CURLOPT_POSTFIELDS     , $params);
  $result = curl_exec($ch);
  curl_close($ch);
  return $result;
 }
 
 /**
  * do a get request to a service
  *
  * @param string $url
  *
  * @return mixed
  */
 public function doGetRequest($url)
 {
  $ch = curl_init($url);  
  curl_setopt($ch, CURLOPT_SSL_VERIFYPEER , false);
  curl_setopt($ch, CURLOPT_RETURNTRANSFER , true);
  $result = curl_exec($ch);
  curl_close($ch);
  return $result;
 }
 
}

?>