<table style="box-shadow: none; border-collapse: collapse;" border="1">
	<tr>
		<th style="background: none">Kateg&oacute;riacsoport</th>
		<td><a href="addCategoryGroup.jsp">&uacute;j
				hozz&aacute;ad&aacute;sa</a></td>
		<td></td>
		<td><a href="../RegistrationServlet/inputForDeleteCategoryGroup">
				t&ouml;rl&eacute;se</a></td>
		<td><a href="../RegistrationServlet/inputForDeleteCategoryGroup">
				list&aacute;z&aacute;sa</a></td>
	</tr>
	<tr>
		<th style="background: none">Kateg&oacute;ria</th>
		<td><a href="../RegistrationServlet/inputForAddCategory">&uacute;j
				hozz&aacute;ad&aacute;sa</a></td>
		<td><a href="../RegistrationServlet/listCategories">
				m&oacute;dos&iacute;t&aacute;s</a></td>
		<td><a href="../RegistrationServlet/listCategories">t&ouml;rl&eacute;se</a></td>
		<td><a href="../RegistrationServlet/listCategories">list&aacute;z&aacute;sa</a></td>
	</tr>

	<tr>
		<th style="background: none"></th>
		<form accept-charset="UTF-8" action="../RegistrationServlet"
			method="post" enctype="multipart/form-data" name="input">
			<input type="hidden" name="command" value="importData">
			<td>Legal&aacute;bb egy kateg&oacute;riacsoport felvitele
				ut&aacute;n!<br> <input type="submit"
				value="Excelb&#337;l kateg&oacute;ri&aacute;k import&aacute;l&aacute;sa">
			</td>
			<td><input type="file" name="categoryFile"></td>
			<td colspan="2">Excel t&aacute;bl&aacute;ban: <br> 1.
				oszlop: kateg&oacute;ria csoport <br> 2. oszlop:
				kateg&oacute;ria k&oacute;d (regexp: ".*\d") <br> 3. oszlop:
				kateg&oacute;ria le&iacute;r&aacute;s <br> 4. oszlop: mester
				besorol�s(?)<br> 5. oszlop: Szak&aacute;g <br> 6. oszlop:
				Korcsoport <br>
			</td>
		</form>
	</tr>
</table>