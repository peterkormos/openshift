package datatype;

import java.util.Collection;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

import javax.annotation.Nullable;
import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinTable;
import javax.persistence.MappedSuperclass;
import javax.persistence.OneToMany;
import javax.persistence.PostLoad;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Transient;

@Entity
@Table(name = "MAK_MODEL")
public class Model extends Record {
    private static final long serialVersionUID = -3161543148518903037L;

    @Column(name = "USER_ID")
    public int userID;
    @Column(name = "CATEGORY_ID")
    public int categoryID;

    @Column(name = "MODEL_SCALE")
    public String scale;
    @Column(name = "MODEL_NAME")
    public String name;
    @Column(name = "PRODUCER")
    public String producer;
    @Column(name = "COMMENTS")
    public String comment;

    @Column(name = "IDENTIFICATION")
    public String identification;
    @Column(name = "MARKINGS")
    public String markings;
    @Column(name = "GLUEDTOBASE")
    public boolean gluedToBase;

    @OneToMany(cascade = CascadeType.ALL, fetch = FetchType.EAGER)
    @JoinTable(name = "MAK_MAK_DETAILING")
    @Nullable
    public Collection<Detailing> detailing;

    @Transient
    public Map<DetailingGroup, Map<DetailingCriteria, Boolean>> details;

    @Transient
    public User user;
    @Transient
    public Category category;

	public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
        this.userID = this.user.getId();
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

    public void setDetailing(Collection<Detailing> detailing) {
        this.detailing = detailing;
    }

    
    @PostLoad
    public void postLoad() {
    	if(Objects.isNull(details)) {
    		details = new HashMap<>();
    		detailing.forEach(d -> {
    			DetailingGroup detailingGroup = d.getDetailingGroup();
    			Map<DetailingCriteria, Boolean> criterias = details.get(detailingGroup);
    			if(Objects.isNull(criterias)) {
    				criterias = new HashMap<>(); 
    				details.put(detailingGroup, criterias);
    			}
    			
    			criterias.put(d.getDetailingCriteria(), d.getChecked());
    		});
    	}
    }
    
	public boolean isDetailed(DetailingGroup group, final DetailingCriteria criteria) {
		postLoad();
		
		return Boolean.TRUE.equals(details.getOrDefault(group, new HashMap<>()).get(criteria));
	}

    public Model(final int id)
  {
    	setId(id);
  }
    
    public Model(final int id, int userID, int categoryID, String scale, String name, String producer, String comment,
	  String identification, String markings, boolean gluedToBase)
  {
    	this(id);
	this.userID = userID;
	this.categoryID = categoryID;
	this.scale = scale;
	this.name = name;
	this.producer = producer;
	this.comment = comment;

	this.identification = identification;
	this.markings = markings;
	this.gluedToBase = gluedToBase;
	  }
  
	public Model(Model model)
  {
	this(model.getId());
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
        String returned = super.toString() + " userID: " + userID + " categoryID: " + categoryID + " scale: " + scale + " name: "
                + name + " producer: " + producer + " comment: " + comment +

                " identification: " + identification + " markings: " + markings + " gluedToBase: " + gluedToBase +

                " detailing: " + detailing;

        return returned;
    }

	@Id
	@Column(name = "MODEL_ID")
	public int id;

	@Override
	public int getId() {
		return id;
	}

	@Override
	public void setId(int id) {
		this.id = id;
	}

	@Column(name = "MODEL_width")
	private int width;
	@Column(name = "MODEL_height")
	private int length;
	
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
}