<?php
$ch_b = curl_init("https://cloudcoin.global/pdf/book.pdf");
$header = array('Content-type: application/pdf', 'Content-Disposition: attachment; filename="Beyond-Bitcoin.pdf"');
curl_setopt($ch_b, CURLOPT_HTTPHEADER, $header);
header('Content-Disposition: attachment; filename="Beyond-Bitcoin.pdf"');
curl_exec($ch_b);
curl_close($ch_b);

?>