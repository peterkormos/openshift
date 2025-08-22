package datatype;

import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinTable;
import javax.persistence.ManyToOne;
import javax.persistence.MapKey;
import javax.persistence.MapKeyEnumerated;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

@Entity
@Table(name = "MAK_DETAILING")
public class Detailing extends Record {
	
	@Column
	@Enumerated(EnumType.STRING)
	private DetailingGroup detailingGroup;
	@Column
	@Enumerated(EnumType.STRING)
	private DetailingCriteria detailingCriteria;
	@Column
	private Boolean checked;

	@Deprecated
	public Detailing() {

	}
	
	public Detailing(final int id)
	  {
	  	setId(id);
	}


	public Detailing(final int id, DetailingGroup detailingGroup, DetailingCriteria detailingCriteria, Boolean checked) {
		this(id);
		this.detailingGroup = detailingGroup;
		this.detailingCriteria = detailingCriteria;
		this.checked = checked;
	}

	public DetailingGroup getDetailingGroup() {
		return detailingGroup;
	}

	public void setDetailingGroup(DetailingGroup detailingGroup) {
		this.detailingGroup = detailingGroup;
	}

	public DetailingCriteria getDetailingCriteria() {
		return detailingCriteria;
	}

	public void setDetailingCriteria(DetailingCriteria detailingCriteria) {
		this.detailingCriteria = detailingCriteria;
	}

	public Boolean getChecked() {
		return checked;
	}

	public void setChecked(Boolean checked) {
		this.checked = checked;
	}

	@Override
	public String toString() {
		return "Detailing [detailingGroup=" + detailingGroup + ", detailingCriteria="
				+ detailingCriteria + ", checked=" + checked + ", id=" + getId() + "]";
	}
	
	@Id
	@Column
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
