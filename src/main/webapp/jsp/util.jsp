<%!
  boolean highlightFlag;
  long highlightStart = 0xEAEAEA;

  public final String highlight()
  {
	  return highlight(false);
  }
  
  public final String highlight(boolean alert)
  {
	try
	{
		if(alert) {
			return Long.toHexString(0xfc8981); //red
		}
		
	  if (highlightFlag)
		return Long.toHexString(highlightStart);
	  else
	  {
		return Long.toHexString(Math.min(highlightStart + 0xF6F4F0, 0xffffff));
	  }
	}
	finally
	{
	  highlightFlag = !highlightFlag;
	}
  }

%>