package util.gapi;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.security.GeneralSecurityException;
import java.util.Properties;

import javax.mail.BodyPart;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.Session;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;

import com.google.api.client.util.Base64;
import com.google.api.services.gmail.Gmail;
import com.google.api.services.gmail.GmailScopes;
import com.google.api.services.gmail.model.Message;

public class EmailUtil {

    private final Gmail service;

    public EmailUtil() throws IOException, GeneralSecurityException {
        service = GoogleAPIHelper.getGmailService(GmailScopes.all());
    }

    public void sendEmail(final String from, String to, String subject, String htmlMessage)
            throws MessagingException, IOException {
        MimeMessage emailContent = createEmail(to, from, subject, htmlMessage);

        String userId = "me";
        sendMessage(service, userId, emailContent);
    }

    /**
     * Create a MimeMessage using the parameters provided.
     *
     * @param to       email address of the receiver
     * @param from     email address of the sender, the mailbox account
     * @param subject  subject of the email
     * @param bodyText body text of the email
     * @return the MimeMessage to be used to send email
     * @throws MessagingException
     * @throws UnsupportedEncodingException 
     */
    public static MimeMessage createEmail(String to, String from, String subject, String bodyText)
            throws MessagingException, UnsupportedEncodingException {
        Properties props = new Properties();
        Session session = Session.getDefaultInstance(props, null);

        MimeMessage email = new MimeMessage(session);

        email.setFrom(new InternetAddress(from, "Model registration"));
        email.addRecipient(javax.mail.Message.RecipientType.TO, new InternetAddress(to));
        email.setSubject(subject);
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
        messageBodyPart.setContent(bodyText, "text/html");

        // Add html part to multi part
        multipart.addBodyPart(messageBodyPart);

        // Associate multi-part with message
        email.setContent(multipart);
        return email;
    }

    /**
     * Create a message from an email.
     *
     * @param emailContent Email to be set to raw of message
     * @return a message containing a base64url encoded email
     * @throws IOException
     * @throws MessagingException
     */
    public static Message createMessageWithEmail(MimeMessage emailContent) throws MessagingException, IOException {
        ByteArrayOutputStream buffer = new ByteArrayOutputStream();
        emailContent.writeTo(buffer);
        byte[] bytes = buffer.toByteArray();
        String encodedEmail = Base64.encodeBase64URLSafeString(bytes);
        Message message = new Message();
        message.setRaw(encodedEmail);
        return message;
    }

    /**
     * Send an email from the user's mailbox to its recipient.
     *
     * @param service      Authorized Gmail API instance.
     * @param userId       User's email address. The special value "me" can be used
     *                     to indicate the authenticated user.
     * @param emailContent Email to be sent.
     * @return The sent message
     * @throws MessagingException
     * @throws IOException
     */
    public static Message sendMessage(Gmail service, String userId, MimeMessage emailContent)
            throws MessagingException, IOException {
        Message message = createMessageWithEmail(emailContent);
        message = service.users().messages().send(userId, message).execute();

        System.out.println("Message id: " + message.getId());
        System.out.println(message.toPrettyString());
        return message;
    }
}
