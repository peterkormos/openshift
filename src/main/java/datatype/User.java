package datatype;

import java.io.Serializable;
import java.util.Calendar;
import java.util.LinkedList;
import java.util.List;
import java.util.StringTokenizer;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

@Entity
@Table(name = "MAK_USERS")
public class User extends Record {
	
	private static final long serialVersionUID = -8059689879773108457l;
	@Column(name = "USER_PASSWORD")
	public String password;
	@Column(name = "FIRST_NAME")
	public String firstName;
	@Column(name = "LAST_NAME")
	public String lastName;
	@Column(name = "YEAR_OF_BIRTH")
	public int yearOfBirth;
	@Column(name = "CITY")
	public String city;
	@Column(name = "ADDRESS")
	public String address;
	@Column(name = "TELEPHONE")
	public String telephone;
	@Column(name = "EMAIL")
	public String email;
	@Column(name = "USER_ENABLED")
	public boolean enabled;
	@Column(name = "USER_LANGUAGE")
	public String language;
	@Column(name = "COUNTRY")
	public String country;
	@Column(name = "MODEL_CLASS")
	private String modelClasses;

	public static final String LOCAL_USER = "_LOCAL_";

	public String getFullName() {
		return "-".equals(firstName) ? lastName : lastName + " " + firstName;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getFirstName() {
		return firstName;
	}

	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}

	public String getLastName() {
		return lastName;
	}

	public void setLastName(String lastName) {
		this.lastName = lastName;
	}

	public int getYearOfBirth() {
		return yearOfBirth;
	}

	public void setYearOfBirth(int yearOfBirth) {
		this.yearOfBirth = yearOfBirth;
	}

	public String getCity() {
		return city;
	}

	public void setCity(String city) {
		this.city = city;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getTelephone() {
		return telephone;
	}

	public void setTelephone(String telephone) {
		this.telephone = telephone;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public boolean isEnabled() {
		return enabled;
	}

	public void setEnabled(boolean enabled) {
		this.enabled = enabled;
	}

	public String getLanguage() {
		return language;
	}

	public void setLanguage(String language) {
		this.language = language;
	}

	public String getCountry() {
		return country;
	}

	public void setCountry(String country) {
		this.country = country;
	}
	  @Deprecated
	  public User() {
	}

	public User(String language) {
		this(null, null, null, language, null, null, null, false, null, Calendar.getInstance().get(Calendar.YEAR),
				null);
	}

	public User(String password, String firstname, String lastname, String language, String address,
			String telephone, String email, boolean enabled, String country, int yearOfBirth, String city) {
		this.password = password;
		this.firstName = firstname;
		this.lastName = lastname;
		this.language = language;
		this.address = address;
		this.telephone = telephone;
		this.email = email;
		this.enabled = enabled;
		this.country = country;
		this.yearOfBirth = yearOfBirth;
		this.city = city;
	}

	public List<ModelClass> getModelClass() {
		final List<ModelClass> returned = new LinkedList<ModelClass>();
		if (modelClasses != null) {
			final StringTokenizer mc = new StringTokenizer(modelClasses, ",");

			while (mc.hasMoreTokens()) {
				returned.add(ModelClass.valueOf(mc.nextToken()));
			}
		}

		return returned;
	}
	
	public void setModelClasses(String modelClasses) {
		this.modelClasses = modelClasses;
	}

	@Override
	public String toString() {
		return "User [ID=" + id + ", password=" + password + ", firstName=" + firstName + ", lastName="
				+ lastName + ", yearOfBirth=" + yearOfBirth + ", city=" + city + ", address=" + address + ", telephone="
				+ telephone + ", email=" + email + ", enabled=" + enabled + ", language=" + language + ", country="
				+ country + ", modelClass=" + modelClasses + "]";
	}

	public int getAge() {
		return Calendar.getInstance().get(Calendar.YEAR) - yearOfBirth-1;
	}

	public boolean isLocalUser() {
		return email.indexOf(LOCAL_USER) > -1;
	}

	public boolean isAdminUser() {
		return isSuperAdminUser() || isCategoryAdminUser();
	}

	public boolean isSuperAdminUser() {
		return "ADMIN".equals(language);
	}

	public boolean isCategoryAdminUser() {
		return "CATEGORY".equals(language);
	}

	@Id
	@Column(name = "USER_ID")
	public int id;

	@Override
	public int getId() {
		return id;
	}

	@Override
	public void setId(int id) {
		this.id = id;
	}
}