package datatype;

public class PrintedModel extends Model{
	private int fee;
	
	public PrintedModel(Model m) {
		super(m);
	}

	public void setFee(int fee) {
		this.fee = fee;
	}

	public int getFee() {
		return fee;
	}
}
