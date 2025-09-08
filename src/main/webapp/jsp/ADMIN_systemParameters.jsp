<%@page import="java.util.*"%>

<%@page import="datatype.*"%>
<%@page import="servlet.*"%>
<%@page import="util.*"%>

<link href="base.css" rel="stylesheet" type="text/css">

<table style='width: 100%; border-collapse: collapse;' border='1'>
	<tr>
		<th align='center' style='white-space: nowrap'>show</th>
		<th align='center' style='white-space: nowrap'>paramName</th>
		<th align='center' style='white-space: nowrap'>paramValue</th>
	</tr>
	<%
	RegistrationServlet servlet = RegistrationServlet.getInstance(config);
	ServletDAO servletDAO = servlet.getServletDAO();

	Map<String, EnumMap<ServletDAO.SystemParameter, String>> systemParameters = servlet.getSystemParameters();
	for (String show : systemParameters.keySet()) {
		EnumMap<ServletDAO.SystemParameter, String> showParams = systemParameters.get(show);
		for (ServletDAO.SystemParameter param : showParams.keySet()) {
			String paramValue = showParams.get(param);
	%>
	<tr>
		<td align='center' style='white-space: nowrap'><%=show%></td>
		<td align='center' style='white-space: nowrap'><%=param.name()%></td>
		<td align='center' style='white-space: nowrap'><%=paramValue%></td>
	</tr>
	<%
	}
	}
	%>

</table>