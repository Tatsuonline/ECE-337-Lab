import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.Iterator;
import java.util.List;
import java.util.ArrayList;
import java.lang.*;

public class float_to_fixed
{  

  public static void main(String[] args)
  {
BufferedReader br = null;
 
		try {
 
			String cur;
			int i=0;

			br = new BufferedReader(new FileReader(args[0]));
 
			while ((cur = br.readLine()) != null) 
			{
			    
			    String [] parts=cur.split(" ");
			    if(parts.length != 1 && parts.length < 3)			 
				{
				    float a=0;
				    int b=0;
				    a=Math.abs(Float.parseFloat(parts[1]));
				    a=a*1000000;
				    System.out.println((int)a);
				}
			}
 
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			try {
				if (br != null)br.close();
			} catch (IOException ex) {
				ex.printStackTrace();
			}
		}
  }

  
}

//version 1.0 13:20 9/1 