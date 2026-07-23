package datatype.judging;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.Table;

import org.hibernate.Hibernate;

@Entity
@Table(name = "mak_judgingscore")
public class JudgingScore extends JudgedModel
{
    public final static int MAX_COMMENT_LENGTH = 1000;
  @Column
  private int category;
  @Column
  private String judge;
  @Column
  private int criteriaID;
  
  @OneToOne(fetch = FetchType.LAZY)
  @JoinColumn(name = "criteriaID", insertable = false, updatable = false)
  private JudgingCriteria criteria; 
  
  @Column
  private String score;
  @Column(length = MAX_COMMENT_LENGTH, nullable = true)
  private String comment;
  
  public JudgingScore()
  {
      
  }
  
  public JudgingScore(int id, int category, String judge, int modelID, int modellerID, int criteriaID, String score,
	  String comment,String modelsName)
  {
	super(id, modelID, modellerID, modelsName);

	this.category = category;
	this.judge = judge;
	this.criteriaID = criteriaID;
	this.score = score;
	this.comment = comment;
  }

  public int getCategory()
  {
	return category;
  }

  public void setCategory(int category)
  {
	this.category = category;
  }

  public String getJudge()
  {
	return judge;
  }

  public void setJudge(String judge)
  {
	this.judge = judge;
  }

  public int getCriteriaID()
  {
	return criteriaID;
  }

  public void setCriteriaID(int criteriaID)
  {
	this.criteriaID = criteriaID;
  }

  public String getScore()
  {
	return score;
  }

  public void setScore(String score)
  {
	this.score = score;
  }

  public String getComment()
  {
	return comment;
  }

  public void setComment(String comment)
  {
	this.comment = comment;
  }

@Override
public String toString() {
    return "JudgingScore [category=" + category + ", judge=" + judge + ", criteriaID=" + criteriaID + ", criteria=" + (Hibernate.isInitialized(criteria) ? criteria : "Not loaded") + ", score=" + score + ", comment="
            + comment + ", " + super.toString() + "]";
}

	public JudgingCriteria getCriteria() {
		return criteria;
	}
	
}
