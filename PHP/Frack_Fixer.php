<?php include("RAIDA.php") ?>
<?php include("FileUtils.php") ?>
<?php
class Frack_Fixer()
{
    private $fileUtils
    private $totalValueToBank;
    private $totalValueToFractured;
    private $totalValueToCounterfeit;
    private $raida;

    function __construct($fileUtils, $timeout)
    {
        $this->fileUtils = $fileUtils;
        $this->raida = new RAIDA($timeout);
        $this->totalValueToBank = 0;
        $this->totalValueToCounterfeit = 0;
        $this->totalValeuToFractured = 0;
    }

    function fixOneGuidCorner($raida_ID, $cc, $corner, $trustedTriad)
    {
        $cu = new CoinUtils($cc);
    }
}

?>