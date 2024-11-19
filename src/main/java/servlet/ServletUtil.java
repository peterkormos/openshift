package servlet;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;
import java.util.Properties;

import javax.mail.BodyPart;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import exception.MissingRequestParameterException;
import exception.UserNotLoggedInException;

public class ServletUtil {
    public static final String ATTRIBUTE_NOT_FOUND_VALUE = "-";

    private static final Map<Integer, String> charEncodeMap;

    static {
  		charEncodeMap = new HashMap<Integer, String>();
  		charEncodeMap.put(192, "&Agrave;");
  		charEncodeMap.put(193, "&Aacute;");
  		charEncodeMap.put(194, "&Acirc;");
  		charEncodeMap.put(195, "&Atilde;");
  		charEncodeMap.put(196, "&Auml;");
  		charEncodeMap.put(197, "&Aring;");
  		charEncodeMap.put(198, "&AElig;");
  		charEncodeMap.put(199, "&Ccedil;");
  		charEncodeMap.put(200, "&Egrave;");
  		charEncodeMap.put(201, "&Eacute;");
  		charEncodeMap.put(202, "&Ecirc;");
  		charEncodeMap.put(203, "&Euml;");
  		charEncodeMap.put(204, "&Igrave;");
  		charEncodeMap.put(205, "&Iacute;");
  		charEncodeMap.put(206, "&Icirc;");
  		charEncodeMap.put(207, "&Iuml;");
  		charEncodeMap.put(208, "&ETH;");
  		charEncodeMap.put(209, "&Ntilde;");
  		charEncodeMap.put(210, "&Ograve;");
  		charEncodeMap.put(211, "&Oacute;");
  		charEncodeMap.put(212, "&#337;");
  		charEncodeMap.put(213, "&#337;");
  		charEncodeMap.put(214, "&Ouml;");
  		charEncodeMap.put(215, "&times;");
  		charEncodeMap.put(216, "&Oslash;");
  		charEncodeMap.put(217, "&Ugrave;");
  		charEncodeMap.put(218, "&Uacute;");
  		charEncodeMap.put(219, "&Ucirc;");
  		charEncodeMap.put(220, "&Uuml;");
  		charEncodeMap.put(221, "&Yacute;");
  		charEncodeMap.put(222, "&THORN;");
  		charEncodeMap.put(223, "&szlig;");
  		charEncodeMap.put(224, "&agrave;");
  		charEncodeMap.put(225, "&aacute;");
  		charEncodeMap.put(226, "&acirc;");
  		charEncodeMap.put(227, "&atilde;");
  		charEncodeMap.put(228, "&auml;");
  		charEncodeMap.put(229, "&aring;");
  		charEncodeMap.put(230, "&aelig;");
  		charEncodeMap.put(231, "&ccedil;");
  		charEncodeMap.put(232, "&egrave;");
  		charEncodeMap.put(233, "&eacute;");
  		charEncodeMap.put(234, "&ecirc;");
  		charEncodeMap.put(235, "&euml;");
  		charEncodeMap.put(236, "&igrave;");
  		charEncodeMap.put(237, "&iacute;");
  		charEncodeMap.put(238, "&icirc;");
  		charEncodeMap.put(239, "&iuml;");
  		charEncodeMap.put(240, "&eth;");
  		charEncodeMap.put(241, "&ntilde;");
  		charEncodeMap.put(242, "&ograve;");
  		charEncodeMap.put(243, "&oacute;");
  		charEncodeMap.put(244, "&#337;");
  		charEncodeMap.put(245, "&#337;");
  		charEncodeMap.put(246, "&ouml;");
  		charEncodeMap.put(247, "&divide;");
  		charEncodeMap.put(248, "&oslash;");
  		charEncodeMap.put(249, "&ugrave;");
  		charEncodeMap.put(250, "&uacute;");
  		charEncodeMap.put(251, "&#369;");
  		charEncodeMap.put(252, "&uuml;");
  		charEncodeMap.put(253, "&yacute;");
  		charEncodeMap.put(254, "&thorn;");
  		charEncodeMap.put(255, "&yuml;");
    }
    
    public static Optional<String> getOptionalAttribute(final HttpServletRequest request, final String name) {
        final String value = ServletUtil.getOptionalRequestAttribute(request, name);

        return  ATTRIBUTE_NOT_FOUND_VALUE.equals(value) ? Optional.empty() : Optional.of(value);
    }
    
    public static String getOptionalRequestAttribute(final HttpServletRequest request, final String name) {
        try {
            final String value = ServletUtil.getRequestAttribute(request, name, false);

            return "".equals(value) ? ATTRIBUTE_NOT_FOUND_VALUE : value;
        } catch (final MissingRequestParameterException e) {
            e.printStackTrace();
            return ATTRIBUTE_NOT_FOUND_VALUE;
        }
    }

    public static String getRequestAttribute(final HttpServletRequest request, final String name) throws MissingRequestParameterException {
        return getRequestAttribute(request, name, true);
    }

    public static String getRequestAttribute(final HttpServletRequest request, final String name, final boolean throwException)
            throws MissingRequestParameterException {
        String value;
        value = request.getParameter(name);
        if ((value == null) || (value.trim().length() == 0)) {
            if (throwException) {
                throw new MissingRequestParameterException(name);
            } else {
                return ATTRIBUTE_NOT_FOUND_VALUE;
            }
        }

        if (RegistrationServlet.logger.isDebugEnabled()) {
            RegistrationServlet.logger.debug("HTTP parameter: " + name + " value: " + value);
        }

        return encodeString(value.trim());
    }

    /*
     * Less secure app access
     * https://myaccount.google.com/security
     */
    public static void sendEmail(String smtpServer, final String from, String to, String subject, String htmlMessage, boolean debugSMTP,
            final String password) throws MessagingException  {
        if (from == null) {
            throw new IllegalArgumentException("!!! Utils.sendMessage(): FROM address is null!");
        }

        if (from.indexOf("@") == -1) {
            throw new IllegalArgumentException("!!! Utils.sendMessage(): invalid FROM e-mail address: " + from);
        }

        if (to == null) {
            throw new IllegalArgumentException("!!! Utils.sendMessage(): TO address is null !");
        }

        if (to.indexOf("@") == -1) {
            throw new IllegalArgumentException("!!! Utils.sendMessage(): invalid TO e-mail address: " + to);
        }

        final Properties props = new Properties();
        props.put("mail.smtp.host", smtpServer);
        props.put("mail.debug", debugSMTP);
        props.put("mail.smtp.socketFactory.port", "465");
        props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
        props.put("mail.smtp.socketFactory.fallback", "false");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.port", "465");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.EnableSSL.enable", "true");
        final Session session = Session.getDefaultInstance(props, new javax.mail.Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(from, password);
            }
        });

        final Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(from));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
        message.setSubject(subject);

        // Create a multi-part to combine the parts
        final Multipart multipart = new MimeMultipart("alternative");

        // Create your text message part
        BodyPart messageBodyPart = new MimeBodyPart();
        messageBodyPart.setText(
                "Ha ezt latod, akkor a levelezod nem jol jeleniti meg az emailt. Kerlek valaszolj a feladonak a hibaval kapcsolatban.");

        // Add the text part to the multipart
        multipart.addBodyPart(messageBodyPart);

        // Create the html part
        messageBodyPart = new MimeBodyPart();
        messageBodyPart.setContent(htmlMessage, "text/html");

        // Add html part to multi part
        multipart.addBodyPart(messageBodyPart);

        // Associate multi-part with message
        message.setContent(multipart);

        Transport.send(message);
    }

	public static Object getSessionAttribute(final HttpServletRequest request, String name) throws UserNotLoggedInException {
		final HttpSession session = request.getSession(false);

		if (session == null) {
			throw new UserNotLoggedInException("User is not logged in!");
		}

		return session.getAttribute(name);
	}

	public static void writeResponse(final HttpServletResponse response, final StringBuilder message) throws IOException {
		response.setContentType("text/html");
		response.getOutputStream().write(message.toString().getBytes());
	}

	public static boolean isCheckedIn(final HttpServletRequest request, final String parameter) {
			return "on".equalsIgnoreCase(getOptionalRequestAttribute(request, parameter));
	}
	
	public static String sanitizeUserInput(String text) {
		return text.replace(';', ' ').replace('(', ' ').replace(')', ' ').replace('\'', ' ').replace(';', ' ');
	}

  public static String encodeString(String value)
  {
	if (value == null)
	{
	  return "";
	}

	value = value.replaceAll("\"", "'");

	//	value = new String(value.getBytes("ISO-8859-1"), "UTF-8");
	final StringBuilder buff = new StringBuilder();

	char ch;
	for (int i = 0; i < value.length(); i++)
	{
	  ch = value.charAt(i);
	  if (!charEncodeMap.containsKey((int) ch))
	  {
		if (ch > 255)
		{
		  buff.append("&#" + (int) ch + ";");
		}
		else
		{
		  buff.append(ch);
		}

	  }
	  else
	  {
		buff.append(charEncodeMap.get((int) ch));
	  }
	}

	return buff.toString();
  }
}
