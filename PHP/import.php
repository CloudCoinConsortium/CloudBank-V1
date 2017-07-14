<?php
$file = new FileUtils();
$raida = new RAIDA(3000);
$folder = "Suspect/";
$target_file = $folder . basename($_FILES["fileToUpload"]["name"]);
$fileType = pathinfo($target_file,PATHINFO_EXTENSION);
$uploadOK = 1;
$cc = array();
$id = $_POST["id"];

if($ifileType != "jpg" && $fileType != "jpeg"
&& $fileType != "stack" ) {
    echo "Sorry, only JPG, JPEG, & STACK files are allowed.";
    $uploadOK = 0;
}
if($uploadOK == 0)
{
    echo "not uploaded";
} else {
if(move_uploaded_file($_FILES["fileToUpload"]["tmp_name"], $target_file))
{
    if($fileType = "stack"){
        $cc = $file->loadManyCloudCoinFromJson($target_file);
    } else {
        $cc[0] = $file->loadOneCloudCoinFromJpeg($target_file);
    }
    for($x=0;$x < count($cc); $x++)
    {
    $cu = new CoinUtils($cc[$x]);
    $cu = $raida->detectCoin($cu);
    $folder = $cu->getFolder()."/";
    $file->importTo($folder, $cc[$x], $id);
    echo "Imported ".$cc[$x]->get_sn()." to folder ".$folder;
    
    }
    #delete($target_file);
} else
{
    echo "error";
}
}
?>