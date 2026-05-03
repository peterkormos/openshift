<%@page import="servlet.*"%>

<%
RegistrationServlet servlet = RegistrationServlet.getInstance(config);
%>

	<tr>
		<th>Kateg&oacute;riacsoport</th>
		<td><a href="addCategoryGroup.jsp">&uacute;j
				hozz&aacute;ad&aacute;sa</a></td>
		<td></td>
		<td><a href="../RegistrationServlet/inputForDeleteCategoryGroup">
				t&ouml;rl&eacute;se</a></td>
		<td><a href="../RegistrationServlet/inputForDeleteCategoryGroup">
				list&aacute;z&aacute;sa</a></td>
	</tr>
	<tr>
		<th>Kateg&oacute;ria</th>
		<td><a href="../RegistrationServlet/inputForAddCategory">&uacute;j
				hozz&aacute;ad&aacute;sa</a></td>
		<td><a href="../RegistrationServlet/listCategories">
				m&oacute;dos&iacute;t&aacute;s</a></td>
		<td><a href="../RegistrationServlet/listCategories">t&ouml;rl&eacute;se</a></td>
		<td><a href="../RegistrationServlet/listCategories">list&aacute;z&aacute;sa</a></td>
	</tr>
	<tr>
		<th>Max. makettek kateg&oacute;ri&aacute;nk&eacute;nt</th>
		<td><input
			onClick="document.getElementById('paramName').value='<%=RegistrationServlet.SystemParameter.MaxModelsPerCategory.name()%>';document.getElementById('command4').value='setSystemParameter';document.getElementById('paramValue').value=document.getElementById('maxModelsPerCategoryParam').value;document.getElementById('input4').submit();"
			type="number" id="maxModelsPerCategoryParam" size="2"
			value="<%=servlet.getMaxModelsPerCategory(request)%>"></td>
	</tr>
	<tr>
		<th>Import</th>
		<td>Legal&aacute;bb egy kateg&oacute;riacsoport felvitele
			ut&aacute;n!<br> <input type="submit"
			onClick="document.getElementById('command4').value='importData';document.getElementById('input4').enctype='multipart/form-data';"
			value="Excelb&#337;l kateg&oacute;ri&aacute;k import&aacute;l&aacute;sa">
			
			<a href="#"
				onClick="document.getElementById('command4').value='importData';document.getElementById('input4').enctype='multipart/form-data';document.getElementById('input4').submit();">Submit</a>
		</td>
		<td><input type="file" name="categoryFile"></td>
		<td colspan="2">Excel t&aacute;bl&aacute;ban: <br> 1.
			oszlop: kateg&oacute;ria csoport <br> 2. oszlop:
			kateg&oacute;ria k&oacute;d (regexp: ".*\d") <br> 3. oszlop:
			kateg&oacute;ria le&iacute;r&aacute;s <br> 4. oszlop: mester
			besorolás(?)<br> 5. oszlop: Szak&aacute;g <br> 6. oszlop:
			Korcsoport <br>
		</td>
	</tr>
	<tr>
		<th>Export</th>
		<td><a href="../RegistrationServlet/exportCategoryExcel"><strong>&Ouml;sszes
					kateg&oacute;ria Excelbe</strong></a></td>
	</tr>
