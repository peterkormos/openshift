<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@page import="servlet.*"%>

<%
	String fileName = request.getParameter("fileName");
	
	session.setAttribute(RegistrationServlet.SessionAttribute.MainPageFile.name(), fileName); 
	response.sendRedirect(fileName);
%>