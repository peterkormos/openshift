package datatype;

public enum DetailingCriteria  { externalSurface("externalSurface"), cockpit("cockpit"), engine("engine"), 
		  undercarriage("undercarriage"),
	gearBay("gearBay",
		      false), 
	armament("armament"), conversion("conversion") ;
	  
	  private String templateID;
	  private boolean visible = true;

	  DetailingCriteria(String templateID) 
	  {
		  this.templateID = templateID;
  }
	  public String getTemplateID() {
		return templateID;
	}
	  
	  DetailingCriteria(String templateID, boolean visible)
	  {
		  this(templateID);
		  this.visible = visible;
  }
	  
	  public boolean isVisible() {
		return visible;
	}
	}