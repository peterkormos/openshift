package datatype.judging;

import java.util.Arrays;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicInteger;

import datatype.Model;

public class JudgingResult extends JudgedModel{
    private String category;
    private String judge;

    // value:count
    private final Map<Integer, AtomicInteger> scoresSummary = new LinkedHashMap<Integer, AtomicInteger>();
    private int maxScore;
    
    //criteriaID, JudgingScore
    private Map<Integer, JudgingScore> scores = new HashMap<>();
	private List<JudgingCriteria> criterias;
    
    public int getMaxScore() 
    {
        return maxScore == 0 ? JudgingCriteria.getDefault().getMaxScore() : maxScore;
    }

    public void setMaxScore(int maxScore) 
    {
        this.maxScore = maxScore;
    }


    public JudgingResult(final int id, JudgingScore result) {
        super(id, result);
        
        this.category = result.getCategory();
        this.judge = result.getJudge();
    }

    public JudgingResult(final int id, Model model) {
        super(id, model);
    }

    public JudgingResult() {
    }
    
    public boolean isModelPresent() {
    	return getModelID() != 0;
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

        scores.put(score.getCriteriaID(), score);

        if(score.getCriteria().getMaxScore() > getMaxScore()) {
        	setMaxScore(score.getCriteria().getMaxScore());
        }
	}

	public List<JudgingCriteria> getCriterias() {
		return criterias;
	}
	
	public void setCriterias(List<JudgingCriteria> criterias) {
	    if (criterias.isEmpty())
	    	this.criterias = Arrays.asList(JudgingCriteria.getDefault());
	    else
	    	this.criterias = criterias;
	}
	
	public Map<Integer, JudgingScore> getScores() {
		return scores;
	}
}
