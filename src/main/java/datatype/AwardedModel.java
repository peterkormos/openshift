package datatype;

import java.io.Serializable;

public class AwardedModel extends Model {
	private String award;

	public AwardedModel(Model model, String award) {
		super(model);
		this.setAward(award);
	}

	public AwardedModel() {

	}

	@Override
	public String toString() {
		return " award: " + getAward() + " model: " + super.toString();
	}

	public String getAward() {
		return award;
	}

	public void setAward(String award) {
		this.award = award;
	}

}
