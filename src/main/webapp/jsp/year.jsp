<div class="input-caption-container">
	<select name="yearofbirth" id="yearofbirth"
		onchange="updateMandatoryFieldMark(this);">
		<option value="<%=request.getParameter("selectValue")%>" selected><%=request.getParameter("selectLabel")%></option>
		<%
		int currentYear = java.time.LocalDate.now().getYear();
		for (int i = currentYear - 4; i > currentYear - 100; i--) {
		%>
		<option value='<%=i%>'><%=i%></option>
		<%
		}
		%>
	</select> <label for="yearofbirth" class="input-caption"><%=request.getParameter("label")%></label>
	<font color="#FF0000" size="+3">&#8226;</font>
</div>
