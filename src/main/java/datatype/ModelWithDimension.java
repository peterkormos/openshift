package datatype;

public class ModelWithDimension extends Model {
	private int width;
	private int length;
	
	public ModelWithDimension(final Model model, final int width, final int height) {
		super(model);
		setDimensions(width, height);
	}

	public int getWidth() {
		return width;
	}
	
	public void setWidth(int width) {
		this.width = width;
	}
	
	public int getLength() {
		return length;
	}
	
	public void setLength(int length) {
		this.length = length;
	}

	public void setDimensions(int width, int height) {
		this.width = width;
		this.length = height;
	}
	
	public int getArea() {
		return width * length;
	}
	
	public boolean isOversized() {
		return getArea() > 1000;
	}

	@Override
	public String getDBFields() {
		return super.getDBFields() + 
				", MODEL_width, MODEL_height";
	}
	
	@Override
	public String getDBFieldPlaceholders() {
		return super.getDBFieldPlaceholders() + ",?,?";
	}
}
