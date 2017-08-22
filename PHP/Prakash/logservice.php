<?php
/**
 * Example of using the LoggerService class
 *
 * log service request
 *
 * @author Prakash
 */
	trait LogService {

    	public function logToFile($filename, $msg) 
	   	{  
		   if (file_exists($filename)) {
		   	// open file 
			  $fh = fopen($filename, 'a');
			  // write string 
			  fwrite($fh, $msg."\n");
			} else {
			// open file 	
			  $fh = fopen($filename, 'w');
			  // write string 
			  fwrite($fh, $msg."\n");
			}
			// close file 
			fclose($fh);
	   	} 
}
?>