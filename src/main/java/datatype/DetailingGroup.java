package datatype;

public enum DetailingGroup { scratch("SCRATCH"), photoEtched("PE"), resin("RESIN"), documentation("DOC");
	  private String templateID;
	  DetailingGroup(String templateID) 
	  {
		  this.templateID = templateID;
  }
	  public String getTemplateID() {
		return templateID;
	}
  }