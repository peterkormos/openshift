package util;

import java.io.IOException;
import java.security.GeneralSecurityException;
import java.util.Properties;

import javax.mail.BodyPart;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;

public class EmailUtil {
	private String smtpServer;
	private boolean debugSMTP;
	private String from;
	private String password;

//	private GmailUtil gmail;

	public EmailUtil(final String smtpServer, final boolean debugSMTP,
			final String from, final String password) throws IOException, GeneralSecurityException {
		this.smtpServer = smtpServer;
		this.debugSMTP = debugSMTP;
		this.from = from;
		this.password = password;

//		gmail = new GmailUtil();
	}

	public void sendEmail(final String to, final String subject, final String htmlMessage) throws MessagingException, IOException {
//		gmail.sendEmail(from, to, subject, htmlMessage);
		standardSendEmail(to, subject, htmlMessage);
	}

    public void standardSendEmail(final String to, final String subject, final String htmlMessage) throws MessagingException  {
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
        props.put("mail.smtp.socketFactory.fallback", "false");
//        props.put("mail.smtp.socketFactory.port", "465");
//        props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
//        props.put("mail.smtp.auth", "true");
//        props.put("mail.smtp.port", "465");
//        props.put("mail.smtp.starttls.enable", "true");
//        props.put("mail.smtp.EnableSSL.enable", "true");
        props.put("mail.smtp.port", "25");
        props.put("mail.smtp.auth", "false");
        props.put("mail.smtp.starttls.enable", "false");
        
//        final Session session = Session.getDefaultInstance(props, new javax.mail.Authenticator() {
//            @Override
//            protected PasswordAuthentication getPasswordAuthentication() {
//                return new PasswordAuthentication(from, password);
//            }
//        });
        Session session = Session.getInstance(props);

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
}
