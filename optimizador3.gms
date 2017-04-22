*************************************************************************
***                         PROYECTO MSO                              ***
*************************************************************************

$Set NUM_MAX_CREDITOS 25
$Set NUM_MAX_SEMESTRES 3

Sets
   semestres_j  semestres /s1*s%NUM_MAX_SEMESTRES% /
   semestres_j1(semestres_j) semestres del j al 1 /s1/
   semestres_j2(semestres_j) semestres del j al 2 /s1*s2/
   semestres_j3(semestres_j) semestres del j al 3 /s1*s3/

   materias_i   materias por codigo / ISIS1001, ISIS1002, MATE1001 /
   alias(materias_i, materias_k)
   alias(semestres_j, semestres_l)

Table requisitos(materias_i, materias_k) vale 0 si no hay req 1 si hay pre de i a j y 2 si es correq
               ISIS1001   ISIS1002  MATE1001
ISIS1001       0          1         0
ISIS1002       0          0         0
MATE1001       0          0         0

parameter creditos(materias_i) num de creditos de cada materia
         /ISIS1001 3, ISIS1002 3, MATE1001 3/;


Variables
  x(materias_i, semestres_j)        vale 1 si veo la materia_i en el semestre_j
  n                                 numero minimo de semestres;

Binary Variable x;

Equations
FunObj                                     Funcion Objetivo

no_repitis_materia(materias_i)             una materia se aprueba solo una vez
creditos_maximos(semestres_j)              numero maximo de creditos al semestres
*prerrequisitos_s2(materias_i, materias_k, semestres_j2)    prereqs
*prerrequisitos_s3(materias_i, materias_k, semestres_j3)    prereqs;
prerrequisitos(materias_i, materias_k, semestres_j)    prereqs;
*prerrequisitos32(materias_i, materias_k, semestres_j)    prereqs
*prerrequisitos0(materias_i, materias_k, semestres_j)    prereqs;


FunObj                                          ..      n =E= sum((semestres_j), (sum((materias_i), x(materias_i, semestres_j)))*power(ord(semestres_j),5) );

no_repitis_materia(materias_i)                  ..      sum( (semestres_j), x(materias_i, semestres_j) ) =E= 1;
creditos_maximos(semestres_j)                   ..      sum( (materias_i), x(materias_i, semestres_j)*creditos(materias_i) ) =L= %NUM_MAX_CREDITOS%;

*prerrequisitos_s2(materias_i, materias_k, semestres_j2)         ..      x(materias_i, semestres_j2) + requisitos(materias_k, materias_i) =l= sum((semestres_j1), x(materias_k, semestres_j1));
*prerrequisitos_s3(materias_i, materias_k, semestres_j3)         ..      x(materias_i, semestres_j3) + requisitos(materias_k, materias_i) =l= sum((semestres_j2), x(materias_k, semestres_j2));

prerrequisitos(materias_i, materias_k, semestres_j)$(ord(semestres_j) ge 2)         ..      x(materias_i, semestres_j)*requisitos(materias_k, materias_i) =E= sum( semestres_l$(ord(semestres_l) ge 1 and ord(semestres_l) le ord(semestres_j)-1), x(materias_k, semestres_l) );
*prerrequisitos32(materias_i, materias_k, semestres_j)$(ord(semestres_j) ge 2 and 2*x(materias_i, semestres_j) + x(materias_i, semestres_j)*requisitos(materias_k, materias_i) ne 0)         ..      2*x(materias_i, semestres_j) + x(materias_i, semestres_j)*requisitos(materias_k, materias_i) - 2 =L= sum( semestres_l$(ord(semestres_l) ge 1 and ord(semestres_l) le ord(semestres_j)-1), x(materias_k, semestres_l) );
*prerrequisitos32(materias_i, materias_k, semestres_j)$(ord(semestres_j) ge 2 and 2*x(materias_i, semestres_j) + x(materias_i, semestres_j)*requisitos(materias_k, materias_i) eq 0)         ..      2*x(materias_i, semestres_j) + x(materias_i, semestres_j)*requisitos(materias_k, materias_i) =L= sum( semestres_l$(ord(semestres_l) ge 1 and ord(semestres_l) le ord(semestres_j)-1), x(materias_k, semestres_l) );



Model modelo /all/ ;
option mip=CPLEX;
option Limrow=20
Solve modelo using mip minimizing n;

Display n.l
Display x.l
