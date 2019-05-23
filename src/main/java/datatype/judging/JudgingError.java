package datatype.judging;

public class JudgingError 
{
    @Override
    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result + ((category == null) ? 0 : category.hashCode());
        result = prime * result + modelID;
        return result;
    }
    @Override
    public boolean equals(Object obj) {
        if (this == obj)
            return true;
        if (obj == null)
            return false;
        if (getClass() != obj.getClass())
            return false;
        JudgingError other = (JudgingError) obj;
        if (category == null) {
            if (other.category != null)
                return false;
        } else if (!category.equals(other.category))
            return false;
        if (modelID != other.modelID)
            return false;
        return true;
    }
    public String getCategory() {
        return category;
    }
    public void setCategory(String category) {
        this.category = category;
    }
    public int getModelID() {
        return modelID;
    }
    public void setModelID(int modelID) {
        this.modelID = modelID;
    }
    public String getErrorMessage() {
        return errorMessage;
    }
    public void setErrorMessage(String errorMessage) {
        this.errorMessage = errorMessage;
    }
    public JudgingError(String category, int modelID) {
        super();
        this.category = category;
        this.modelID = modelID;
    }
    @Override
    public String toString() {
        return "JudgingError [category=" + category + ", modelID=" + modelID + ", errorMessage=" + errorMessage + "]";
    }
    private String category;
    private int modelID;
    private String errorMessage;

}
