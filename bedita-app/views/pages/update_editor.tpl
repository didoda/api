{if $editors|@count > 1}

{$javascript->link("jquery/jquery.tooltip.min")}
		
{literal}

<script type="text/javascript">
	$(".secondacolonna .modules label:not(.concurrentuser)")
	.addClass("concurrentuser")
	.attr("title","Warning! More users are editing this document")
	.tooltip({
		extraClass: "tip",
		fixPNG: true,
		top: 10,
  		left: -90

	});
</script>	

{/literal}


{t}Concurrent editors:{/t}

<img src="{$html->url('/')}img/iconConcurrentuser.png" style="float:left; vertical-align:middle; width:20px; margin-right:10px;" />

<ul id="editorsList">
{foreach from=$editors name=i item=item}
	<li rel="{$item.User.id}">
		<b>{$item.User.realname}</b>
	</li>
{/foreach}
</ul>
{/if}