<%@page import="javax.servlet.jsp.*"%>
<%@page import="java.io.*"%>
<%@page import="java.util.*"%>

<%@page import="datatype.*"%>
<%@page import="servlet.*"%>
<%@page import="util.*"%>

<%!boolean highlightFlag;
	long highlightStart = 0xEAEAEA;

	public final String highlight() {
		return highlight(false);
	}

	public final String highlight(boolean alert) {
		try {
			if (alert) {
				return Long.toHexString(0xfc8981); //red
			}

			if (highlightFlag)
				return Long.toHexString(highlightStart);
			else {
				return Long.toHexString(Math.min(highlightStart + 0xF6F4F0, 0xffffff));
			}
		} finally {
			highlightFlag = !highlightFlag;
		}
	}

	public void addAdminLink(HttpSession session, JspWriter out, String link, String linkText) throws IOException {
		if (RegistrationServlet.isAdminSession(session)) {
			out.print("<a href='" + link + "'>");
			out.print(linkText);
			out.print("</a>");
		} else {
			out.print("<span class='flash ERROR'>Admin login ut&aacute;n &eacute;rhet&#337; el a link:</span> ");
			out.print(linkText);
		}
	}%>