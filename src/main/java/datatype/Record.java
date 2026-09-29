package datatype;

import java.io.Serializable;
import java.util.Objects;

import javax.persistence.Column;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.MappedSuperclass;
import javax.persistence.SequenceGenerator;

@MappedSuperclass
public abstract class Record implements Comparable<Record>, Serializable {
	private static final long serialVersionUID = 981936459982533762L;

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

	@Override
	public int hashCode() {
		return Objects.hash(getId());
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		Record other = (Record) obj;
		return getId() == other.getId();
	}
}
