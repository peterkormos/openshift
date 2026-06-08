package datatype;

public class PrintedModel extends Model {
	private boolean highlightBorder;
	
	public PrintedModel(Model model, boolean highlightBorder) {
		super(model);
		this.highlightBorder = highlightBorder;
	}
	
	public boolean shouldHighlightBorder() {
		return this.highlightBorder;
	}
}
