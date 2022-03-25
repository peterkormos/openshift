package datatype.judging;

import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Map.Entry;
import java.util.concurrent.atomic.AtomicInteger;

public class JudgingResult extends JudgedModel{
    private String category;
    private String judge;

    // value:count
    private final Map<Integer, AtomicInteger> scoresSummary = new LinkedHashMap<Integer, AtomicInteger>();
    private int maxScore;
    
    public int getMaxScore() 
    {
        return maxScore;
    }

    public void setMaxScore(int maxScore) 
    {
        this.maxScore = maxScore;
    }


    public JudgingResult(JudgingScore result) {
        super(result);
        
        this.category = result.getCategory();
        this.judge = result.getJudge();
    }


    @Override
    public String toString() {
        return "JudgingResult [category=" + category + ", judge=" + judge + ", scores=" + scoresSummary + ", " + super.toString() + "]";
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

    public Map<Integer, AtomicInteger> getScoresSummary() {
        return scoresSummary;
    }

    public int getTotalScores() {
        return getScoresSummary().values().stream().mapToInt(AtomicInteger::get).sum();
    }

    public int getCountForScore(int score) {
        try 
        {
            return scoresSummary.get(score).get();
        } 
        catch (Exception e) 
        {
            return 0;
        }
    }

	public void saveScores(JudgingScore score) {
        try {
        	scoresSummary.get(score.getScore()).incrementAndGet();
        } catch (Exception e) {
        	scoresSummary.put(score.getScore(), new AtomicInteger(1));
        }

		score.getScore()
		// TODO Auto-generated method stub
		
	}
    
}
