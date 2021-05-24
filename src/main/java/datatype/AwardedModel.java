package datatype;

import java.io.Serializable;

public class AwardedModel  extends Model
{
  public String award;

  public AwardedModel(Model model, String award)
  {
	  super(model);
	this.award = award;
  }

  public AwardedModel()
  {

  }

  @Override
  public String toString()
  {
	return " award: " + award + " model: " + super.toString();
  }

}
