{$html->css('module.superadmin')}
{$javascript->link("jquery.treeview.pack")}
{$javascript->link("interface")}
{$javascript->link("form")}
{$javascript->link("jquery.form")}
{$javascript->link("jquery.changealert")}
{$javascript->link("jquery.validate")}
</head>
<body>
{include file="head.tpl"}
<div id="centralPage">
	{include file="submenu.tpl" method="groups"}
	{include file="form_groups.tpl" method="groups"}
</div>