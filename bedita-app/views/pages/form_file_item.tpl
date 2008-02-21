{if empty($obj)}{assign var="obj" value=$object}{/if}
{assign var="controller" 		value=$controller|default:multimedia}
{assign var="index" 			value=$index|default:1}
{assign var="thumbWidth" 		value=100}
{assign var="thumbHeight" 		value=100}
{assign var="thumbCache" 		value=$CACHE|default:imgcache}
{assign var="thumbPath"         value=$MEDIA_ROOT}
{assign var="thumbBaseUrl"      value=$MEDIA_URL}
{assign var="thumbLside"		value=""}
{assign var="thumbSside"		value=""}
{assign var="thumbHtml"			value=""}
{assign var="thumbDev"			value=""}
{assign var="imagePath" 		value=$obj.path}
{assign var="imageFile" 		value=$obj.filename|default:$obj.name}
{assign var="imageTitle" 		value=$obj.title}
{assign var="newPriority" 		value=$obj.priority+1|default:$priority}
<div id="m_{$obj.id}" class="itemBox">
	<input type="hidden" class="index" 	name="index" value="{$index}" />
	<input type="hidden" class="id" 	name="data[{$controller}][{$index}][id]" value="{$obj.id}" />
	<input type="text" class="priority" name="data[{$controller}][{$index}][priority]" value="{$obj.priority|default:$priority}" size="3" maxlength="3"/>
	<span class="label">{$imageFile}</span>
	{if strtolower($obj.ObjectType.name) == "image"}
	<div style="width:{$thumbWidth}px; height:{$thumbHeight}px; overflow:hidden;">
		{$imageFile} : {$obj.ObjectType.name}
		{if !empty($imageFile) && strtolower($obj.ObjectType.name) == "image"}
			{thumb 
				width="$thumbWidth" 
				height="$thumbHeight" 
				file=$thumbPath$imagePath
				cache="$thumbCache" 
				MAT_SERVER_PATH=$thumbPath 
				MAT_SERVER_NAME=$thumbBaseUrl
				linkurl="$thumbBaseUrl/$imageFile"
				longside="$thumbLside"
				shortside="$thumbSside"
				html="$thumbHtml"
				dev="$thumbDev"} 
		{else}
			{if strtolower($obj.ObjectType.name) == "image"}
			<img src="{$session->webroot}/img/image-missing.jpg" width="160"/>
			{/if}
		{/if}
	</div>
	{else}
	<div>BEObject</div>
	{/if}
	<br/>
	{t}Title{/t}:<br/>{$imageTitle|escape:'htmlall'}<br/>
	{t}Description{/t}:<br/>{$obj.short_desc|escape:'htmlall'}<br/>
	{t}Size{/t}:<br/>{$obj.size/1000} Kb<br/>
	{if !empty($imageFile) && $obj.name == "Image"}x: {$obj.width} y: {$obj.height}{/if}
	<div align="right" style="padding-top:4px; margin-top:4px; border-top:1px solid silver">
	<input type="button" onclick="removeItem('m_{$obj.id}')" value="{t}Delete{/t}" />
	</div>
</div>