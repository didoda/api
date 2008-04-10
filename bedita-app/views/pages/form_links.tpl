<script type="text/javascript">
<!--

var urlBaseAddItem = "{$addLinkUrl}";

{literal}

function setup_drag_drop_item_link(el) {
	if(!$(el)) return;
	$(el).Draggable({
		revert:		true,
		ghosting:	true,
		opacity:	0.7,
		containment : 'listExistingLinks'
	});
	$(el).Droppable({
		accept:		'itemBox',
		hoverclass: 'dropOver',
		ondrop:		function(dropped) {
			if(this == dropped) return;

			// swap position of an item (to the position of the previous)
			if(this == $(dropped).prev().get(0)) {
				$(this).insertAfter($(dropped)) ;
				$("#listExistingLinks").reorderListItem();
				return ;
			// swap position of an item (to the position of the next)
			} else if(this == $(dropped).next().get(0)) {
				$(dropped).insertAfter($(this)) ;
				$("#listExistingLinks").reorderListItem();
				return ;
			}
			// If put at the beginning, insert before
			var pDropped 	= parseInt($(".priority", dropped).attr("value")) ;
			var pThis 		= parseInt($(".priority", this).attr("value")) ;
			if(pDropped > pThis) {
				$(dropped).insertBefore($(this)) ;
			} else {
				$(dropped).insertAfter($(this)) ;
			}
			$("#listExistingLinks").reorderListItem();
		}
	}) ;
}

// Get data from modal window, uploaded files and insert new object in the form
function addItem() {
	var divToFill = "#listExistingLinks";
	$("#loadingLinks").show();
	var emptyDiv = "<div><\/div>"; 
	var linkTitle=$("#linkTitle").val();
	var linkUrl=$("#linkUrl").val();
	var target=$("#linkTarget").val();
	$(emptyDiv).load(urlBaseAddItem, {'title': linkTitle, 'url':linkUrl, 'target':target }, function () {
		$(divToFill).append(this) ; 
		$(divToFill).reorderListItem();
		$(".itemBox", this).each(function() {
			setup_drag_drop_item_link(this) ;
		}) ;
		$("#loadingLinks").hide();
		$(this).find("input[@type='button']").click(function() {
			$(this).parents(".itemBox").remove();
			$(divToFill).reorderListItem();
		});
	}) ;
	
	try { $().alertSignal() ; } catch(e) {}
}


$(document).ready(function() {
	$("#addLink").click(function () {
		addItem();
	});
	$(".itemBox").each(function (index) {
		$("input[@name='index']", this).attr("value", index) ;
		$(".id", this).attr("name", "data[ObjectRelation]["+index+"][id]") ;
		$(".switch", this).attr("name", "data[ObjectRelation]["+index+"][switch]") ;
		$(".priority", this).attr("name", "data[ObjectRelation]["+index+"][priority]") ;
	}) ;
	$("#listExistingLinks .itemBox").each(function() {setup_drag_drop_item_link(this) }) ;
	$("#listExistingLinks").find("input[@type='button']").click(function() {
		$(this).parents(".itemBox").remove();
		$("#listExistingLinks").reorderListItem();
	});
	
});
{/literal}
//-->
</script>


<h2 class="showHideBlockButton">{t}Links{/t}</h2>
<div class="blockForm" id="links">
	<div id="listExistingLinks" style="min-height:100px">
	<input type="hidden" name="data[ObjectRelation]['link'][switch]" value="link" />
	{if isset($relObjects.link)}
	{foreach from=$relObjects.link item="objRelated" name="linkForeach"}
		{include file="../pages/form_link_item.tpl"}
	{/foreach}
	{/if}
	</div>
	<div id="newLink">
	<fieldset>
	{t}Title{/t}: <input type="text" name="linkTitle" id="linkTitle"/>
	{t}Url{/t}: <input type="text" name="linkUrl" id="linkUrl"/>
	{t}Type{/t}: <select name="targetType" id="linkTarget"> 
		<option value="_self">_self</option>
		<option value="_blank">_blank</option>
	</select>
	<input type="button" value="{t}Add{/t}" id="addLink"/>
	</fieldset>
	</div>
	<div id="loadingLinks" class="generalLoading" title="{t}Loading data{/t}"><span>&nbsp;</span></div>
</div>