package datatype;

import java.io.Serializable;
import java.util.Arrays;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import datatype.Detailing.DetailingCriteria;
import datatype.Detailing.DetailingGroup;

public class Detailing implements Serializable
{
  public static enum DetailingGroup { scratch("SCRATCH"), photoEtched("PE"), resin("RESIN"), documentation("DOC");
	  private String templateID;
	  DetailingGroup(String templateID) 
	  {
		  this.templateID = templateID;
  }
	  public String getTemplateID() {
		return templateID;
	}
  };

  public static enum DetailingCriteria  { externalSurface("externalSurface"), cockpit("cockpit"), engine("engine"), 
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
	};

  public DetailingGroup group;

  public Map<DetailingCriteria, Boolean> criterias = new HashMap<DetailingCriteria, Boolean>();

  public DetailingGroup getGroup()
  {
	return group;
  }

  public void setGroup(DetailingGroup group)
  {
	this.group = group;
  }

  public Map<DetailingCriteria, Boolean> getCriterias()
  {
	return criterias;
  }

  public void setCriterias(Map<DetailingCriteria, Boolean>criterias)
  {
	this.criterias = criterias;
  }

  public Detailing()
  {

  }

  public Detailing(DetailingGroup group, Map<DetailingCriteria, Boolean> criterias)
  {
	this.group = group;
	this.criterias = criterias;
  }

  @Override
  public String toString()
  {
	return " group: " + group + " criterias: " + Arrays.asList(criterias);
  }

public boolean getCriteria(DetailingCriteria criteria) {
	return criterias.get(criteria);
}
}
