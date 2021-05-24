package datatype;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.Table;

@Entity
@Table(name = "mak_LoginConsent")
public class LoginConsent extends Record {
    @Override
    public String toString() {
        return "LoginConsent [modellerID=" + modellerID + ", type=" + type + "]";
    }

    public enum LoginConsentType {
        Competition(true), Statistics(false), Marketing(false);

        private final boolean mandatory;

        LoginConsentType(boolean mandatory) {
            this.mandatory = mandatory;
        }

        public boolean isMandatory() {
            return mandatory;
        }
    }

    @Column
    protected int modellerID;

    @Column
    @Enumerated(EnumType.STRING)
    protected LoginConsentType type;

    public LoginConsent()
    {
        
    }
    
    public LoginConsent(int id, int modellerID, LoginConsentType type) {
        super(id);
        this.modellerID = modellerID;
        this.type = type;
    }
    
    public LoginConsentType getType() {
        return type;
    }
}
