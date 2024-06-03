package datatype.judging;

import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import datatype.Record;
import servlet.ServletDAO;

@Entity
@Table(name = "mak_judgingsheet")
public class JudgingSheet extends Record {
	@Column
	private String name;
	
	@Column
	@OneToMany(cascade=CascadeType.ALL, fetch=FetchType.EAGER)
	private List<JudgingCriteria> criterias;

	public JudgingSheet() {
	}

	public JudgingSheet(String name, List<JudgingCriteria> criterias) {
		super();
		this.name = ServletDAO.encodeString(name);
		this.criterias = criterias;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public List<JudgingCriteria> getCriterias() {
		return criterias;
	}

	public void setCriterias(List<JudgingCriteria> criterias) {
		this.criterias = criterias;
	}

	@Override
	public String toString() {
		return "JudgingSheet [name=" + name + ", criterias=" + criterias + "]";
	}

	@SequenceGenerator(name = "RecordSeqgen", sequenceName = "S_JudgingSheet")
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "RecordSeqgen")
	@Id
	@Column
	public int id;

	@Override
	public int getId() {
		return id;
	}

	@Override
	public void setId(int id) {
		this.id = id;
	}
	}

