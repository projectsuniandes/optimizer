
import java.io.*;



public class Planeador {
	
	public int maxCreditos;
	public int maxSemestres;
	
	public Planeador(int maxCreditos1, int maxSemestres1){
		maxCreditos=maxCreditos1;
		maxSemestres=maxSemestres1;
		escribir();
	}

	public void escribir(){
		PrintWriter printWriter = null;
		System.out.println("llega");
		try{
			File direccion = new File("./Docs/file.gms");
			printWriter = new PrintWriter(direccion);
			printWriter.println("$Set NUM_MAX_CREDITOS "+ maxCreditos);
			printWriter.println("$Set NUM_MAX_SEMESTRES "+ maxSemestres);
			printWriter.println("Sets");
			printWriter.println("materias_i   materias por codigo / ISIS1001, ISIS1002, ISIS1003, FISI1002, MATE1001, MATE1002 /");
			printWriter.println("semestres_j  semestres /s1*s%NUM_MAX_SEMESTRES% /");
			printWriter.println("alias(materias_i, materias_k)");
			printWriter.println("alias(semestres_j, semestres_l)");
			printWriter.println("Table requisitos(materias_i, materias_k) vale 0 si no hay req 1 si hay pre de i a j y 2 si es correq");
			//Matriz
			printWriter.println("         ISIS1001 ISIS1002 ISIS1003 FISI1002 MATE1001 MATE1002");
			printWriter.println("ISIS1001 0        0        0        0        0        0");
			printWriter.println("ISIS1002 1        0        0        0        0        0");
			printWriter.println("ISIS1003 0        1        0        0        0        0");
			printWriter.println("FISI1002 0        0        0        0        1        0");
			printWriter.println("MATE1001 0        0        0        0        0        0");
			printWriter.println("MATE1002 0        0        0        0        1        0");
			
			printWriter.println("Parameter creditos(materias_i) num de creditos de cada materia / ISIS1001 3, ISIS1002 3, ISIS1003 3, FISI1002 3, MATE1001 3, MATE1002 3 /;");
			printWriter.println("Variables");
			printWriter.println("x(materias_i, semestres_j)        vale 1 si veo la materia_i en el semestre_j");
			printWriter.println("n                                 numero minimo de semestres;");
			printWriter.println("Binary Variable x;");
			printWriter.println("Equations");
			printWriter.println("funcion_objetivo                                         funcion objetivo");
			printWriter.println("no_repitis_materia(materias_i)                           una materia se aprueba solo una vez");
			printWriter.println("creditos_maximos(semestres_j)                            numero maximo de creditos al semestres");
			printWriter.println("prerrequisitos(materias_i, materias_k, semestres_j)      prereqs se deben cumplir");
			printWriter.println("prerrequisitos_prim(materias_i, materias_k, semestres_j) no se puede ver una materia que tenga prerequisito en primer semestre;");
			printWriter.println("funcion_objetivo                                 ..      n =E= sum((semestres_j), (sum((materias_i), x(materias_i, semestres_j)))*power(ord(semestres_j),5) );");
			printWriter.println("no_repitis_materia(materias_i)                   ..      sum( (semestres_j), x(materias_i, semestres_j) ) =E= 1;");
			printWriter.println("creditos_maximos(semestres_j)                    ..      sum( (materias_i), x(materias_i, semestres_j)*creditos(materias_i) ) =L= %NUM_MAX_CREDITOS%;");
			printWriter.println("prerrequisitos(materias_i, materias_k, semestres_j)$(requisitos(materias_i, materias_k) eq 1 and ord(semestres_j) ge 2)       ..      sum( semestres_l$(ord(semestres_l) ge 2 and ord(semestres_l) le ord(semestres_j)), x(materias_i, semestres_l)) =E= sum( semestres_l$(ord(semestres_l) ge 1 and ord(semestres_l) le ord(semestres_j)-1), x(materias_k, semestres_l) );");
			printWriter.println("prerrequisitos_prim(materias_i, materias_k, semestres_j)$(requisitos(materias_i, materias_k) eq 1 and ord(semestres_j) eq 1)  ..      x(materias_i, semestres_j) =E= 0;");
			printWriter.println("Model modelo /all/ ;");
			printWriter.println("option mip=CBC;");
			printWriter.println("Solve modelo using mip minimizing n;");
			printWriter.println("file GAMSresults /C:/Users/laura/Documentos/resultados.txt");
			printWriter.println("put GAMSresults;");
			printWriter.println("loop((materias_i,semestres_j)$(x.l(materias_i, semestres_j) eq 1), put materias_i.tl, @12, semestres_j.tl /);");
			printWriter.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
		
	
		
	}
    public static void main(String[] args) {
    	Planeador plan = new Planeador(3,4);
    

    }
}
