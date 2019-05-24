package datatype.judging;

import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Map.Entry;
import java.util.concurrent.atomic.AtomicInteger;

public class JudgingResult extends JudgedModel{
    private String category;
    private String judge;

    // value:count
    private final Map<Integer, AtomicInteger> scores = new LinkedHashMap<Integer, AtomicInteger>();

    public JudgingResult(JudgingScore result) {
        super(result);
        
        this.category = result.getCategory();
        this.judge = result.getJudge();
    }


    @Override
    public String toString() {
        return "JudgingResult [category=" + category + ", judge=" + judge + ", scores=" + scores + ", " + super.toString() + "]";
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

    public Map<Integer, AtomicInteger> getScores() {
        return scores;
    }

    public int getMaxScore() {
        int maxScore = 0;

        for (Integer score : scores.keySet())
            if (score.intValue() > maxScore)
                maxScore = score.intValue();

        return maxScore;
    }

    public int getCountForScore(int score) {
        try 
        {
            return scores.get(score).get();
        } 
        catch (Exception e) 
        {
            return 0;
        }
    }
    
}
