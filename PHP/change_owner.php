<?php
$sn = $_POST["sn"];
$newid = $_POST["newid"];
$file = new FileUtils();

$oldFileName = glob("*".$sn.".cloudcoin.*")[0];
$cc = $file->loadOneCloudCoinFromJsonFile($oldFileName);
$cu = new CoinUtils($cc);
$cu->grade();
$folder = $cu->getFolder()."/";
$file->importTo($cc, $folder, $newid);


?>