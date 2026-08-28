package datatype;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;

@Entity
@Table(name = "MAK_SYSTEM")
public class SystemParameter {

	  @Column(name = "PARAM_VALUE")
	  private String value;

	  @Column(name = "PARAM_NAME")
	  private String name;
	  
	  @Column
	  private String show;

	  public SystemParameter(String value, String name, String show) {
		this.value = value;
		this.name = name;
		this.show = show;
	}

	  public String getValue() {
		  return value;
	  }

	  public void setValue(String value) {
		  this.value = value;
	  }

	  public String getName() {
		  return name;
	  }

	  public void setName(String name) {
		  this.name = name;
	  }

	  public String getShow() {
		  return show;
	  }

	  public void setShow(String show) {
		  this.show = show;
	  }
	  
	  
}
