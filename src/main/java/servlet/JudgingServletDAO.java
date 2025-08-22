package servlet;

import java.net.URL;
import java.util.LinkedList;
import java.util.List;
import java.util.Optional;

import org.hibernate.Query;
import org.hibernate.Session;

import datatype.judging.JudgingCategoryToSheetMapping;
import datatype.judging.JudgingCriteria;
import datatype.judging.JudgingScore;

public class JudgingServletDAO extends HibernateDAO {
    public JudgingServletDAO(URL configFile) {
        super(configFile);
    }

    @SuppressWarnings("unchecked")
	public List<JudgingCriteria> getJudgingCriteria(int categoryId) throws Exception
    {
        Session session = null;
        
        try
        {
            session = getHibernateSession();
            
            session.beginTransaction();

            Query query = session.createQuery(
"select s.criterias from JudgingCategoryToSheetMapping c join c.judgingSheet s where c.categoryId = :categoryId");
            query.setInteger("categoryId", categoryId);
            
          return new LinkedList<JudgingCriteria>(query.list());
        }
        finally
        {
            closeSession(session);
        }
    }

    @SuppressWarnings("unchecked")
	public Optional<JudgingCategoryToSheetMapping> getJudgingCategory(int categoryId) throws Exception
    {
        Session session = null;
        
        try
        {
            session = getHibernateSession();
            
            session.beginTransaction();

            Query query = session.createQuery(
"select c from JudgingCategoryToSheetMapping c where c.categoryId = :categoryId");
            query.setInteger("categoryId", categoryId);
            
          return Optional.ofNullable((JudgingCategoryToSheetMapping)query.uniqueResult());
        }
        finally
        {
            closeSession(session);
        }
    }

    @SuppressWarnings("unchecked")
	public List<JudgingCategoryToSheetMapping> getJudgingCategories() throws Exception {
		Session session = null;
		try {
			session = getHibernateSession();
			session.beginTransaction();
			Query query = session.createQuery("from JudgingCategoryToSheetMapping");
			return (List<JudgingCategoryToSheetMapping>) query.list();
		} finally {
			closeSession(session);
		}
	}

    @SuppressWarnings("unchecked")
    public List<JudgingScore> getJudgingScores(String judge, String category, int modelId, int modellerId) throws Exception
    {
        Session session = null;
        
        try
        {
            session = getHibernateSession();
            
            session.beginTransaction();

            Query query = session.createQuery("From JudgingScore js join fetch js.criteria where js.judge = :judge and js.category = :category and js.modelID = :modelId and js.modellerID = :modellerId order by js.id asc");
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

    public List<String> getJudges(String category, int modelId, int modellerId) throws Exception
    {
        Session session = null;
        
        try
        {
            session = getHibernateSession();
            
            session.beginTransaction();

            Query query = session.createQuery("select distinct judge From JudgingScore where category = :category and modelID = :modelId and modellerID = :modellerId order by judge");
            query.setString("category", category);
            query.setInteger("modelId", modelId);
            query.setInteger("modellerId", modellerId);
            
          return new LinkedList<String>(query.list());
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

	@SuppressWarnings("unchecked")
	public List<JudgingScore> getAllJudgingScores() {
		Session session = null;
		try {
			session = getHibernateSession();
			session.beginTransaction();

			Query query = session.createQuery(
					"From JudgingScore js join fetch js.criteria order by js.id asc");

			return query.list();
		} finally {
			closeSession(session);
		}
	}
    
}
