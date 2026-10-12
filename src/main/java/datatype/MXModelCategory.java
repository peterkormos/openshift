package datatype;

import java.io.Serializable;

import javax.annotation.Nullable;
import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.IdClass;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

@Entity
@Table(name = "MAK_MAK_CATEGORY")
public class MXModelCategory implements Serializable{
	private static final long serialVersionUID = -5961409022121136799L;

	@EmbeddedId
	private MXModelCategoryKey key;
	
	@Column(name = "archived")
	@Nullable
	private Boolean archived;
	
	@Column(name = "showID")
	@Nullable
	private Integer showID;

	@ManyToOne
	@JoinColumn(name = "MAK_MODEL_MODEL_ID", insertable = false, updatable = false)
	private Model model;
	
	public MXModelCategory() {
	}

	public int getModelID() {
		return key.getModelID();
	}

	public void setModelID(int modelID) {
		this.key.setModelID(modelID);
	}

	public int getCategoryID() {
		return key.getCategoryID();
	}

	public void setCategoryID(int cateoryID) {
		this.key.setCategoryID(cateoryID);
	}

	public boolean isArchived() {
		return archived == null ? false : archived;
	}

	public void setArchived(boolean archived) {
		this.archived = archived;
	}
	
	public Integer getShowID() {
		return showID;
	}
	
	@Override
	public String toString() {
		return "MXModelCategory [modelID=" + key.getModelID() + ", categoryID=" + key.getCategoryID() + ", archived=" + archived
				+ ", showID=" + showID + "]";
	}

	public void setShowID(int showID) {
		this.showID = showID;
	}
}
