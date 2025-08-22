<form accept-charset="UTF-8" name="input" action="../RegistrationServlet" method="post">
	<input type="hidden" name="command" id="command2">
	<input type="hidden" name="photos" value="yes">
</form>

<table style="box-shadow: none" border="0">
	<tr>
		<td><b>Adatkezel&eacute;s:</b></td>
	</tr>
	<tr>
		<td> <a href="#"
				onClick="document.getElementById('command2').value='exportData';document.getElementById('command2').parentNode.submit();">&Ouml;sszes
				adat export&aacute;l&aacute;sa</a></td>
		<td></td>
		<td> <a href="#"
				onClick="document.getElementById('command2').value='exportCategoryData';document.getElementById('command2').parentNode.submit();">Csak
				a kateg&oacute;ri&aacute;k export&aacute;l&aacute;sa</a>
			-
			<a href="../RegistrationServlet/encodeCategorGroups">Kateg&oacute;riacsoport
				k&oacute;dol&aacute;sa</a>
			-
			<a href="../RegistrationServlet/encodeCategories">Kateg&oacute;ria
				k&oacute;dol&aacute;sa</a>
			-
			<a href="../RegistrationServlet/encodeModels">Makett
				k&oacute;dol&aacute;sa</a>
		</td>
	</tr>

	<tr>
		<form accept-charset="UTF-8" action="../RegistrationServlet" method="post" enctype="multipart/form-data"
			name="input">
			<input type="hidden" name="command" value="importData">
			<td><input type="submit" value="Adatok import&aacute;l&aacute;sa"></td>
			<td><input type="file" name="zipFile"></td>
		</form>
	</tr>
</table>
<!-- 
<form accept-charset="UTF-8" name="input" action="../RegistrationServlet" method="post">
	<input type="hidden" name="command" value="exportData"> <input
		type="hidden" name="photos" value="no"> <input
		name="exportData" type="submit"
		value="&Ouml;sszes adat export&aacute;l&aacute;sa k&eacute;pek n&eacute;lk&uuml;l">
</form>
 -->