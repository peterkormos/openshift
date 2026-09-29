package datatype;

import java.io.Serializable;

public class AwardedModel extends Model {
	private String award;
    public int categoryID;

    public int getCategoryID() {
        return categoryID;
    }

	public AwardedModel(Model model, String award, int categoryID) {
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
