package datatype.judging;

public class JudgingError {
    public enum JudgingErrorType {
        ModelIdAndModellerID_Mismatch("lightgreen"), TotalEvaluatedCriterias_Mismatch("#ffe3e3"), TotalEvaluatedModels_Mismatch("orange");

        private final String backgrouondColor;
        
        JudgingErrorType(String backgrouondColor)
        {
            this.backgrouondColor = backgrouondColor;
        }
        
        public String getBackgrouondColor() {
            return backgrouondColor;
        }
    }

    private JudgingErrorType errorType;

    public JudgingErrorType getErrorType() {
        return errorType;
    }

    public void setErrorType(JudgingErrorType errorType) {
        this.errorType = errorType;
    }

    @Override
    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result + category;
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
        if (category != other.category)
            return false;
        if (modelID != other.modelID)
            return false;
        return true;
    }

    public int getCategory() {
        return category;
    }

    public void setCategory(int category) {
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

    public JudgingError(int category, int modelID) {
        super();
        this.category = category;
        this.modelID = modelID;
    }

    @Override
    public String toString() {
        return "JudgingError [category=" + category + ", modelID=" + modelID + ", errorMessage=" + errorMessage + ", errorType= "
                + errorType + "]";
    }
    
    public boolean isPresent()
    {
        return errorMessage != null;
    }

    private int category;
    private int modelID;
    private String errorMessage;

}
