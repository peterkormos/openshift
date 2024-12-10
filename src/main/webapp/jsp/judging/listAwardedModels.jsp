<%@page import="java.util.*"%>

<%@page import="datatype.*"%>
<%@page import="servlet.*"%>
<%@page import="util.*"%>

<%
RegistrationServlet servlet = RegistrationServlet.getInstance(config);
ServletDAO servletDAO = servlet.getServletDAO();

final List<Model> models = new LinkedList<Model>();

for (AwardedModel am : servletDAO.getAwardedModels()) {
	models.add(am);
}

session.setAttribute(RegistrationServlet.SessionAttribute.Models.name(), models);
%>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" href="../base.css" media="screen">
</head>
<body>
	<jsp:include page="../listModels.jsp">
		<jsp:param name="actionPathPrefix" value="../" />
		<jsp:param name="insertAwards" value="true" />
	</jsp:include>
</body>
<%
session.removeAttribute(RegistrationServlet.SessionAttribute.Models.name());
%>