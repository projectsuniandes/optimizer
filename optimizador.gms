*************************************************************************
***                         PROYECTO MSO                              ***
*************************************************************************

$Set NUM_MAX_CREDITOS 25
$Set NUM_MAX_SEMESTRES 20

Sets
   materias_i   materias por codigo / ISIS1001, ISIS1002, ISIS1003, FISI1002, MATE1001, MATE1002 /
   semestres_j  semestres /s1*s%NUM_MAX_SEMESTRES% /

   alias(materias_i, materias_k)
   alias(semestres_j, semestres_l)


Table requisitos(materias_i, materias_k) vale 0 si no hay req 1 si hay pre de i a j y 2 si es correq
         ISIS1001 ISIS1002 ISIS1003 FISI1002 MATE1001 MATE1002
ISIS1001 0        0        0        0        0        0
ISIS1002 1        0        0        0        0        0
ISIS1003 0        1        0        0        0        0
FISI1002 0        0        0        0        1        0
MATE1001 0        0        0        0        0        0
MATE1002 0        0        0        0        1        0


Parameter creditos(materias_i) num de creditos de cada materia / ISIS1001 3, ISIS1002 3, ISIS1003 3, FISI1002 3, MATE1001 3, MATE1002 3 /;


Variables
   x(materias_i, semestres_j)        vale 1 si veo la materia_i en el semestre_j
   n                                 numero minimo de semestres;

Binary Variable x;


Equations
funcion_objetivo                                         funcion objetivo
no_repitis_materia(materias_i)                           una materia se aprueba solo una vez
creditos_maximos(semestres_j)                            numero maximo de creditos al semestres
prerrequisitos(materias_i, materias_k, semestres_j)      prereqs se deben cumplir
prerrequisitos_prim(materias_i, materias_k, semestres_j) no se puede ver una materia que tenga prerequisito en primer semestre;


funcion_objetivo                                 ..      n =E= sum((semestres_j), (sum((materias_i), x(materias_i, semestres_j)))*power(ord(semestres_j),5) );

no_repitis_materia(materias_i)                   ..      sum( (semestres_j), x(materias_i, semestres_j) ) =E= 1;

creditos_maximos(semestres_j)                    ..      sum( (materias_i), x(materias_i, semestres_j)*creditos(materias_i) ) =L= %NUM_MAX_CREDITOS%;

prerrequisitos(materias_i, materias_k, semestres_j)$(requisitos(materias_i, materias_k) eq 1 and ord(semestres_j) ge 2)       ..      sum( semestres_l$(ord(semestres_l) ge 2 and ord(semestres_l) le ord(semestres_j)), x(materias_i, semestres_l)) =E= sum( semestres_l$(ord(semestres_l) ge 1 and ord(semestres_l) le ord(semestres_j)-1), x(materias_k, semestres_l) );

prerrequisitos_prim(materias_i, materias_k, semestres_j)$(requisitos(materias_i, materias_k) eq 1 and ord(semestres_j) eq 1)  ..      x(materias_i, semestres_j) =E= 0;


Model modelo /all/ ;
option mip=CBC;
option Limrow=20
Solve modelo using mip minimizing n;


Display n.l
Display x.l
