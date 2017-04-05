*************************************************************************
***             Ejercicio 1     -     Parcial 2                       ***
*************************************************************************

Sets
   i   vehiculos / A, B, C, D/
   j   soldados / ingenieros, medicos, especiales, infanteria/

Table tabla(i,j) personas por vehiculo
        ingenieros medicos especiales infanteria
A       3          2       1          4
B       1          1       2          3
C       2          1       2          1
D       3          2       3          1

parameter totaltabla(i) numero de personas totales en cada vehiculo
         /A 10, B 7, C 6, D 9/;

parameter combustible(i) combustible cada vehiculo
         /A 160, B 80, C 40, D 120/;

parameter totalsoldados(j) numero de personas totales
         /ingenieros 50, medicos 36, especiales 22, infanteria 120/;

Variables
  cuantos(i)            cuantos vehiculos de cada tipo
  z                     minimizar combustible;

Integer Variable cuantos;

Equations
FunObj              Funcion Objetivo
res1(j)             restricción 1 vehiculos llevan mas del total de gente;

FunObj       ..  z =e= sum((i), cuantos(i)*combustible(i));

res1(j)      ..  sum((i), cuantos(i)*tabla(i,j)) =g= totalsoldados(j);



Model modelo1 /all/ ;
option mip=CPLEX;
Solve modelo1 using mip minimizing z;

Display z.l
Display cuantos.l
