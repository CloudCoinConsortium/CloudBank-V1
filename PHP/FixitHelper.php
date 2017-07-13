<?php
class FixitHelper
{
    var $trustedServers
    var $trustedTriad1;
    var $trustedTriad2;
    var $trustedTriad3;
    var $trustedTriad4;
    var $currentTriad;
    var $ans1;
    var $ans2;
    var $ans3;
    var $ans4;
    var $currentAns;
    var $finnished = false;
    var $triad_1_is_ready = false;
    var $triad_2_is_ready = false;
    var $triad_3_is_ready = false;
    var $triad_4_is_ready = false;
    var $currentTriadReady = false;

    function __construct($raidaNumber, $ans)
    {
        switch($raidaNumber)
        {
            case 0: $this->trustedServers = array( 19, 20, 21, 24, 1, 4, 5, 6 ); break;
                case 1: $this->trustedServers = array( 20, 21, 22, 0, 2, 5, 6, 7 ); break;
                case 2: $this->trustedServers = array( 21, 22, 23, 1, 3, 6, 7, 8 ); break;
                case 3: $this->trustedServers = array( 22, 23, 24, 2, 4, 7, 8, 9 ); break;
                case 4: $this->trustedServers = array( 23, 24, 0, 3, 5, 8, 9, 10 ); break;
                case 5: $this->trustedServers = array( 24, 0, 1, 4, 6, 9, 10, 11 ); break;
                case 6: $this->trustedServers = array( 0, 1, 2, 5, 7, 10, 11, 12 ); break;
                case 7: $this->trustedServers = array( 1, 2, 3, 6, 8, 11, 12, 13 ); break;
                case 8: $this->trustedServers = array( 2, 3, 4, 7, 9, 12, 13, 14 ); break;
                case 9: $this->trustedServers = array( 3, 4, 5, 8, 10, 13, 14, 15); break;
                case 10: $this->trustedServers = array( 4, 5, 6, 9, 11, 14, 15, 16 ); break;
                case 11: $this->trustedServers = array( 5, 6, 7, 10, 12, 15, 16, 17 ); break;
                case 12: $this->trustedServers = array( 6, 7, 8, 11, 13, 16, 17, 18 ); break;
                case 13: $this->trustedServers = array( 7, 8, 9, 12, 14, 17, 18, 19 ); break;
                case 14: $this->trustedServers = array( 8, 9, 10, 13, 15, 18, 19, 20); break;
                case 15: $this->trustedServers = array( 9, 10, 11, 14, 16, 19, 20, 21 ); break;
                case 16: $this->trustedServers = array( 10, 11, 12, 15, 17, 20, 21, 22 ); break;
                case 17: $this->trustedServers = array( 11, 12, 13, 16, 18, 21, 22, 23 ); break;
                case 18: $this->trustedServers = array( 12, 13, 14, 17, 19, 22, 23, 24 ); break;
                case 19: $this->trustedServers = array( 13, 14, 15, 18, 20, 23, 24, 0 ); break;
                case 20: $this->trustedServers = array( 14, 15, 16, 19, 21, 24, 0, 1 ); break;
                case 21: $this->trustedServers = array( 15, 16, 17, 20, 22, 0, 1, 2 ); break;
                case 22: $this->trustedServers = array( 16, 17, 18, 21, 23, 1, 2, 3 ); break;
                case 23: $this->trustedServers = array( 17, 18, 19, 22, 24, 2, 3, 4 ); break;
                case 24: $this->trustedServers = array( 18, 19, 20, 23, 0, 3, 4, 5 ); break;
        }

        $this->trustedTriad1 = array( $this->trustedServers[0], $this->trustedServers[1], $this->trustedServers[3] );
            $this->trustedTriad2 = array( $this->trustedServers[1], $this->trustedServers[2], $this->trustedServers[4] );
            $this->trustedTriad3 = array( $this->trustedServers[3], $this->trustedServers[5], $this->trustedServers[6] );
            $this->trustedTriad4 = array( $this->trustedServers[4], $this->trustedServers[6], $this->trustedServers[7] );
            $this->currentTriad = $this->trustedTriad1;

        $ans1 = array($ans[$trustedTriad1[0]], $ans[$trustedTriad1[1]], $ans[$trustedTriad1[2]] );
        $ans2 = array($ans[$trustedTriad2[0]], $ans[$trustedTriad2[1]], $ans[$trustedTriad2[2]]);
        $ans3 = array($ans[$trustedTriad3[0]], $ans[$trustedTriad3[1]], $ans[$trustedTriad3[2]]);
        $ans4 = array($ans[$trustedTriad4[0]], $ans[$trustedTriad4[1]], $ans[$trustedTriad4[2]]);

        $currentAns = $ans1;
    }

    function setCornerToCheck($corner)
    {
        switch($corner)
        {
            case 1:
            $this->currentTriad = $this->trustedTriad1;
            $this->currentTriadReady = $this->triad_1_is_ready;
            break;
            case 2:
                    $this->currentTriad = $this->trustedTriad2;
                    $this->currentTriadReady = $this->triad_2_is_ready;
                    break;
                case 3:
                    $this->currentTriad = $this->trustedTriad3;
                    $this->currentTriadReady = $this->triad_3_is_ready;
                    break;
                case 4:
                    $this->currentTriad = $this->trustedTriad4;
                    $this->currentTriadReady = $this->triad_4_is_ready;
                    break;
                default:
                    $this->finnished = true;
                    break;
        }
    }

    function setCornerToTest($mode)
    {

            switch ($mode)
            {
                case 1:
                    $this->currentTriad = $this->trustedTriad1;
                    $this->currentAns = $this->ans1;
                    $this->currentTriadReady = true;
                    break;
                case 2:
                    $this->currentTriad = $this->trustedTriad2;
                    $this->currentAns = $this->ans2;
                    $this->currentTriadReady = true;
                    break;
                case 3:
                    $this->currentTriad = $this->trustedTriad3;
                    $this->currentAns = $this->ans3;
                    $this->currentTriadReady = true;
                    break;
                case 4:
                    $this->currentTriad = $this->trustedTriad4;
                    $this->currentAns = $this->ans4;
                    $this->currentTriadReady = true;
                    break;
                default:
                    $this->finnished = true;
                    break;
            }//end switch
        }
}
?>