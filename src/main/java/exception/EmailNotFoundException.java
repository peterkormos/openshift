package exception;

public class EmailNotFoundException extends IllegalArgumentException {

    public EmailNotFoundException(String email) {
        super(email);
    }

    public String getEmail() {
        return getMessage();
    }
    
    @Override
    public String getMessage() {
        return "email not found in DB. email: " + getMessage();
    }

    private static final long serialVersionUID = -1917227317392689037L;

}
