<%@page import="java.util.*"%>

<%@page import="datatype.*"%>
<%@page import="servlet.*"%>
<%@page import="util.*"%>

<%
    RegistrationServlet servlet = RegistrationServlet.getInstance(config);
  ServletDAO servletDAO = servlet.getServletDAO();

  final int rows = Integer.parseInt(ServletUtil.getRequestAttribute(request, "rows"));

  final List<Model> models = new LinkedList<Model>();
  for (int i = 1; i <= rows; i++)
  {
		final String httpParameterPostTag = String.valueOf(i);

		final String modelID = ServletUtil.getOptionalRequestAttribute(request, "modelID" + httpParameterPostTag).trim();
		if (modelID.length() == 0 || ServletUtil.ATTRIBUTE_NOT_FOUND_VALUE.equals(modelID))
		{
		  continue;
		}

		final AwardedModel model = new AwardedModel(servletDAO.getModel(Integer.parseInt(modelID)),
				ServletUtil.getRequestAttribute(request, "award" + httpParameterPostTag).trim()
				);
		models.add(model);
  }

  session.setAttribute(RegistrationServlet.SessionAttribute.Models.name(), models);
%>

<jsp:include page="listModels.jsp"></jsp:include>

<%
    session.removeAttribute(RegistrationServlet.SessionAttribute.Models.name());
%>