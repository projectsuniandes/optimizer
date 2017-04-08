*************************************************************************
***                         PROYECTO MSO                              ***
*************************************************************************

$Set NUM_MAX_CREDITOS 25
$Set NUM_MAX_SEMESTRES 4

Sets
   semestres_j  semestres /s1*s%NUM_MAX_SEMESTRES% /
   semestres_j1(semestres_j) semestres del j al 1 /s1/
   semestres_j2(semestres_j) semestres del j al 2 /s1*s2/
   semestres_j3(semestres_j) semestres del j al 3 /s1*s3/
   semestres_j4(semestres_j) semestres del j al 4 /s1*s4/

   materias_i   materias por codigo / ISIS1001, ISIS1002, MATE1001, FISI1001 /
   alias(materias_i, materias_k)

Table requisitos(materias_i, materias_k) vale 0 si no hay req 1 si hay pre de i a j y 2 si es correq
               ISIS1001   ISIS1002  MATE1001   FISI1001
ISIS1001       0          1         0          0
ISIS1002       0          0         0          0
MATE1001       0          0         0          2
FISI1001       0          0         0          0

parameter creditos(materias_i) num de creditos de cada materia
         /ISIS1001 3, ISIS1002 3, MATE1001 3, FISI1001 3/;


Variables
  x(materias_i, semestres_j)        vale 1 si veo la materia_i en el semestre_j
  n                                 numero minimo de semestres;

Binary Variable x;

Equations
FunObj                                     Funcion Objetivo

no_repitis_materia(materias_i)             una materia se aprueba solo una vez
creditos_maximos(semestres_j)              numero maximo de creditos al semestres
prerrequisitos_s2(materias_i)              prereqs
prerrequisitos_s3(materias_i)              prereqs
prerrequisitos_s4(materias_i)              prereqs;



FunObj                                          ..      n =e= sum((semestres_j), (sum((materias_i), x(materias_i, semestres_j)))*power(ord(semestres_j),5) );

no_repitis_materia(materias_i)                  ..      sum( (semestres_j), x(materias_i, semestres_j) ) =e= 1;
creditos_maximos(semestres_j)                   ..      sum( (materias_i), x(materias_i, semestres_j)*creditos(materias_i) ) =l= %NUM_MAX_CREDITOS%;

prerrequisitos_s2(materias_i)                   ..      x(materias_i, 's2')*sum((materias_k), requisitos(materias_i, materias_k)) =e= sum( (materias_k), abs(sqr(requisitos(materias_i, materias_k)-1) - 1) * sum((semestres_j1), x(materias_k, semestres_j1)) );
prerrequisitos_s3(materias_i)                   ..      x(materias_i, 's3')*sum((materias_k), requisitos(materias_i, materias_k)) =e= sum( (materias_k), abs(sqr(requisitos(materias_i, materias_k)-1) - 1) * sum((semestres_j2), x(materias_k, semestres_j2)) );
prerrequisitos_s4(materias_i)                   ..      x(materias_i, 's4')*sum((materias_k), requisitos(materias_i, materias_k)) =e= sum( (materias_k), abs(sqr(requisitos(materias_i, materias_k)-1) - 1) * sum((semestres_j3), x(materias_k, semestres_j3)) );


Model modelo /all/ ;
option mip=CPLEX;
Solve modelo using mip minimizing n;

Display n.l
Display x.l
