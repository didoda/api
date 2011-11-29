{*
Template incluso.
Menu a SX valido per tutte le pagine del controller.
*}

<div class="primacolonna">
	
	<div class="modules"><label class="bedita" rel="{$html->url('/')}">{$conf->projectName|default:$conf->userVersion}</label></div>
		
	
	<ul class="menuleft insidecol">
		<li {if $view->action eq 'systemInfo'}class="on"{/if}>{$tr->link('System Info', '/admin/systemInfo')}</li>						
		<li {if $view->action eq 'systemEvents'}class="on"{/if}>{$tr->link('System Events', '/admin/systemEvents')}</li>
	</ul>

	<ul class="menuleft insidecol">
		<li {if $view->action eq 'viewConfig'}class="on"{/if}>{$tr->link('Configuration', '/admin/viewConfig')}</li>
	</ul>

	<ul class="menuleft insidecol">
		<li {if $view->action eq 'customproperties'}class="on"{/if}>{$tr->link('Custom properties', '/admin/customproperties')}</li>
		<li {if $view->action eq 'customrelations'}class="on"{/if}>{$tr->link('Custom relations', '/admin/relations')}</li>
	</ul>
		
	<ul class="menuleft insidecol">
		<li {if $view->action eq 'pluginModules'}class="on"{/if}>{$tr->link('Plugin Modules', '/admin/pluginModules')}</li>												
		<li {if $view->action eq 'addons'}class="on"{/if}>{$tr->link('Addons', '/admin/addons')}</li>												
	</ul>


	{$view->element('user_module_perms')}

</div>