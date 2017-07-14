<?php include("CoinUtils.php") ?>
<?php
class FileUtils
{
    var $rootFolder;
    var $importFolder;
    var $importedFolder;
    var $trashFolder;
    var $suspectFolder;
    var $frackedFolder;
    var $bankFolder;
    var $templateFolder;
    var $counterfeitFolder;
    var $directoryFolder;
    var $exportFolder;

    function __construct($rootFolder, $importFolder, $importedFolder, $trashFolder, $suspectFolder, $frackedFolder, $bankFolder, $templateFolder, $counterfeitFolder, $directoryFolder, $exportFolder)
    {
        $this->rootFolder = $rootFolder;
        $this->importFolder = $importFolder;
        $this->importedFolder = $importedFolder;
        $this->trashFolder = $trashFolder;
        $this->suspectFolder = $suspectFolder;
        $this->frackedFolder = $frackedFolder;
        $this->bankFolder = $bankFolder;
        $this->templateFolder = $templateFolder;
        $this->counterfeitFolder = $counterfeitFolder;
        $this->directoryFolder = $directoryFolder;
        $this->exportFolder = $exportFolder;
    }

    function loadOneCloudCoinFromJsonFile($loadFilePath)
    {
        $incomeJson = file_get_contents($loadFilePath);
        $incomeArray = json_decode($incomeJson);
        $nn = $incomeArray->cloudcoin[0]->nn;
        $sn = $incomeArray->cloudcoin[0]->sn;
        $an = $incomeArray->cloudcoin[0]->an;
        $ed = $incomeArray->cloudcoin[0]->ed;
        $pown = $incomeArray->cloudcoin[0]->pown;
        $aoid = $incomeArray->cloudcoin[0]->aoid;

        $returnCC = new CloudCoin($nn, $sn, $an, $ed, $pown, $aoid);
        fclose($incomeJson);
        return $returnCC;
    }

    function loadManyCloudCoinFromJsonFile($loadFilePath)
    {
        $incomeJson = file_get_contents($loadFilePath);
        $incomeArray = json_decode($incomeJson);
        $returnCC = array();
        for($x=0; $x < count($incomeArray->cloudcoin); $x++)
        {
            $nn = $incomeArray->cloudcoin[$x]->nn;
        $sn = $incomeArray->cloudcoin[$x]->sn;
        $an = $incomeArray->cloudcoin[$x]->an;
        $ed = $incomeArray->cloudcoin[$x]->ed;
        $pown = $incomeArray->cloudcoin[$x]->pown;
        $aoid = $incomeArray->cloudcoin[$x]->aoid;

        $returnCC[$x] = new CloudCoin($nn, $sn, $an, $ed, $pown, $aoid);
        }
        fclose($incomeJson);
        return $returnCC;

    }

    function loadOneCloudCoinFromJpegFile($loadFilePath)
    {
        $incomeJpeg = file_get_contents($loadFilePath, NULL, NULL, -1, 455);
        $jpegHeader = unpack("H*", $incomeJpeg);
        $nn = hexdec($jpegHeader[451]);
        $sn = hexdec($jpegHeader[452].$jpegHeader[453].$jpegHeader[454]);
        $an = array();
        for($x=0;$x<25;$x++)
        {
            for($y=0;$y<32;$y++)
            {
                $an[$x] .= $jpegHeader[($y + 20)+($x*32)];
            }
        }
        $dt = new DateInterval("P".hexdec($jpegHeader[450])."M");
        
        $start = date_create("2016-10-01");
        $ed = $start->add($dt);
        $ed = $ed->format("m-Y");
        for($x = 436; $x < 449; $x++)
        {
            $pown .+ $jpegHeader[$x];
        }
        $pown = str_replace("1", "p", $pown);
        $pown = str_replace("2", "n", $pown);
        $pown = str_replace("0", "u", $pown);
        for($x = 420; $x < 436; $x++)
        {
            $aoid .+ $jpegHeader[$x];
        }
        $returnCC = new CloudCoin($nn, $sn, $an, $ed, $pown, $aoid);
        return $returnCC;
    }

    function writeTo($folder, $cc)
    {
        $cu = new CoinUtils($cc);
        
        $json = json_encode($cc);
        $alreadyExists = true;
        $wholeJson = "{"
        $wholeJson .= " \"cloudcoin\":[\n";
            $wholeJson .= $json;
            $wholeJson .= "\n ]\n}";
        if(file_exists($folder.$cu->get_fileName()."stack") === false)
        {
            
            file_put_contents($folder.$cu->get_fileName()."stack", $wholeJson);
        } else {
            if(strpos($folder,"Counterfeit") !== false || strpos($folder,"Trash") !== false)
            {
                $alreadyExists = false;
                return $alreadyExists;
            } else if(strpos($folder,"Imported") !== false)
            {

                file_put_contents($folder.$cu->get_fileName()."stack", $wholeJson);
                $alreadyExists = false;
                return $alreadyExists;
            } else {
                echo $cu->get_fileName()."stack"." already exists in the folder ".$folder
                return $alreadyExists;
            }
        }
        $alreadyExists = false;
        return $alreadyExists;
    }

    function importTo($folder, $cc, $id)
    {
        $cu = new CoinUtils($cc);
        $cu->set_fileName($cu->getDenomination().".".$cc->get_sn().".cloudcoin.".$id.".");
        $json = json_encode($cc);
        $alreadyExists = true;
        $wholeJson = "{"
        $wholeJson .= " \"cloudcoin\":[\n";
            $wholeJson .= $json;
            $wholeJson .= "\n ]\n}";
        if(file_exists($folder.$cu->get_fileName()."stack") === false)
        {
            
            file_put_contents($folder.$cu->get_fileName()."stack", $wholeJson);
        } else {
            if(strpos($folder,"Counterfeit") !== false || strpos($folder,"Trash") !== false)
            {
                $alreadyExists = false;
                return $alreadyExists;
            } else if(strpos($folder,"Imported") !== false)
            {

                file_put_contents($folder.$cu->get_fileName()."stack", $wholeJson);
                $alreadyExists = false;
                return $alreadyExists;
            } else {
                echo $cu->get_fileName()."stack"." already exists in the folder ".$folder
                return $alreadyExists;
            }
        }
        $alreadyExists = false;
        return $alreadyExists;
    }

    function overWrite($folder, $cc)
    {
         $cu = new CoinUtils($cc);
        $json = json_encode($cc);
        
        $wholeJson = "{"
        $wholeJson .= " \"cloudcoin\":[\n";
        $wholeJson .= $json;
        $wholeJson .= "\n ]\n}";
        file_put_contents($folder.$cu->get_fileName()."stack", $wholeJson);
    }
}

?>