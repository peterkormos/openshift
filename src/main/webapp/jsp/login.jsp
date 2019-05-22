<%@page import="datatype.*"%>
<%@page import="servlet.*"%>
<%@page import="util.*"%>

<%@page import="java.util.*"%>

<jsp:useBean id="languageUtil" class="util.LanguageUtil" scope="application"/>

<%
  RegistrationServlet servlet = RegistrationServlet.getInstance(config);
  ServletDAO servletDAO = servlet.getServletDAO();

  final String languageCode = ServletUtil.getRequestAttribute(request, "language");
  ResourceBundle language = languageUtil.getLanguage(languageCode);
%>

<%
	String showIdHttpParameter = request.getParameter("showId");
	final List<String> shows = servletDAO.getShows();
	
	if(showIdHttpParameter != null)
	try
	{
		shows.retainAll(Arrays.asList(shows.get(Integer.parseInt(showIdHttpParameter)-1)));
	}
	catch(Exception ex)
	{
	}
 %>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />

	<script> 
	    function checkShow(form) { 
	        if (form.email.value != 'admin' && form.show.value == '')
	        {  
				document.getElementById('noticeDiv').innerHTML = '<%=language.getString("select.show")%>';
				document.getElementById('noticeDiv').className ="flash ERROR";
				return false; 
	        } 
	        else
	        {  
				document.getElementById('noticeDiv').innerHTML = '';
				document.getElementById('noticeDiv').className ="";
				return true; 
	        } 
	    } 
	</script> 
</head>

<link rel="stylesheet" href="base.css" media="screen" />

<body>
	<form  name="input" 
	onSubmit = "return checkShow(this)"
		action="../RegistrationServlet" method="post" accept-charset="UTF-8">

		<input type="hidden" name="command" value="login">
		<input type="hidden" name="language" value="<%=languageCode%>">

		<table border="0" height="100%" width="100%">
			<tr>
				<td align="center" valign="middle">
					<table border="0">
						<tr>
							<td colspan="2"><FONT COLOR='#ffffff'>Verzi&oacute;:
									<%=servlet.getVersion()%></FONT></td>
						</tr>
						<tr>
							<td colspan="2"><FONT COLOR='#ff0000'><b><%=servlet.getSystemMessage()%></b></FONT></td>
						</tr>
						<tr bgcolor='F6F4F0'>
							<td><%=language.getString("show")%>:</td>
							<td>
								<%								  
								  for (final String show : shows)
								  {
								%> <label><input type='radio' name='show' value='<%=StringEncoder.toBase64(show.getBytes())%>'
								<%=(shows.size() == 1 ? " checked='checked'" : "")%> /> <FONT
								COLOR='#ff0000'><b> <%=show%></b></FONT></label><br> <%
   }
 %>
							</td>
						</tr>
						<tr>
							<td><FONT COLOR='#ff0000'><b><%=language.getString("email")%></b></FONT>:</td>
							<td><input type="text" name="email"></td>
						</tr>
						<tr bgcolor='F6F4F0'>
							<td><%=language.getString("password")%>:</td>
							<td><input type="password" name="password">
								<p>
									<a href="reminder.jsp?language=<%=languageCode%>"><%=language.getString("password.reminder")%></a></td>
						</tr>
						<tr>
							<td colspan="2" align="center"><input name="submit"
								type="submit" value="<%=language.getString("login")%>">
      <p>
      <div id="noticeDiv"></div>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>

	</form>
</body>
</html>

