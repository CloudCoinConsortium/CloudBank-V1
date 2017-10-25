<!DOCTYPE html>
<html class="no-js" lang="en" dir="ltr">
  <head>
    <meta name="generator"
    content="HTML Tidy for HTML5 (experimental) for Windows https://github.com/w3c/tidy-html5/tree/c63cc39" />
    <meta charset="utf-8" />
    <meta http-equiv="x-ua-compatible" content="ie=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Learn About CloudCoins</title>

<link rel="apple-touch-icon" sizes="180x180" href="/apple-touch-icon.png">
<link rel="icon" type="image/png" href="/favicon-32x32.png" sizes="32x32">
<link rel="icon" type="image/png" href="/favicon-16x16.png" sizes="16x16">
<link rel="manifest" href="/manifest.json">
<link rel="mask-icon" href="/safari-pinned-tab.svg" color="#5bbad5">
<meta name="theme-color" content="#ffffff">
    <link rel="stylesheet" href="css/foundation.css" />
    <link rel="stylesheet" href="css/app.css" />
    <link href='//fonts.googleapis.com/css?family=Roboto:400,300' rel='stylesheet' type='text/css' />
    <style>
    h1, h2, h3, h4, h5, h6 {
    font-family: &#39;Roboto&#39;, sans-serif;

    color: #338FFF;
}
.button{

background-color:#338FFF;
}
a{
color:#5FCAF5;
font-family: 'Roboto', sans-serif;
font-weight:  bold;
}



#cloud {

    position: relative;

    animation-name: example;
    animation-duration: 100s;
    animation-iteration-count: infinite;    
}

@keyframes example {
    0%   {color: white; left:0px; top:0px;}
    20%  {color: #338FFF; left:50px; top:30px;}
    40%  {color: white; left:100px; top:-25px;}
    60%  {color: #338FFF; left:150px; top:-10px;}
    80%  {color: white; left:100px; top:-25px;}
    100% {color: #338FFF; left:50px; top:10px;}
}
body
{
background: url(img/bg.jpg) no-repeat;
background-size: 100%;
}
    
</style>
  </head>
  <body>
  <div class="top-bar"
  style=" font-family: &#39;Roboto&#39;, sans-serif; font-size: 1.6vw; font-weight: bold; text-size-adjust:800;">

    <div class="row">
      <div class="top-bar-left">
        <ul class="dropdown menu" data-dropdown-menu="" style=" font-family: &#39;Roboto&#39;, sans-serif; background-color:white;">
          <li class="menu-text">
<a href="index.html">
<img src="img/cloudcointop.png" alt="CloudCoin logo" width="200">
</a>
</li>
           <li>
            Learn
          </li>          
          <li>
            <a href="use.html">Use</a>
          </li>
          <li>
            <a href="https://cloudcoinconsortium.com/buy.php">Buy</a>
          </li>
           <li>
            <a href="/news/">News</a>
          </li>
<!--
            <li>
            <a href="buy.php">Buy</a>
          </li>
          <li class="has-submenu">
            <a href="overview.html">Learn</a>
            <ul class="submenu menu vertical" data-submenu=""
            style=" font-family: &#39;Roboto&#39;, sans-serif; font-size: 1.2vw; font-weight: bold; text-size-adjust:1005; text-shadow: 1px 1px 2px #000000;">

              <li>
                <a href="overview.html">Just an overview</a>
              </li>
              <li>
                <a href="indepth.html">In Depth</a>
              </li>
              <li>
                <a href="everydetail.html">Every Detail</a>
              </li>
            </ul>
          </li>
-->
        </ul>
      </div>
      <div class="top-bar-right">
        <ul class="menu" style=" font-family: &#39;Roboto&#39;, sans-serif; background-color:white;">
          <li>
       
            
            <form action="//www.findberry.com/search/" method="get" id="sr_newpage"  style="display:inline">
  <input type="hidden" name="wid" value="5222" />
  <input id="sr_searchbox" type="text" name="query" value="" size="35" style="display:inline"/>


            
          </li>
          <li>
             <input id="sr_searchbutton" type="submit" class="button" value="Search" />

</form>
          </li>
        </ul>
      </div>
    </div>
  </div>
  <br />
 <div class="row">
    <div class="large-12 columns">
        <br>
        <br>
        <h3 class="white text-center" style="color:black;">

<?php

if(is_uploaded_file($_FILES["stack"]["tmp_name"]))
{
    $stack = file_get_contents($_FILES["stack"]["tmp_name"]);
    $cc = json_decode($stack);
    if(getDenomination($cc->cloudcoin[0]->sn) != 250 || count($cc->cloudcoin) > 1)
        echo "You need to give a stack file with only one CloudCoin note of the 250 denomination.";
    else{
    echo "Authenticating CloudCoin<br>";
    $ch_i = curl_init("https://cloudbank.cloudcoin.global/bank_service/import_one_stack.aspx");
    curl_setopt($ch_i, CURLOPT_HEADER, 0);
    curl_setopt($ch_i, CURLOPT_RETURNTRANSFER, true);

    curl_setopt($ch_i, CURLOPT_POST, true);
    curl_setopt($ch_i, CURLOPT_POSTFIELDS, "stack=".$stack);
    $i_request = curl_exec($ch_i);
    if($i_request === false)
        echo "didn't work: " . curl_error($ch_i);
    else{
        $i_response = json_decode($i_request);
        if($i_response->status == "importing"){
            $ch_r = curl_init("https://cloudbank.cloudcoin.global/bank_service/get_receipt.aspx?id=".$i_response->receipt);
            curl_setopt($ch_i, CURLOPT_HEADER, 0);
            curl_setopt($ch_r, CURLOPT_RETURNTRANSFER, true);

            $r_request = curl_exec($ch_r);
            if($r_request === false)
                echo "didn't work: " . curl_error($ch_r);
            else{
                $r_response = json_decode($r_request);
                $in = 0;
                if($r_response->receipt[0] == null)
                    $in++;
                if($r_response->receipt[$in]->status == "authentic" && getDenomination($r_response->receipt[$in]->sn) == 250){
                    
                    echo "Your CloudCoin has been determined to be authentic. Your book will be downloaded automatically.<br>";
                    echo "<meta http-equiv='refresh' content='0; url=downloadbook.php'>";
                    echo "<a href='downloadbook.php'>Click here if your download hasn't started.</a>";
                    
                }else{
                    echo "Sorry, the CloudCoin has been determined to not be authentic.";
                }
            }
            curl_close($ch_r);
        }else
            echo "Error occured when importing CloudCoin.";
    }
    curl_close($ch_i);
    }
    
}
else{
    echo "No file uploaded. ". $_FILES["stack"]["tmp_name"];}


function getDenomination($sn)
{
    $nom = 0;
    if (($sn < 1))
    {
        $nom = 0;
    }
    else if (($sn < 2097153))
    {
        $nom = 1;
    }
    else if (($sn < 4194305))
    {
        $nom = 5;
    }
    else if (($sn < 6291457))
    {
        $nom = 25;
    }
    else if (($sn < 14680065))
    {
        $nom = 100;
    }
    else if (($sn < 16777217))
    {
        $nom = 250;
    }
    else
    {
        $nom = '0';
    }

    return $nom;
}

?>
</h3>
</div>
  </div>

       <div class="row">
         <div class="large-3 columns" >
             CloudCoin Consortium &copy; 2017 
         </div>
         <div class="large-3 columns" >
           <a href="mailto:CloudCoin@Protonmail.com?Subject=CloudCoinConsortium.com" target="_top">CloudCoin@Protonmail.com</a>
         </div>
        <div class="large-2 columns" >
            1 (530)591-7028
         </div>
         <div class="large-4 columns" >
            <b>Privacy Policy:</b><br> We do not collect user data.
         </div>
       </div>

  <script src="js/vendor/jquery.js"></script> 
  <script src="js/vendor/what-input.js"></script> 
  <script src="js/vendor/foundation.js"></script> 
  <script src="js/app.js"></script></body>
</html>