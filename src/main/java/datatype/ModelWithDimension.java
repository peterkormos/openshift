package datatype;

public class ModelWithDimension extends Model {
	private int width;
	private int height;
	
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
	
	public int getHeight() {
		return height;
	}
	
	public void setHeight(int height) {
		this.height = height;
	}

	public void setDimensions(int width, int height) {
		this.width = width;
		this.height = height;
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
