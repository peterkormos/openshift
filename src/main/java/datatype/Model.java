package datatype;

import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashSet;
import java.util.LinkedList;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;
import java.util.Set;

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
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToOne;
import javax.persistence.MapKey;
import javax.persistence.MappedSuperclass;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.PostLoad;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Transient;

@Entity
@Table(name = "MAK_MODEL")
public class Model extends Record {
    public static final int OversizedAreaInCm = 1000;

	private static final long serialVersionUID = -3161543148518903037L;

	@Id
	@Column(name = "MODEL_ID")
	public int id;	
	
    @OneToMany(fetch = FetchType.EAGER)
    @JoinTable(name = "MAK_MAK_CATEGORY")
    @Nullable
    public Set<Category> categories = new HashSet<>();

    public Set<Category> getCategories() {
		return categories;
	}

	public void setCategories(Set<Category> categories) {
		this.categories = categories;
	}

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

    @OneToMany(mappedBy = "model", cascade = CascadeType.ALL, fetch = FetchType.EAGER)
    @Nullable
    public Collection<Detailing> detailing;    
    @Transient
    public Map<DetailingGroup, Map<DetailingCriteria, Boolean>> details;

    @Column(name = "crd")
    public Date creationDate = new Date();
    
    @ManyToOne
    @JoinColumn(name = "USER_ID")
    public User user;
	@Column(name = "MODEL_width")
	private int width;
	@Column(name = "MODEL_height")
	private int length;
	
    @OneToMany(fetch = FetchType.EAGER, mappedBy = "model")
    @MapKey(name = "categoryID")
    @Nullable
    public Map<Integer, MXModelCategory> mxModelCategories;

	public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }


	public void setCategory(Category category) {
		Category existingCategory = getCategoryForShow(category.getGroup().getShow()).orElse(null);
		if(existingCategory != null) {
			getCategories().remove(existingCategory);
		}
		getCategories().add(category);
	}

	public void unsetCategory(Category category) {
		getCategories().remove(category);
    }

    public Model() {

    }

    public int getUserID() {
        return user.getId();
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
        details = null;
    }

    public Collection<Detailing> getDetailing() {
		return detailing;
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
    
    public Model(Model model)
  {
	this(model.getId());
	this.user = model.getUser();
	this.categories = model.categories;
	this.scale = model.scale;
	this.name = model.name;
	this.producer = model.producer;
	this.comment = model.comment;
	this.identification = model.identification;
	this.markings = model.markings;
	this.gluedToBase = model.gluedToBase;
	this.detailing = model.detailing;
	this.creationDate = model.creationDate;
	this.length = model.length;
	this.width = model.width;
	this.mxModelCategories = model.mxModelCategories;
    }

    @Override
    public String toString() {
        String returned = super.toString() + " userID: " + getUserID() + " categoryies: " + categories + " scale: " + scale + " name: "
                + name + " producer: " + producer + " comment: " + comment +

                " identification: " + identification + " markings: " + markings + " gluedToBase: " + gluedToBase +

                " detailing: " + detailing;

        return returned;
    }

	@Override
	public int getId() {
		return id;
	}

	@Override
	public void setId(int id) {
		this.id = id;
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
		return getArea() > OversizedAreaInCm;
	}

	public Optional<Category> getCategoryForShow(String show) {
		return getCategories().stream().filter(category -> {
			return category.getGroup().getShow().equals(show);
		}).findFirst();
	}
	
	public boolean isLinkedToShow(String show) {
		return getCategoryForShow(show).isPresent();
	}
    
	public boolean isArchived(int categoryID) {
		if(mxModelCategories == null) {
			return false;
		}

		MXModelCategory mx = mxModelCategories.get(categoryID);
		return mx != null && mx.isArchived();
	}
	
	public String getShowID(Category category) {
		if(category == null) {
			return "";
		}
		
		Integer showID = getShowID(category.getId());
		if(showID == null) {
			return "";
		}
		
		return String.valueOf(showID);
	}
	
	public Integer getShowID(int categoryID) {
		if(mxModelCategories == null) {
			return null;
		}
		
		MXModelCategory mxModelCategory = mxModelCategories.get(categoryID);
		return mxModelCategory != null ? mxModelCategory.getShowID() == null ? getId() : mxModelCategory.getShowID() : null;
	}
	
	public boolean isShowIDSet(int categoryID) {
		if(mxModelCategories == null) {
			return false;
		}
		
		MXModelCategory mxModelCategory = mxModelCategories.get(categoryID);
		return (mxModelCategory != null ? mxModelCategory.getShowID() : null) != null;
	}
	
	public Map<Integer, MXModelCategory> getMxModelCategories() {
		return mxModelCategories;
	}
	
	public Date getCreationDate() {
		return creationDate;
	}
	
	public void setCreationDate(Date creationDate) {
		this.creationDate = creationDate;
	}
}