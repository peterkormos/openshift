package datatype;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;

@Entity
@Table(name = "MAK_CATEGORY")
public class Category extends Record
{
  @Column
  public CategoryGroup group;
  @Column
  public String categoryCode;
  @Column
  public String categoryDescription;
  @Column
  private boolean master;
  @Column
  private ModelClass modelClass;
  @Column
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

  public Category()
  {

  }

  public Category(final int categoryID, final String categoryCode, final String categoryDescription, final CategoryGroup group,
	  boolean master, ModelClass modelClass, AgeGroup ageGroup)
  {
	this.setId(categoryID);
	this.categoryCode = categoryCode;
	this.categoryDescription = categoryDescription;
	this.group = group;

	this.master = master;
	this.modelClass = modelClass;
	this.ageGroup = ageGroup;
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
}