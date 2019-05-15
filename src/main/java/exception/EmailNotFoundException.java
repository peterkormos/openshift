package exception;

public class EmailNotFoundException extends Exception {
    private final String email;

    public EmailNotFoundException(String email) {
        this.email = email;
    }

    public String getEmail() {
        return email;
    }
    
    @Override
    public String getMessage() {
        return "email not found in DB. email: " + email;
    }

    private static final long serialVersionUID = -1917227317392689037L;

}
