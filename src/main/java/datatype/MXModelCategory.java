package datatype;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "MAK_MAK_CATEGORY")
public class MXModelCategory implements Serializable{
	private static final long serialVersionUID = -5961409022121136799L;

	@Id
	@Column(name = "MAK_MODEL_MODEL_ID")
	private int modelID;
	
	@Id
	@Column(name = "CATEGORIES_CATEGORY_ID")
	private int categoryID;
	
	@Column(name = "archived")
	private boolean archived;
	
	public MXModelCategory() {
	}

	public int getModelID() {
		return modelID;
	}

	public void setModelID(int modelID) {
		this.modelID = modelID;
	}

	public int getCategoryID() {
		return categoryID;
	}

	public void setCategoryID(int cateoryID) {
		this.categoryID = cateoryID;
	}

	public boolean getArchived() {
		return archived;
	}

	public void setArchived(boolean archived) {
		this.archived = archived;
	}
	
	
}
