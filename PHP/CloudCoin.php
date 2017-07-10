<?php
    class CloudCoin {
        var $nn;
        var $sn;
        var $an = array();
        var $ed;
        var $pown;
        var $aoid;

        function __construct($nn, $sn, $an, $ed, $pown, $aoid)
        {
            $this->nn = $nn;
            $this->sn = $sn;
            $this->an = $an;
            $this->ed = $ed;
            $this->pown = $pown;
            $this->aoid = $aoid;
        }

        function get_nn()
        {
            return $this->nn;
        }

        function set_nn($new_nn)
        {
            $this->nn = $new_nn;
        }

        function get_sn()
        {
            return $this->sn;
        }

        function set_sn($new_sn)
        {
            $this->sn = $new_sn;
        }

        function get_an()
        {
            return $this->an;
        }

        function get_an($i)
        {
            return $this->an[$i];
        }

        function set_an($new_an)
        {
            $this->an = $new_an;
        }

        function set_an($i, $new_an)
        {
            $this->an[$i] = $new_an;
        }

        function get_ed()
        {
            return $this->ed;
        }

        function set_ed($new_ed)
        {
            $this->ed = $new_ed;
        }

        function get_pown()
        {
            return $this->pown;
        }

        function set_pown($new_pown)
        {
            $this->pown = $new_pown;
        }

        function get_aoid()
        {
            return $this->aoid;
        }

        function set_nn($new_aoid)
        {
            $this->aoid = $new_aoid;
        }


    }



?>