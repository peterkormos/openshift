<%@page import="java.util.*"%>

<%@page import="datatype.*"%>
<%@page import="servlet.*"%>

<%
  RegistrationServlet servlet = RegistrationServlet.getInstance(config);
  ServletDAO servletDAO = servlet.getServletDAO();

  User user = servlet.getUser(request);

  final List<Model> models = servletDAO.selectModels(request);
  
  session.setAttribute(RegistrationServlet.SessionAttributes.Models.name(), models);
%>

<jsp:include page="listModels.jsp"></jsp:include>

<%
  session.removeAttribute(RegistrationServlet.SessionAttributes.Models.name());
%>