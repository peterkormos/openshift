	<tr>
		<td><a href="../RegistrationServlet/exportData">&Ouml;sszes
				adat export&aacute;l&aacute;sa</a></td>
		<td><a href="../RegistrationServlet/exportCategoryData">Csak
				a kateg&oacute;ri&aacute;k export&aacute;l&aacute;sa</a></td>
	</tr>

	<tr>
		<form accept-charset="UTF-8" action="../RegistrationServlet"
			method="post" enctype="multipart/form-data" name="input">
			<input type="hidden" name="command" value="importData">
			<td><input type="submit"
				value="Adatok import&aacute;l&aacute;sa"></td>
			<td><input type="file" name="zipFile"></td>
		</form>
	</tr>
