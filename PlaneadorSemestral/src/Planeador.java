import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;

import com.gams.api.GAMSGlobals;
import com.gams.api.GAMSJob;
import com.gams.api.GAMSOptions;
import com.gams.api.GAMSVariable;
import com.gams.api.GAMSVariableRecord;
import com.gams.api.GAMSWorkspace;

public class Planeador {

    public static void main(String[] args) {

       GAMSWorkspace ws = new GAMSWorkspace(); 
        GAMSJob t1 = ws.addJobFromGamsLib("trnsport");    
        t1.run(); 
        
        System.out.println("Ran with Default:");
        GAMSVariable x = t1.OutDB().getVariable("x");
        for (GAMSVariableRecord rec :  x) {
            System.out.print("x(" + rec.getKeys()[0] + ", " + rec.getKeys()[1] + "):");
            System.out.print(", level    = " + rec.getLevel());
            System.out.println(", marginal = " + rec.getMarginal());
        }
                
        GAMSOptions opt1 = ws.addOptions();
        opt1.setAllModelTypes("xpress"); 
        t1.run(opt1);
 
        System.out.println("Ran with XPRESS:"); 
        for (GAMSVariableRecord rec : t1.OutDB().getVariable("x")) {
            System.out.print("x(" + rec.getKeys()[0] + ", " + rec.getKeys()[1] + "):");
            System.out.print(", level    = " + rec.getLevel());
            System.out.println(", marginal = " + rec.getMarginal());
        }

        try {
            BufferedWriter optFile = new BufferedWriter(new FileWriter(ws.workingDirectory() + GAMSGlobals.FILE_SEPARATOR + "xpress.opt"));
            optFile.write("algorithm=barrier");
            optFile.close();
         } catch(IOException e) {
              e.printStackTrace();
              System.exit(-1);
         }

        GAMSOptions opt2 = ws.addOptions();
        opt2.setAllModelTypes( "xpress" );
        opt2.setOptFile(1);
        t1.run(opt2);
 
        System.out.println("Ran with XPRESS with non-default option:");
        for (GAMSVariableRecord rec : t1.OutDB().getVariable("x")) {
            System.out.print("x(" + rec.getKeys()[0] + ", " + rec.getKeys()[1] + "):");
            System.out.print(", level    = " + rec.getLevel());
            System.out.println(", marginal = " + rec.getMarginal());        	 
        }
    }
}
