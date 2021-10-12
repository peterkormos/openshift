package datatype.judging;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.OneToOne;
import javax.persistence.Table;

import datatype.Record;

@Entity
@Table(name = "mak_judgingcategory")
public class JudgingCategory extends Record{
	@Column
	private int categoryId;
	
	@OneToOne(cascade=CascadeType.ALL)
	private JudgingSheet judgingSheet;

	public JudgingCategory() {
	}

	public JudgingCategory(int categoryId, JudgingSheet judgingSheet) {
		super();
		this.categoryId = categoryId;
		this.judgingSheet = judgingSheet;
	}

	public int getCategoryId() {
		return categoryId;
	}

	public void setCategoryId(int categoryId) {
		this.categoryId = categoryId;
	}

	public JudgingSheet getJudgingSheet() {
		return judgingSheet;
	}

	public void setJudgingSheet(JudgingSheet judgingSheet) {
		this.judgingSheet = judgingSheet;
	}

	@Override
	public String toString() {
		return "JudgingCategory [categoryId=" + categoryId + ", judgingSheet=" + judgingSheet + "]";
	}
	
}
