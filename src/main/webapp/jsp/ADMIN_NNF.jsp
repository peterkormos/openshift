<style>
/* Hide all steps by default: */
.tab {
	display: none;
}

button {
	background-color: #04AA6D;
	color: #ffffff;
	border: none;
	padding: 10px 20px;
	font-size: 17px;
	font-family: Raleway;
	cursor: pointer;
}

button:hover {
	opacity: 0.8;
}

#prevBtn {
	background-color: #bbbbbb;
}

/* Make circles that indicate the steps of the form: */
.step {
	height: 15px;
	width: 15px;
	margin: 0 2px;
	background-color: #bbbbbb;
	border: none;
	border-radius: 50%;
	display: inline-block;
	opacity: 0.5;
}

.step.active {
	opacity: 1;
}

/* Mark the steps that are finished and valid: */
.step.finish {
	background-color: #04AA6D;
}
</style>
<tr>
	<th colspan="5">El&otilde;nevez&eacute;s</th>
</tr>
			<tr>
				<td colspan="5">
	<table style="box-shadow: none; border: 0px;">

		<!-- Circles which indicates the steps of the form: -->
		<div style="text-align: center; margin-top: 40px;">
			<span class="step" onclick="updateTabs(0);"></span> 
			<span class="step" onclick="updateTabs(1);"></span> 
			<span class="step" onclick="updateTabs(2);"></span> 
			<span class="step" onclick="updateTabs(3);"></span>
		</div>
		<div style="overflow: auto;">
			<div style="float: left;">
				<button type="button" id="nextBtn" onclick="nextPrev(1)">&rarr;</button>
				<button type="button" id="prevBtn" onclick="nextPrev(-1)">&larr;</button>
			</div>
		</div>
		<p>
		<!-- One "tab" for each step in the form: -->
		<tbody class="tab">
			<jsp:include page="ADMIN_kategoria.jsp" />
		</tbody>
		<tbody class="tab">
			<jsp:include page="ADMIN_uzenet.jsp" />
		</tbody>
		<tbody class="tab">
			<jsp:include page="ADMIN_nyomtatas.jsp" />
		</tbody>
		<tbody class="tab">
			<jsp:include page="ADMIN_elonevezes.jsp" />
		</tbody>
	</table>
</td>
			</tr>

<script>
	var steps = document.getElementsByClassName("step");
	var tabs = document.getElementsByClassName("tab");

	var currentTab = 0; // Current tab is set to be the first tab (0)
	showTab(currentTab); // Display the current tab

	function showTab(n) {
		tabs[n].style.display = "block";
		document.getElementById("prevBtn").style.display = n == 0 ? "none"
				: "inline";
		document.getElementById("nextBtn").style.display = n == (tabs.length - 1) ? "none"
				: "inline";
	}

	function nextPrev(n) {
		updateTabs(currentTab + n);
	}
	
	function updateTabs(newTabValue) {
		steps[currentTab].className = "step finish";
		tabs[currentTab].style.display = "none";

		currentTab = newTabValue;

		steps[currentTab].className += " active";
		showTab(currentTab);
	}
</script>
