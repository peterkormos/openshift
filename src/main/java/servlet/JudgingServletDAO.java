package servlet;

import java.net.URL;
import java.util.LinkedList;
import java.util.List;

import org.hibernate.Query;
import org.hibernate.Session;

import datatype.judging.JudgingScore;

public class JudgingServletDAO extends HibernateDAO {
    public JudgingServletDAO(URL configFile) {
        super(configFile);
    }

    @SuppressWarnings("unchecked")
    public List<JudgingScore> getJudgingScores(String judge, String category, int modelId, int modellerId) throws Exception
    {
        Session session = null;
        
        try
        {
            session = getHibernateSession();
            
            session.beginTransaction();

            Query query = session.createQuery("From JudgingScore where judge = :judge and category = :category and modelID = :modelId and modellerID = :modellerId order by id asc");
            query.setString("judge", judge);
            query.setString("category", category);
            query.setInteger("modelId", modelId);
            query.setInteger("modellerId", modellerId);
            
          return new LinkedList<JudgingScore>(query.list());
        }
        finally
        {
            closeSession(session);
        }
    }

    public void deleteJudgingScores(String judge, String category, int modelId, int modellerId) throws Exception
    {
        Session session = null;
        
        try
        {
            session = getHibernateSession();
            
            session.beginTransaction();
            
            Query query = session.createQuery("delete JudgingScore where judge = :judge and category = :category and modelID = :modelId and modellerID = :modellerId");
            query.setString("judge", judge);
            query.setString("category", category);
            query.setInteger("modelId", modelId);
            query.setInteger("modellerId", modellerId);
            
            query.executeUpdate();
            session.getTransaction().commit();
        }
        finally
        {
            closeSession(session);
        }
    }
    
}
