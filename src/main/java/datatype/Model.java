package datatype;

import java.io.Serializable;
import java.util.List;
import java.util.Map;

import javax.persistence.Transient;

import datatype.Detailing.DetailingGroup;

public class Model implements Serializable {
    private static final long serialVersionUID = -3161543148518903037L;

    public int modelID;

    public int userID;
    public int categoryID;

    public String scale;
    public String name;
    public String producer;
    public String comment;

    public String identification;
    public String markings;
    public boolean gluedToBase;

    public Map<DetailingGroup, Detailing> detailing;

    @Transient
    public User user;
    @Transient
    public Category category;

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
        this.userID = this.user.getUserID();
    }

    public Category getCategory() {
        return category;
    }

    public void setCategory(Category category) {
        this.category = category;
        this.categoryID = this.category.getId();
    }

    public Model() {

    }

    public int getModelID() {
        return modelID;
    }

    public void setModelID(int modelID) {
        this.modelID = modelID;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public int getCategoryID() {
        return categoryID;
    }

    public void setCategoryID(int categoryID) {
        this.categoryID = categoryID;
    }

    public String getScale() {
        return scale;
    }

    public void setScale(String scale) {
        this.scale = scale;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getProducer() {
        return producer;
    }

    public void setProducer(String producer) {
        this.producer = producer;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public String getIdentification() {
        return identification;
    }

    public void setIdentification(String identification) {
        this.identification = identification;
    }

    public String getMarkings() {
        return markings;
    }

    public void setMarkings(String markings) {
        this.markings = markings;
    }

    public boolean isGluedToBase() {
        return gluedToBase;
    }

    public void setGluedToBase(boolean gluedToBase) {
        this.gluedToBase = gluedToBase;
    }

    public Map<DetailingGroup, Detailing> getDetailing() {
        return detailing;
    }

    public void setDetailing(Map<DetailingGroup, Detailing> detailing) {
        this.detailing = detailing;
    }

    public Model(int modelID, int userID, int categoryID, String scale, String name, String producer, String comment,
	  String identification, String markings, boolean gluedToBase, Map<DetailingGroup, Detailing> detailing)
  {
	this.modelID = modelID;
	this.userID = userID;
	this.categoryID = categoryID;
	this.scale = scale;
	this.name = name;
	this.producer = producer;
	this.comment = comment;

	this.identification = identification;
	this.markings = markings;
	this.gluedToBase = gluedToBase;

	this.detailing = detailing;
	  }
  
	public Model(Model model)
  {
	this.modelID = model.modelID;
	this.userID = model.userID;
	this.categoryID = model.categoryID;
	this.scale = model.scale;
	this.name = model.name;
	this.producer = model.producer;
	this.comment = model.comment;

	this.identification = model.identification;
	this.markings = model.markings;
	this.gluedToBase = model.gluedToBase;

	this.detailing = model.detailing;
    }

    @Override
    public String toString() {
        String returned = " modelID: " + modelID + " userID: " + userID + " categoryID: " + categoryID + " scale: " + scale + " name: "
                + name + " producer: " + producer + " comment: " + comment +

                " identification: " + identification + " markings: " + markings + " gluedToBase: " + gluedToBase +

                " detailing: " + detailing;

        return returned;
    }

    public Detailing getDetailingGroup(DetailingGroup group) {
        return detailing.get(group);
    }
}