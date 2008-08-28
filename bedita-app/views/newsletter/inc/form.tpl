{*
** newsletter form template
*}


{include file="../common_inc/form_common_js.tpl"}


<form action="{$html->url('/newsletter/save')}" method="post" name="updateForm" id="updateForm" class="cmxform">
<input type="hidden" name="data[id]" value="{$object.id|default:''}"/>

	{include file="../common_inc/form_title_subtitle.tpl"}

	{include file="../common_inc/form_properties.tpl" doctype=false comments=true}
	
	{include file="../common_inc/form_long_desc_lang.tpl"}	

	
	{include file="../common_inc/form_translations.tpl"}
	
	
	{include file="../common_inc/form_advanced_properties.tpl" el=$object}
	
	{include file="../common_inc/form_custom_properties.tpl" el=$object}
	
	{include file="../common_inc/form_permissions.tpl" el=$object recursion=true}
	

</form>
	


