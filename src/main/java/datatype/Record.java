package datatype;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.MappedSuperclass;
import javax.persistence.SequenceGenerator;

@MappedSuperclass
public abstract class Record implements Comparable<Record>, Serializable {
	public Record() {

	}

	public Record(int id) {
		setId(id);
	}

	public void update(Record record) {
		setId(record.getId());
	}

	@Override
	public String toString() {
		return "id: " + getId();
	}

	public abstract int getId();
	public abstract void setId(int id);

	@Override
	public int compareTo(Record o) {
		return new Integer(getId()).compareTo(o.getId());
	}
}
