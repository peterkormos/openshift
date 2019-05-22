package datatype.judging;

import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Map.Entry;
import java.util.concurrent.atomic.AtomicInteger;

public class JudgingResult {
    private String category;
    private String judge;
    private int modelID;
    private int modellerID;

    // value:count
    private final Map<JudgingCriteria, AtomicInteger> scores = new LinkedHashMap<JudgingCriteria, AtomicInteger>();

    public JudgingResult(JudgingScore result) {
        this.category = result.getCategory();
        this.judge = result.getJudge();
        this.modelID = result.getModelID();
        this.modellerID = result.getModellerID();
    }

    @Override
    public String toString() {
        return "JudgingResult [category=" + category + ", judge=" + judge + ", modelID=" + modelID + ", modellerID=" + modellerID
                + ", scores=" + scores + "]";
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getJudge() {
        return judge;
    }

    public void setJudge(String judge) {
        this.judge = judge;
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

    public Map<JudgingCriteria, AtomicInteger> getScores() {
        return scores;
    }

    public int getMaxScore() {
        int maxScore = 0;

        for (JudgingCriteria criteria : scores.keySet())
            if (criteria.getMaxScore() > maxScore)
                maxScore = criteria.getMaxScore();

        return maxScore;
    }

    public AtomicInteger getScoreForCriteria(int criteriaID) {
        for (Entry<JudgingCriteria, AtomicInteger> entry : scores.entrySet())
            if (entry.getKey().getId() == criteriaID)
                return entry.getValue();

        throw new IllegalArgumentException(String.format("No criteria is found for category [%s] with id: [%d]. scores: ", category, criteriaID, scores));
    }

    public int getCountForScore(int score) {
        
        int sum = 0;
        for (AtomicInteger currentScore : scores.values())
            if (currentScore.get() == score)
                sum++;
        
        return sum;
    }
    
}
