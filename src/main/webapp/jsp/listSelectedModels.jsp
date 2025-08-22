<%@page import="java.util.*"%>

<%@page import="datatype.*"%>
<%@page import="servlet.*"%>
<%@page import="util.*"%>

<%
    RegistrationServlet servlet = RegistrationServlet.getInstance(config);
  ServletDAO servletDAO = servlet.getServletDAO();

  User user = servlet.getUser(request);

  final List<Model> models = servletDAO.selectModels(request);
  if(ServletUtil.isCheckedIn(request, "filterToOversized")) {
	models.sort(new Comparator<Model>() {
		public int compare(Model m1, Model m2) {
			return Integer.compare(m1.getCategoryID(), m2.getCategoryID());
		}
	});	  
  }

  session.setAttribute(RegistrationServlet.SessionAttribute.Models.name(), models);
%>
<link href="base.css" rel="stylesheet" type="text/css">
<jsp:include page="listModels.jsp"></jsp:include>

<%
    session.removeAttribute(RegistrationServlet.SessionAttribute.Models.name());
%>