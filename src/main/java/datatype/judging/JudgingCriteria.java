package datatype.judging;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.ManyToMany;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import datatype.Record;

@Entity
@Table(name = "mak_judgingcriteria")
public class JudgingCriteria extends Record
{
  @Column
  private int criteriaId;
  @Column
  private String description;
  @Column
  private int maxScore;
  
	public JudgingCriteria() {
	}
	
  public static final JudgingCriteria getDefault()
  {
      return new JudgingCriteria(1, "", 10);
  }

  public JudgingCriteria(int criteriaId, String description, int maxScore)
  {
	super();
	this.criteriaId = criteriaId;
	this.description = description;
	this.maxScore = maxScore;
  }

  public int getCriteriaId()
  {
	return criteriaId;
  }

  public void setCriteriaId(int id)
  {
	this.criteriaId = id;
  }

  public String getDescription()
  {
	return description;
  }

  public void setDescription(String description)
  {
	this.description = description;
  }

  public int getMaxScore()
  {
	return maxScore;
  }

  public void setMaxScore(int maxScore)
  {
	this.maxScore = maxScore;
  }

  @Override
  public String toString()
  {
	return "JudgingCriteria [id=" + id + ", description=" + description + ", maxScore=" + maxScore + "]";
  }

}
