<?php
/*-----8<--------------------------------------------------------------------
 *
* BEdita - a semantic content management framework
*
* Copyright 2014 ChannelWeb Srl, Chialab Srl
*
*------------------------------------------------------------------->8-----
*/

require_once APP . DS . 'vendors' . DS . 'shells'. DS . 'bedita_base.php';

/** * format shell script */
class FormatShell extends BeditaBaseShell {

    private $logLevels = array(
        'ERROR' => 0,
        'WARN' => 1,
        'INFO' => 2,
        'DEBUG' => 3
    );
    private $options = array(
        'import' => array(
            'saveMode' => 1
            // 'sourceMediaRoot' => ''
            // 'preservePaths'
        ),
        'export' => array(
        )
    );

    public function import() {

        $this->hr();

        if (empty($this->params['f'])) {
            $this->trackInfo('Missing filename parameter');
            $this->help();
            return;
        }

        // 1. reading file
        $inputData = @file_get_contents($this->params['f']);
        if (!$inputData) {
            $this->trackInfo('File "' . $this->params['f'] . '" not found');
            return;
        }

        $this->trackInfo('::: import start :::');

        if (isset($this->params['v'])) {
            $this->options['import']['logDebug'] = true;
        }
        
        // 2. do import
        $beFormat = ClassRegistry::init('BEFormat');
        $result = $beFormat->import($inputData, $this->options['import']);

        // 3. end
        $this->trackInfo('');
        $this->trackInfo('::: import end :::');
    }

    public function export() {

        $this->hr();

        if (empty($this->params['f'])) {
            $this->trackInfo('Missing filename parameter');
            $this->help();
            return;
        }

        if (empty($this->params['rootId'])) {
            $this->trackInfo('Missing root parameter');
            $this->help();
            return;
        }

        $this->trackInfo('::: export start :::');

        if (isset($this->params['v'])) {
            $this->options['import']['logDebug'] = true;
        }

        // 1. get data for rootId
        $rootId = $this->params['rootId'];
        $beObject = ClassRegistry::init('BEObject');
        if (
            !(
                $o = $beObject->find(
                        'first',
                        array(
                            'conditions' => array(
                                'BEObject.id' => $rootId,
                                'BEObject.object_type_id' => array(
                                    Configure::read('objectTypes.area.id'),
                                    Configure::read('objectTypes.section.id')
                                )
                            )
                        )
                    )
                )
            ) {
            $this->trackInfo('Error during root search, for rootId ' . $rootId);
            return;
        }

        if (empty($o)) {
            $this->trackInfo('Area or publication with id ' . $rootId . ' not found');
        }

        // TODO: fill object arrays, ecc.
        // 'tree' / 'objects' / 'relations'

        // 2. do export
        $objects = array(
            0 => $o
        );
        $beFormat = ClassRegistry::init('BEFormat');
        $result = $beFormat->export($objects, $this->options['export']);

        // 3. save data to file
        // TODO: implement

        // 4. end
        $this->trackInfo('');
        $this->trackInfo('::: export end :::');
    }

    public function help() {
        $this->hr();
        $this->out('format script shell usage:');
        $this->out('');
        $this->out('./cake.sh format import -f <filename> [-v]');
        $this->out('./cake.sh format export -rootId <rootId> -f <filename> [-v]');
        $this->out('');
    }

    public function test() {
        $allRelations = BeLib::getObject('BeConfigure')->mergeAllRelations();
        debug($allRelations);

    }

    private function trackInfo($s, $param = null) {
        $this->out($s);
        if($param != null) {
            pr($param);
            $this->hr();
        }
        $this->hr();
    }

    // private function viewResult($result, $logLevel) {
    //  $this->trackInfo( '::: result :::' );
    //  debug($result['log']);exit;
    //  foreach ($result['log'] as $key => $log) {
    //      debug($this->logLevels[$key]);
    //      if (array_key_exists($key,$this->logLevels) && $this->logLevels[$key] <= $logLevel) {
    //          $this->hr();
    //          $this->out($key);
    //          $this->hr();
    //          foreach ($log as $msg) {
    //              $this->out($msg);
    //          }
    //      }
    //      $this->hr();
    //  }
    // }
}
?>