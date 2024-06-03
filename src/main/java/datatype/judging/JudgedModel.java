package datatype.judging;

import javax.persistence.Column;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.MappedSuperclass;
import javax.persistence.SequenceGenerator;

import datatype.Model;
import datatype.Record;

@MappedSuperclass
public class JudgedModel extends Record {

    @Override
    public String toString() {
        return "JudgedModel [modelID=" + modelID + ", modellerID=" + modellerID + ", modelsName=" + modelsName + ", "
                + super.toString() + "]";
    }

    @Column
    protected int modelID;
    @Column
    protected int modellerID;
    @Column
    protected String modelsName;

    public JudgedModel() {
        super();
    }

    public JudgedModel(JudgedModel model)
    {
        this(model.getId(), model.getModelID(), model.getModellerID(), model.getModelsName());
    }
    
    public JudgedModel(Model model)
    {
        this(0, model.getId(), model.getUserID(), model.getName());
    }
    
    public void setModel(Model model)
    {
    	if(model == null) {
	        this.modelID = 0;
	        this.modellerID = 0;
	        this.modelsName = null;    		
    	}
    	else {
	        this.modelID = model.getId();
	        this.modellerID = model.getUserID();
	        this.modelsName = model.getName();
    	}
    }
    
    public JudgedModel(int id, int modelID, int modellerID, String modelsName) {
        super(id);
        
        this.modelID = modelID;
        this.modellerID = modellerID;
        this.modelsName = modelsName;
    }

    public String getModelsName() {
        return modelsName;
    }

    public void setModelsName(String modelsName) {
        this.modelsName = modelsName;
    }

    public int getModelID() {
    	return modelID;
      }

    public void setModelID(int modelID) {
    	this.modelID = modelID;
      }

    public int getModellerID() {
    	return modellerID;
      }

    public void setModellerID(int modellerID) {
    	this.modellerID = modellerID;
      }

	@SequenceGenerator(name = "RecordSeqgen", sequenceName = "S_JudgedModel")
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "RecordSeqgen")
	@Id
	@Column
	public int id;

	@Override
	public int getId() {
		return id;
	}

	@Override
	public void setId(int id) {
		this.id = id;
	}
	}
