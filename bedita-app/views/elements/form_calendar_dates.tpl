{$html->css("jquery.timepicker.css")}
{$html->script("jquery/jquery.placement.below")}
{$html->script("jquery/jquery.timepicker-list")}

<style scoped>

.daterow > .dateadd {
	display:none;
}

.daterow:first-child > .dateadd {
	display:inline;
}

</style>

<script type="text/javascript">
$(document).ready(function(){
	$(".timeStart, .timeEnd").timePicker({ startTime: "00:00", endTime: "23:30"});

		$(".dateremove").click(function (){
			var row = $(this).parent(".daterow");
			$(row).remove();
		});

		$(".dateadd").click(function (){
			var row = $(this).parent(".daterow");
			$(row).clone(true).insertBefore(row).addClass("newdaterow");
			$(".newdaterow input").attr("value","");
		});

});

</script>

<div class="tab"><h2>{t}Event calendar{/t}</h2></div>
<fieldset id="eventDates">

{foreach name=dd from=$object.DateItem|@sortby:'start_date' item=d key=key}
<div class="daterow">
	<label>{t}start{/t}:</label>
	<input size=10 type="text" id="eventStart" class="dateinput" name="data[DateItem][{$key}][start_date]" 
	value="{if !empty($d.start_date)}{$d.start_date|date_format:$conf->datePattern}{/if}"/>
	<input size=5 type="text"  id="timeStart"  class="timeStart" name="data[DateItem][{$key}][timeStart]" 
	value="{if !empty($d.start_date)}{$d.start_date|date_format:'%H:%M'}{/if}" />
	
	<label>{t}end{/t}:</label>
	{strip}
	<input size=10 type="text" id="eventEnd" class="dateinput" name="data[DateItem][{$key}][end_date]" 
	value="{if !empty($d.end_date)}{$d.end_date|date_format:$conf->datePattern}{/if}"/>
	{/strip}
	<input size=5 type="text"  id="timeEnd"  class="timeEnd" name="data[DateItem][{$key}][timeEnd]" 
	value="{if !empty($d.end_date)}{$d.end_date|date_format:'%H:%M'}{/if}" />

		<a href="javascript:void(0)" class="BEbutton dateremove">X</a>
		<a href="javascript:void(0)" class="BEbutton dateadd">+</a>
</div>
{/foreach}
</fieldset>

{dump var=$object.DateItem|sortby:'start_date'}

