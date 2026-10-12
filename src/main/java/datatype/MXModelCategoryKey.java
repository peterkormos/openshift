package datatype;

import java.io.Serializable;
import java.util.Objects;

import javax.persistence.Column;
import javax.persistence.Embeddable;

@Embeddable
public class MXModelCategoryKey implements Serializable {
	private static final long serialVersionUID = 1L;

	@Column(name = "MAK_MODEL_MODEL_ID")
	private int modelID;
	
	@Column(name = "CATEGORIES_CATEGORY_ID")
	private int categoryID;

	public MXModelCategoryKey() {
	}

	public MXModelCategoryKey(int modelID, int categoryID) {
		this.modelID = modelID;
		this.categoryID = categoryID;
	}

	// Getters and Setters
	public int getModelID() {
		return modelID;
	}

	public void setModelID(int modelID) {
		this.modelID = modelID;
	}

	public int getCategoryID() {
		return categoryID;
	}

	public void setCategoryID(int categoryID) {
		this.categoryID = categoryID;
	}

	@Override
	public boolean equals(Object o) {
		if (this == o)
			return true;
		if (o == null || getClass() != o.getClass())
			return false;
		MXModelCategoryKey that = (MXModelCategoryKey) o;
		return modelID == that.modelID && categoryID == that.categoryID;
	}

	@Override
	public int hashCode() {
		return Objects.hash(modelID, categoryID);
	}
}