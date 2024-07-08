package datatype;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

@Entity
@Table(name = "MAK_CATEGORY")
public class Category extends Record
{
	@ManyToOne(fetch = FetchType.EAGER)
	@JoinColumn(name = "CATEGORY_GROUP_ID")
//	@JoinTable(name = "MAK_CAT_CATG", joinColumns = {
//	})
  public CategoryGroup group;
  @Column(name = "CATEGORY_CODE")
  public String categoryCode;
  @Column(name = "CATEGORY_DESCRIPTION")
  public String categoryDescription;
  @Column(name = "MASTER")
  private boolean master;
  @Column(name = "MODEL_CLASS")
  @Enumerated(EnumType.STRING)
  private ModelClass modelClass;
	@Column(name = "ageGroup")
	@Enumerated(EnumType.STRING)
  private AgeGroup ageGroup;

  public CategoryGroup getGroup()
  {
	return group;
  }

  public void setGroup(final CategoryGroup group)
  {
	this.group = group;
  }

  public String getCategoryCode()
  {
	return categoryCode;
  }

  public void setCategoryCode(final String categoryCode)
  {
	this.categoryCode = categoryCode;
  }

  public String getCategoryDescription()
  {
	return categoryDescription;
  }

  public void setCategoryDescription(final String categoryDescription)
  {
	this.categoryDescription = categoryDescription;
  }

  @Deprecated
  public Category() {
}

  public Category(final int id, final String categoryCode, final String categoryDescription, final CategoryGroup group,
	  boolean master, ModelClass modelClass, AgeGroup ageGroup)
  {
  	super(id);
	this.categoryCode = categoryCode;
	this.categoryDescription = categoryDescription;
	this.group = group;

	this.master = master;
	this.modelClass = modelClass;
	this.ageGroup = ageGroup;
  }

  public Category(int id) {
super(id);
}

public boolean isMaster()
  {
	return master;
  }

  public void setMaster(boolean master)
  {
	this.master = master;
  }

  public ModelClass getModelClass()
  {
	return modelClass;
  }

  public void setModelClass(ModelClass modelClass)
  {
	this.modelClass = modelClass;
  }

  public AgeGroup getAgeGroup()
  {
	return ageGroup;
  }

  public void setAgeGroup(AgeGroup ageGroup)
  {
	this.ageGroup = ageGroup;
  }

  @Override
  public String toString()
  {
	return "Category [" + super.toString() + ", group=" + group + ", categoryCode=" + categoryCode
	    + ", categoryDescription=" + categoryDescription + ", master=" + master + ", modelClass=" + modelClass + ", ageGroup="
	    + ageGroup + "]";
  }
	@Id
	@Column(name = "CATEGORY_ID")
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