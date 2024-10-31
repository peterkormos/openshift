package servlet;

import java.net.URL;
import java.util.LinkedList;
import java.util.List;

import javax.persistence.Column;

import org.apache.commons.math3.exception.MathIllegalArgumentException;
import org.apache.log4j.Logger;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;
import org.hibernate.service.ServiceRegistry;
import org.hibernate.service.ServiceRegistryBuilder;

import datatype.Record;
import datatype.judging.JudgingScore;

public class HibernateDAO
{
  private static SessionFactory sessionFactory;
  private final URL configFile;
  public static Logger logger = Logger.getLogger(HibernateDAO.class);

  protected Session getHibernateSession()
  {
	if (sessionFactory == null)
	{
	  Configuration configuration = new Configuration();
	  configuration.configure(configFile);

	  ServiceRegistry serviceRegistry = new ServiceRegistryBuilder().applySettings(configuration.getProperties())
		  .buildServiceRegistry();
	  sessionFactory = configuration.buildSessionFactory(serviceRegistry);
	}

	return sessionFactory.getCurrentSession();
  }

  protected void closeSession(Session session)
  {
	if ((session != null) && (session.isOpen()))
	{
	  session.close();
	}
  }

  public HibernateDAO(URL configFile)
  {
	this.configFile = configFile;
  }

  public void delete(int id, Class<? extends Record> recordClass)
  {
	Session session = null;

	try
	{
	  session = getHibernateSession();

	  session.beginTransaction();

	  session.delete(session.load(recordClass, new Integer(id)));

	  session.getTransaction().commit();
	}
	finally
	{
	  closeSession(session);
	}
  }

  public void delete(Record record)
  {
	  Session session = null;
	  
	  try
	  {
		  session = getHibernateSession();
		  
		  session.beginTransaction();
		  
		  session.delete(record);
		  
		  session.getTransaction().commit();
	  }
	  finally
	  {
		  closeSession(session);
	  }
  }
  
  public int getNextID(Class<? extends Record> recordClass)
  {
	Session session = null;

	try
	{
	  session = getHibernateSession();

	  session.beginTransaction();

	  Integer currentMaxvalue = (Integer) session.createQuery("select max(id) From " + recordClass.getSimpleName())
		  .uniqueResult();
	  return (currentMaxvalue == null ? 0 : currentMaxvalue) + 1;
	}
	finally
	{
	  closeSession(session);
	}
  }

  public <T> T get(int id, Class<T> recordClass)
  {
	Session session = null;

	try
	{
	  session = getHibernateSession();

	  session.beginTransaction();

	  T returned = (T) session.createQuery("From " + recordClass.getName() + " as r where r.id = ?")
		  .setInteger(0, id).uniqueResult();

	  if (returned == null)
	  {
		throw new IllegalArgumentException("No record is found with id: " + id);
	  }
	  
	  return returned;
	}
	finally
	{
	  closeSession(session);
	}
  }

  public <T> List<T> get(Class<T> recordClass, String whereClause)
  {
	  Session session = null;
	  
	  try
	  {
		  session = getHibernateSession();
		  
		  session.beginTransaction();
		  
		  List<T> returned = (List<T>) session.createQuery("From " + recordClass.getName() + " as r where " + whereClause)
				  .list();
		  
		  if (returned == null)
		  {
			  throw new IllegalArgumentException("No record is found with whereClause: " + whereClause);
		  }
		  
		  return returned;
	  }
	  finally
	  {
		  closeSession(session);
	  }
  }
  
  public <T> void delete(Class<T> recordClass, String setWhereClause)
  {
	  Session session = null;
	  
	  try
	  {
		  session = getHibernateSession();
		  session.beginTransaction();
		  session.createQuery("delete from " + recordClass.getName() + " where " + setWhereClause).executeUpdate();
	  }
	  finally
	  {
		  closeSession(session);
	  }
  }
  
  public <T> int count(Class<T> recordClass, String whereClause)
  {
	  Session session = null;
	  
	  try
	  {
		  session = getHibernateSession();
		  
		  session.beginTransaction();
		  
		  int returned = (int) session.createQuery("count(*) From " + recordClass.getName() + " as r where " + whereClause)
				  .uniqueResult();
		  
		  return returned;
	  }
	  finally
	  {
		  closeSession(session);
	  }
  }
  
  @SuppressWarnings("unchecked")
  public <T> List<T> getAll(Class<T> recordClass)
  {
	Session session = null;

	try
	{
	  session = getHibernateSession();

	  session.beginTransaction();

	  return new LinkedList<T>(session.createQuery("From " + recordClass.getSimpleName() + " order by id asc").list());
	}
	finally
	{
	  closeSession(session);
	}
  }

  public void save(Record record)
  {
	try
	{
	  get(record.getId(), record.getClass());
	  throw new IllegalArgumentException("M&aacute;r l&eacute;tez&#337; bejegyz&eacute;s! sorsz&aacute;m: <b>" + record.getId()
		  + "</b>");
	}
	catch (Exception e)
	{
	}

	Session session = null;
	try
	{
	  session = getHibernateSession();
	  session.beginTransaction();
	  session.saveOrUpdate(record);
	  session.getTransaction().commit();
	  
	  logger.debug(record);
	}
	finally
	{
	  closeSession(session);
	}
  }

  public void update(Record record) 
  {
	Session session = null;

	try
	{
	  session = getHibernateSession();

	  session.beginTransaction();

	  session.update(record);

	  session.getTransaction().commit();
	}
	finally
	{
	  closeSession(session);
	}
  }

  public void merge(Record record) throws Exception
  {
	Session session = null;

	try
	{
	  session = getHibernateSession();

	  session.beginTransaction();

	  session.merge(record);

	  session.getTransaction().commit();
	}
	finally
	{
	  closeSession(session);
	}
  }
}
