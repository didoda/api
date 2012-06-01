<script type="text/javascript">
var unplugMessage = "{t}Disable object type will delete all related items. Do you want continue?{/t}";

{literal}
$(document).ready(function() {

	$("#addonsOn input[type=button]").click(function() {
		if ($(this).hasClass("js-unplug-objecttype")) {
			if (confirm(unplugMessage)) {
				$(this).closest('tr').find('form').submit();
			}
		} else {
			$(this).closest('tr').find('form').submit();
		}
	});
	
})
</script>
{/literal}

{$view->element('modulesmenu')}

{include file="inc/menuleft.tpl"}

{include file="inc/menucommands.tpl" fixed=true}

<div class="mainfull">
	
	<div class="tab stayopen"><h2>{t}BEdita Object Type{/t}</h2></div>
	
	<fieldset>
	
	<table class="indexlist" style="float:left; width:49%; margin-right:10px;">
		<tr><th colspan=2>{t}BEdita object type model enabled{/t}</th></tr>

		{if !empty($addons.models.objectTypes.on)}
			<tbody id="addonsOn">
			{foreach from=$addons.models.objectTypes.on item="ot"}
				<tr>
					<td>
					<form action="{$html->url('/admin/disableAddon')}" method="post">
					<input type="hidden" name="path" value="{$ot.path}">
					<input type="hidden" name="enabledPath" value="{$ot.enabledPath}">
					<input type="hidden" name="name" value="{$ot.name}">
					<input type="hidden" name="file" value="{$ot.file}">
					<input type="hidden" name="objectType" value="{$ot.objectType}">
					<input type="hidden" name="type" value="models">
					{$ot.name}
					</form>
					</td>
					<td>
					<input type="button" class="js-unplug-objecttype" value="{t}set OFF{/t}"/> 
					</td>
				</tr>
			{/foreach}
			</tbody>
		{else}
			<tr><td>{t}no items{/t}</td></tr>
		{/if}
	</table>
	
	<table class="indexlist" style="float:left; width:49%">
		<tr><th colspan=2>{t}BEdita object type model disabled{/t}</th></tr>

		{if !empty($addons.models.objectTypes.off)}
			<tbody>
			{foreach from=$addons.models.objectTypes.off item="ot"}
				<tr>
					{if $ot.fileNameUsed}
						<td style="color: red;">{$ot.file}:</td><td style="color: red;">{t}file is already used, please change it to avoid malfunctioning{/t}</td>
					{else}
					<form action="{$html->url('/admin/enableAddon')}" method="post">
						<td>
						<input type="hidden" name="path" value="{$ot.path}">
						<input type="hidden" name="enabledPath" value="{$ot.enabledPath}">
						<input type="hidden" name="name" value="{$ot.name}">
						<input type="hidden" name="file" value="{$ot.file}">
						<input type="hidden" name="objectType" value="{$ot.objectType}">
						<input type="hidden" name="type" value="models">
						{$ot.name}
						</td>
						<td>
						<input type="submit" value="{t}set ON{/t}"/>
						</td>
					</form>
					{/if}
				</tr>
			{/foreach}
			</tbody>
		{else}
			<tr><td>{t}no items{/t}</td></tr>
		{/if}
	</table>
	</fieldset>

	
	<div class="tab stayopen"><h2>{t}Other Models{/t}</h2></div>
	<fieldset>
		
	<table class="indexlist" style="float:left; width:49%; margin-right:10px;">
		<tr><th colspan=2>{t}Model enabled{/t}</th></tr>

		{if !empty($addons.models.others.on)}
			<tbody id="addonsOn">
			{foreach from=$addons.models.others.on item="a"}
				<tr>
					<td>
					<form action="{$html->url('/admin/disableAddon')}" method="post">
					<input type="hidden" name="path" value="{$a.path}">
					<input type="hidden" name="enabledPath" value="{$a.enabledPath}">
					<input type="hidden" name="name" value="{$a.name}">
					<input type="hidden" name="file" value="{$a.file}">
					<input type="hidden" name="type" value="models">
					{$a.name}
					</form>
					</td>
					<td>
					<input type="button" value="{t}set OFF{/t}"/> 
					</td>
				</tr>
			{/foreach}
			</tbody>
		{else}
			<tr><td>{t}no items{/t}</td></tr>
		{/if}
	</table>
	
	<table class="indexlist" style="float:left; width:49%">
		<tr><th colspan=2>{t}Model disabled{/t}</th></tr>

		{if !empty($addons.models.others.off)}
			<tbody>
			{foreach from=$addons.models.others.off item="a"}
				<tr>
					{if $ot.fileNameUsed}
						<td style="color: red;">{$a.file}:</td><td style="color: red;">{t}file is already used, please change it to avoid malfunctioning{/t}</td>
					{else}
					<form action="{$html->url('/admin/enableAddon')}" method="post">
						<td>
						<input type="hidden" name="path" value="{$a.path}">
						<input type="hidden" name="enabledPath" value="{$a.enabledPath}">
						<input type="hidden" name="name" value="{$a.name}">
						<input type="hidden" name="file" value="{$a.file}">
						<input type="hidden" name="type" value="models">
						{$a.name}{*<br/>
						path: {$a.path}*}
						</td>
						<td>
						<input type="submit" value="{t}set ON{/t}"/>
						</td>
					</form>
					{/if}
				</tr>
			{/foreach}
			</tbody>
		{else}
			<tr><td>{t}no items{/t}</td></tr>
		{/if}
	</table>
	</fieldset>

	
	<div class="tab stayopen"><h2>{t}Behaviors{/t}</h2></div>
	<fieldset>
		
	<table class="indexlist" style="float:left; width:49%; margin-right:10px;">
		<tr><th colspan=2>{t}Behaviors enabled{/t}</th></tr>

		{if !empty($addons.behaviors.others.on)}
			<tbody id="addonsOn">
			{foreach from=$addons.behaviors.others.on item="a"}
				<tr>
					<td>
					<form action="{$html->url('/admin/disableAddon')}" method="post">
					<input type="hidden" name="path" value="{$a.path}">
					<input type="hidden" name="enabledPath" value="{$a.enabledPath}">
					<input type="hidden" name="name" value="{$a.name}">
					<input type="hidden" name="file" value="{$a.file}">
					<input type="hidden" name="type" value="behaviors">
					{$a.name}
					</form>
					</td>
					<td>
					<input type="button" value="{t}set OFF{/t}"/> 
					</td>
				</tr>
			{/foreach}
			</tbody>
		{else}
			<tr><td>{t}no items{/t}</td></tr>
		{/if}
	</table>
	
	<table class="indexlist" style="float:left; width:49%">
		<tr><th colspan=2>{t}Behaviors disabled{/t}</th></tr>

		{if !empty($addons.behaviors.others.off)}
			<tbody>
			{foreach from=$addons.behaviors.others.off item="a"}
				<tr>
					{if $ot.fileNameUsed}
						<td style="color: red;">{$a.file}:</td><td style="color: red;">{t}file is already used, please change it to avoid malfunctioning{/t}</td>
					{else}
					<form action="{$html->url('/admin/enableAddon')}" method="post">
						<td>
						<input type="hidden" name="path" value="{$a.path}">
						<input type="hidden" name="enabledPath" value="{$a.enabledPath}">
						<input type="hidden" name="name" value="{$a.name}">
						<input type="hidden" name="file" value="{$a.file}">
						<input type="hidden" name="type" value="behaviors">
						{$a.name}{*<br/>
						path: {$a.path}*}
						</td>
						<td>
						<input type="submit" value="{t}set ON{/t}"/>
						</td>
					</form>
					{/if}
				</tr>
			{/foreach}
			</tbody>
		{else}
			<tr><td>{t}no items{/t}</td></tr>
		{/if}
	</table>
	</fieldset>

	<div class="tab stayopen"><h2>{t}Components{/t}</h2></div>
	<fieldset>
		
	<table class="indexlist" style="float:left; width:49%; margin-right:10px;">
		<tr><th colspan=2>{t}Components enabled{/t}</th></tr>

		{if !empty($addons.components.on)}
			<tbody id="addonsOn">
			{foreach from=$addons.components.on item="a"}
				<tr>
					<td>
					<form action="{$html->url('/admin/disableAddon')}" method="post">
					<input type="hidden" name="path" value="{$a.path}">
					<input type="hidden" name="enabledPath" value="{$a.enabledPath}">
					<input type="hidden" name="name" value="{$a.name}">
					<input type="hidden" name="file" value="{$a.file}">
					<input type="hidden" name="type" value="components">
					{$a.name}
					</form>
					</td>
					<td>
					<input type="button" value="{t}set OFF{/t}"/> 
					</td>
				</tr>
			{/foreach}
			</tbody>
		{else}
			<tr><td>{t}no items{/t}</td></tr>
		{/if}
	</table>
	
	<table class="indexlist" style="float:left; width:49%">
		<tr><th colspan=2>{t}Components disabled{/t}</th></tr>

		{if !empty($addons.components.off)}
			<tbody>
			{foreach from=$addons.components.off item="a"}
				<tr>
					{if $ot.fileNameUsed}
						<td style="color: red;">{$a.file}:</td><td style="color: red;">{t}file is already used, please change it to avoid malfunctioning{/t}</td>
					{else}
					<form action="{$html->url('/admin/enableAddon')}" method="post">
						<td>
						<input type="hidden" name="path" value="{$a.path}">
						<input type="hidden" name="enabledPath" value="{$a.enabledPath}">
						<input type="hidden" name="name" value="{$a.name}">
						<input type="hidden" name="file" value="{$a.file}">
						<input type="hidden" name="type" value="components">
						{$a.name}{*<br/>
						path: {$a.path}*}
						</td>
						<td>
						<input type="submit" value="{t}set ON{/t}"/>
						</td>
					</form>
					{/if}
				</tr>
			{/foreach}
			</tbody>
		{else}
			<tr><td>{t}no items{/t}</td></tr>
		{/if}
	</table>
	</fieldset>
		
	<div class="tab stayopen"><h2>{t}Helpers{/t}</h2></div>
	<fieldset>
	<table class="indexlist" style="float:left; width:49%; margin-right:10px;">
		<tr><th colspan=2>{t}Helpers enabled{/t}</th></tr>

		{if !empty($addons.helpers.on)}
			<tbody id="addonsOn">
			{foreach from=$addons.helpers.on item="a"}
				<tr>
					<td>
					<form action="{$html->url('/admin/disableAddon')}" method="post">
					<input type="hidden" name="path" value="{$a.path}">
					<input type="hidden" name="enabledPath" value="{$a.enabledPath}">
					<input type="hidden" name="name" value="{$a.name}">
					<input type="hidden" name="file" value="{$a.file}">
					<input type="hidden" name="type" value="helpers">
					{$a.name}
					</form>
					</td>
					<td>
					<input type="button" value="{t}set OFF{/t}"/> 
					</td>
				</tr>
			{/foreach}
			</tbody>
		{else}
			<tr><td>{t}no items{/t}</td></tr>
		{/if}
	</table>
	
	<table class="indexlist" style="float:left; width:49%">
		<tr><th colspan=2>{t}Helpers disabled{/t}</th></tr>

		{if !empty($addons.helpers.off)}
			<tbody>
			{foreach from=$addons.components.off item="a"}
				<tr>
					{if $ot.fileNameUsed}
						<td style="color: red;">{$a.file}:</td><td style="color: red;">{t}file is already used, please change it to avoid malfunctioning{/t}</td>
					{else}
					<form action="{$html->url('/admin/enableAddon')}" method="post">
						<td>
						<input type="hidden" name="path" value="{$a.path}">
						<input type="hidden" name="enabledPath" value="{$a.enabledPath}">
						<input type="hidden" name="name" value="{$a.name}">
						<input type="hidden" name="file" value="{$a.file}">
						<input type="hidden" name="type" value="helpers">
						{$a.name}{*<br/>
						path: {$a.path}*}
						</td>
						<td>
						<input type="submit" value="{t}set ON{/t}"/>
						</td>
					</form>
					{/if}
				</tr>
			{/foreach}
			</tbody>
		{else}
			<tr><td>{t}no items{/t}</td></tr>
		{/if}
	</table>
	</fieldset>
	
</div>