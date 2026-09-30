package datatype;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "MAK_AWARDEDMODELS")
public class AwardedModel extends Record{
	@Id
	@Column(name = "ID")
	public int id;

	@Column(name = "MODEL_ID")
	public int modelID;
	@Column(name = "CATEGORY_ID")
	public int categoryID;
	@Column(name =  "AWARD")
	private String award;
	
	@Override
	public int getId() {
		return id;
	}
	
	@Override
	public void setId(int id) {
		this.id = id;
	}
	
	public int getModelID() {
		return modelID;
	}

    public int getCategoryID() {
        return categoryID;
    }

	public AwardedModel(int id, int modelID, String award, int categoryID) {
		this.modelID = modelID;
		this.categoryID = categoryID;
		this.setAward(award);
	}

	public AwardedModel() {
	}

	@Override
	public String toString() {
		return " award: " + getAward() + " model: " + modelID  + " categoryID: " + categoryID ;
	}

	public String getAward() {
		return award;
	}

	public void setAward(String award) {
		this.award = award;
	}
}
