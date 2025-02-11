<table style="box-shadow: none; border-collapse: collapse;" border="1">
	<tr>
		<th style="background:none">Kateg&oacute;riacsoport</th>
		<td><a href="addCategoryGroup.jsp">&uacute;j hozz&aacute;ad&aacute;sa</a></td>
		<td></td>
		<td><a href="../RegistrationServlet/inputForDeleteCategoryGroup">
				t&ouml;rl&eacute;se</a></td>
		<td><a href="../RegistrationServlet/inputForDeleteCategoryGroup">
				list&aacute;z&aacute;sa</a></td>
	</tr>
	<tr>
		<th style="background:none">Kateg&oacute;ria</th>
		<td><a href="../RegistrationServlet/inputForAddCategory">&uacute;j
				hozz&aacute;ad&aacute;sa</a></td>
		<td><a href="../RegistrationServlet/inputForModifyCategory">
				m&oacute;dos&iacute;t&aacute;s</a></td>
		<td><a href="../RegistrationServlet/inputForDeleteCategory">t&ouml;rl&eacute;se</a></td>
		<td><a href="../RegistrationServlet/listCategories">list&aacute;z&aacute;sa</a></td>
	</tr>

	<tr>
		<th style="background:none"></th>
		<form accept-charset="UTF-8" action="../RegistrationServlet"
			method="post" enctype="multipart/form-data" name="input">
			<input type="hidden" name="command" value="importData">
			<td>Legal&aacute;bb egy kateg&oacute;riacsoport felvitele ut&aacute;n!<br>
			 <input type="submit"
				value="Excelb&#337;l kateg&oacute;ri&aacute;k import&aacute;l&aacute;sa"></td>
			<td><input type="file" name="categoryFile"></td>
			<td colspan="2">Excel t&aacute;bl&aacute;ban: <br> Els&#337; oszlop:
				kateg&oacute;ria k&oacute;d (regexp: ".*\d") <br>
				M&aacute;sodik oszlop: kateg&oacute;ria le&iacute;r&aacute;s
				(magyar) <br> Harmadik oszlop (opcion&aacute;lis): kateg&oacute;ria
				le&iacute;r&aacute;s (angol)
			</td>
		</form>
	</tr>
</table>