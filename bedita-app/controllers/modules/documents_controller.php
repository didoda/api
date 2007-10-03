<?php
/**
 *
 * @filesource
 * @copyright		
 * @link			
 * @package			
 * @subpackage		
 * @since			
 * @version			
 * @modifiedby		
 * @lastmodified	
 * @license			
 * @author 			giangi@qwerg.com d.domenico@channelweb.it
 */

/**
 * Short description for class.
 *
 * Controller entrata modulo Documento e gestione documenti
 * 
 */
class DocumentsController extends AppController {
	var $name = 'Documents';

	var $helpers 	= array('Bevalidation', 'BeTree');
	var $components = array('BeAuth', 'BeTree', 'Transaction', 'Permission', 'BeCustomProperty', 'BeLangText');

	// This controller does not use a model
	var $uses = array('Area', 'Section',  'BEObject', 'ContentBase', 'Content', 'BaseDocument', 'Document', 'Tree') ;

	 /**
	 * Entrata.
	 * Visualizza l'albero delle aree e l'elenco dei documenti
	 * 
	 */
	 function index($id = null, $page = 1, $dim = 20) {
		$conf  = Configure::getInstance() ;
		
	 	// Setup parametri
		$this->setup_args(
			array("id", "integer", $id),
			array("page", "integer", $page),
			array("dim", "integer", $dim)
		) ;

		// Preleva l'albero delle aree e sezioni
		$tree = $this->BeTree->expandOneBranch($id) ;
		
		$documents = $this->BeTree->getDiscendents($id, null, $conf->objectTypes['documentAll'], $page, $dim)  ;
pr($documents);
exit;		
		// Setup dei dati da passare al template
		$this->set('tree', 		$tree);
		$this->set('selfPlus',	$this->createSelfURL(false)) ;
		$this->set('self',		($this->createSelfURL(false)."?")) ;
	 }

	 /**
	  * Preleva l'area selezionata.
	  * Se non viene passato nessun id, presente il form per una nuova area
	  *
	  * @param integer $id
	  */
	 function viewArea($id = null) {
	 	
		$conf  = Configure::getInstance() ;
		
	 	// Setup parametri
		$this->setup_args(array("id", "integer", $id)) ;
	 	
		// Preleva l'area selezionata
		$area = null ;
		if($id) {
			$this->Area->bviorHideFields = array('ObjectType', 'Version', 'Index', 'current') ;
			if(!($area = $this->Area->findById($id))) {
				$this->Session->setFlash(sprintf(__("Error loading area: %d", true), $id));
				return ;		
			}
		}
		
		// Formatta i campi in lingua
		if(isset($area["LangText"])) {
			$this->BeLangText->setupForView($area["LangText"]) ;
		}
		
		// Setup dei dati da passare al template
		$this->set('area', 		$area);
		$this->set('selfPlus',	$this->createSelfURL(false, array("id", $id) )) ;
		$this->set('self',		($this->createSelfURL(false)."?")) ;
		$this->set('conf',		$conf) ;
	 }

	 /**
	  * Preleva la sezione selezionata.
	  * Se non viene passato nessun id, presenta il form per una nuova sezione
	  *
	  * @param integer $id
	  */
	 function viewSection($id = null) {	 	
		// Setup parametri
		$this->setup_args(array("id", "integer", $id)) ;
	 	
		// Preleva la sezione selezionata
		$section = null ;
		if($id) {
			$this->Section->bviorHideFields = array('ObjectType', 'Version', 'Index', 'current') ;
			if(!($section = $this->Section->findById($id))) {
				$this->Session->setFlash(sprintf(__("Error loading section: %d", true), $id));
				return ;		
			}
		}
		
		// Formatta i campi in lingua
		if(isset($section["LangText"])) {
			$this->BeLangText->setupForView($section["LangText"]) ;
		}
		
		// Preleva l'albero delle aree e sezioni
		$tree = $this->BeTree->getSectionsTree() ;

		// Preleva dov'e' inserita la sezione 
		if(isset($id)) {
			$parent_id = $this->Tree->getParent($id) ;
		} else {
			$parent_id = 0 ;
		}	


		// Setup dei dati da passare al template
		$this->set('tree', 		$tree);
		$this->set('section',	$section);
		$this->set('parent_id',	$parent_id);
		$this->set('selfPlus',	$this->createSelfURL(false, array("id", $id) )) ;
		$this->set('self',		($this->createSelfURL(false)."?")) ;	
	 }
	
	 /**
	  * Salva La nuova configurazione dell'albero dei contenuti
	  *
	  */
	 function saveTree() {
	 	try {
			$this->Transaction->begin() ;
	 		
		 	if(@empty($this->data["tree"])) throw new BEditaActionException($this, "No data");
		
		 	// Preleva l'albero
		 	$this->_getTreeFromPOST($this->data["tree"], $tree) ;

		 	// Salva i cambiamenti
		 	if(!$this->Tree->moveAll($tree)) throw new BEditaActionException($this, __("Error save tree from _POST", true));

			$this->Transaction->commit() ;
			
	 	} catch (Exception $e) {
			$this->Session->setFlash($e->getMessage());
			$this->Transaction->rollback() ;
			
			return ;
	 	}
	 }
	 
	 /**
	  * Aggiunge una nuova area o la modifica.
	  * Nei dati devono essere definiti:
	  * URLOK e URLERROR.
	  *
	  */
	 function saveArea() {	 	
	 	try {
		 	if(empty($this->data)) throw BEditaActionException($this, __("No data", true));
	 		
			$new = (empty($this->data['id'])) ? true : false ;
			
		 	// Verifica i permessi di modifica dell'oggetto
		 	if(!$new && !$this->Permission->verify($this->data['id'], $this->BeAuth->user['userid'], BEDITA_PERMS_MODIFY)) 
		 			throw new BEditaActionException($this, "Error modify permissions");
		 	
		 	// Formatta le custom properties
		 	$this->BeCustomProperty->setupForSave($this->data["CustomProperties"]) ;
	
		 	// Formatta i campi d tradurre
		 	$this->BeLangText->setupForSave($this->data["LangText"]) ;
		 	
			$this->Transaction->begin() ;
			
	 		// Salva i dati
		 	if(!$this->Area->save($this->data)) throw new BEditaActionException($this, $this->Area->validationErrors);
/*			
		 	// Inserisce nell'albero
		 	if($new) {
		 		if(!$this->Tree->appendChild($this->Area->id, null)) throw new BEditaActionException($this, __("Append Area in to tree", true));
		 	}
*/		 	
		 	// aggiorna i permessi
		 	if(!$this->Permission->saveFromPOST(
		 			$this->Area->id, 
		 			(isset($this->data["Permissions"]))?$this->data["Permissions"]:array(),
		 			(empty($this->data['recursiveApplyPermissions'])?false:true))
		 		) {
		 			throw BEditaActionException($this, __("Error saving permissions", true));
		 	}	 	
	 		$this->Transaction->commit() ;

	 	} catch (Exception $e) {
			$this->Session->setFlash($e->getMessage());
			$this->Transaction->rollback() ;
			
			return ;
	 	}
	 }
	 
	 /**
	  * Aggiunge una nuova sezione o la modifica.
	  * Nei dati devono essere definiti:
	  * URLOK e URLERROR.
	  *
	  */
	 function saveSection() {
	 	try {
		 	if(empty($this->data)) throw BEditaActionException($this,__("No data", true));
	 		
			$new = (empty($this->data['id'])) ? true : false ;
			
		 	// Verifica i permessi di modifica dell'oggetto
		 	if(!$new && !$this->Permission->verify($this->data['id'], $this->BeAuth->user['userid'], BEDITA_PERMS_MODIFY)) 
		 			throw BEditaActionException($this, __("Error modifying permissions", true));
		 	
		 	// Formatta le custom properties
		 	$this->BeCustomProperty->setupForSave($this->data["CustomProperties"]) ;
	
		 	// Formatta i campi da tradurre
		 	$this->BeLangText->setupForSave($this->data["LangText"]) ;
		 	
		 	
			$this->Transaction->begin() ;
			
	 		// Salva i dati
	 		if($new) $this->data["parent_id"] = $this->data["destination"] ;
		 	if(!$this->Section->save($this->data)) throw new BEditaActionException($this, $this->Section->validationErrors);
			
		 	// Sposta la sezione nell'albero se necessario
		 	if(!$new) {
		 		$oldParent = $this->Tree->getParent($this->Section->id) ;
		 		if($oldParent != $this->data["destination"]) {
		 			$this->Tree->move($this->data["destination"], $oldParent, $this->Section->id) ;
		 		}
		 	}
		 	
		 	// aggiorna i permessi
		 	if(!$this->Permission->saveFromPOST(
		 			$this->Section->id, 
		 			(isset($this->data["Permissions"]))?$this->data["Permissions"]:array(),
		 			(empty($this->data['recursiveApplyPermissions'])?false:true))
		 		) {
 				throw BEditaActionException($this, __("Error saving permissions", true));
		 	}	 	
	 		$this->Transaction->commit() ;

	 	} catch (Exception $e) {
			$this->Session->setFlash($e->getMessage());
			$this->Transaction->rollback() ;
			
			return ;
	 	}
	 }
	 
	 /**
	  * Cancella un'area.
	  */
	 function deleteArea($id = null) {
		$this->setup_args(array("id", "integer", $id)) ;
		
	 	try {
		 	if(empty($id)) throw BEditaActionException($this,__("No data", true));
	 		
		 	$this->Transaction->begin() ;
	 	
		 	// Cancellla i dati
		 	if(!$this->Area->delete($id)) throw new BEditaActionException($this, sprintf(__("Error deleting area: %d", true), $id));
		 	
		 	$this->Transaction->commit() ;
	 	} catch (Exception $e) {
			$this->Session->setFlash($e->getMessage());
			$this->Transaction->rollback() ;
				
			return ;
	 	}
	 	
	 }

	 /**
	  * Cancella una sezione.
	  */
	 function deleteSection($id = null) {
		$this->setup_args(array("id", "integer", $id)) ;
		
	 	try {
		 	if(empty($id)) throw new BEditaActionException($this, "No data");
	 		
		 	$this->Transaction->begin() ;
		 	
		 	// Cancellla i dati
		 	if(!$this->Section->delete($id)) throw new BEditaActionException($this, sprintf(__("Error deleting section: %d", true), $id));
		 	
		 	$this->Transaction->commit() ;
	 	} catch (Exception $e) {
			$this->Session->setFlash($e->getMessage());
			$this->Transaction->rollback() ;
				
			return ;
	 	}	
	 }

	 /**
	  * Torna un'array associativo che rappresneta l'albero aree/sezioni
	  * a partire dai dati passati via POST.
	  *
	  * @param unknown_type $data
	  * @param unknown_type $tree
	  */
	 private function _getTreeFromPOST(&$data, &$tree) {
	 	$tree = array() ;
	 	$IDs  = array() ;
	 	
	 	// Crea i diversi rami
	 	$arr = preg_split("/;/", $data) ;
	 	for($i = 0 ; $i < count($arr) ; $i++) {
	 		$item = array() ;
	 		$tmp = split(" ", $arr[$i] ) ;
	 		foreach($tmp as $val) {
	 			$t  = split("=", $val) ;
	 			$item[$t[0]] = ($t[1] == "null") ? null : ((integer)$t[1]) ; 
	 		}
	 		
	 		$IDs[$item["id"]] 				= $item ;
	 		$IDs[$item["id"]]["children"] 	= array() ;
	 	}

		// Crea l'albero
		foreach ($IDs as $id => $item) {
			if(!isset($item["parent"])) {
				$tree[] = $item ;
				$IDs[$id] = &$tree[count($tree)-1] ;
			}
			
			if(isset($IDs[$item["parent"]])) {
				$IDs[$item["parent"]]["children"][] = $item ;
				$IDs[$id] = &$IDs[$item["parent"]]["children"][count($IDs[$item["parent"]]["children"])-1] ;
			}
		}
		
		unset($IDs) ;
	 }

	 function _REDIRECT($action, $esito) {
	 	$REDIRECT = array(
	 			"saveTree"	=> 	array(
	 									"OK"	=> "./",
	 									"ERROR"	=> "./" 
	 								), 
	 			"saveArea"	=> 	array(
	 									"OK"	=> "./viewArea/{$this->Area->id}",
	 									"ERROR"	=> "./viewArea/{$this->Area->id}" 
	 								), 
	 			"saveSection"	=> 	array(
	 									"OK"	=> "./viewSection/{$this->Section->id}",
	 									"ERROR"	=> "./viewSection/{$this->Section->id}" 
	 								), 
	 			"deleteArea"	=> 	array(
	 									"OK"	=> "./",
	 									"ERROR"	=> "./viewArea/{@$this->params['pass'][0]}" 
	 								), 
	 			"deleteSection"	=> 	array(
	 									"OK"	=> "./",
	 									"ERROR"	=> "./viewSection/{@$this->params['pass'][0]}" 
	 								), 
	 		) ;
	 	
	 	if(isset($REDIRECT[$action][$esito])) return $REDIRECT[$action][$esito] ;
	 	
	 	return false ;
	 }
	 
}

	