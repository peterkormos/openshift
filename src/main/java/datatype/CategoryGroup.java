package datatype;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "MAK_CATEGORY_GROUP")
public class CategoryGroup extends Record
{
	@Column(name="MODEL_SHOW")
  public String show;
  @Column(name="CATEGORY_GROUP")
  public String name;
  @Column(name="CATEGORY_GROUP_ID")

  public String getShow()
  {
	return show;
  }

  public void setShow(final String show)
  {
	this.show = show;
  }

  public String getGroup()
  {
	return name;
  }

  public void setGroup(final String group)
  {
	this.name = group;
  }

  @Deprecated
  public CategoryGroup() {
}

  public CategoryGroup(int id) {
super(id);
}

  public CategoryGroup(final int id, final String show, final String group)
  {
  	super(id);
	this.show = show;
	this.name = group;
  }

  @Override
  public String toString()
  {
	return "CategoryGroup [show=" + show + ", categoryGroupID=" + getId() + ", group=" + name + "]";
  }

	@Id
	@Column(name = "CATEGORY_GROUP_ID")
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
