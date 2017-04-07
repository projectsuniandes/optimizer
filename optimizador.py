import numpy as np
from scipy.optimize import minimize, rosen, rosen_der

# DATOS

# constantes
num_max_creditos = 25
num_max_semestres = 20
num_materias = 4
# columnas ISIS1001 ISIS1002 MATE1001 FISI1001
requisitos = np.matrix([[0,0,0,0],
                        [1,0,0,0],
                        [0,0,0,0],
                        [0,0,0,0]])
# creditos
creditos = np.array([3,3,3,3])


# VARIABLES DE DECISION

# 1 = veo materia i en el semestre j, 0 = dlc
x_0 = np.zeros((num_materias, num_max_semestres), dtype=int)


# FUNCION OBJETIVO

# minimizar el numero de semestres (se pondera por el num de semestre para que le cueste escoger semestres viejos)
def funcion_objetivo(x_current):
    n = 0
    for j in range(num_max_semestres):
        cuantas_materias = 0
        for i in range(num_materias):
            cuantas_materias += x_current[i, j]
        n += cuantas_materias*(j**5)


# RESTRICCIONES

# una materia se aprueba solo una vez
def no_se_repite_materia(x_current):
    resultado = 0
    for i in range(num_materias):
        num_veces = 0
        for j in range(num_max_semestres):
            print(x_current)
            num_veces += x_current[i, j]
        if num_veces != 1:
            resultado += -1
    return resultado

# no se ven más de 25 creditos al semestre
def no_se_excede_creditos_maximos(x_current):
    resultado = 0
    for j in range(num_max_semestres):
        num_creditos = 0
        for i in range(num_materias):
            num_creditos += x_current[i, j]*creditos[i]
        if num_creditos > num_max_creditos:
            resultado += -1
    return resultado

# para cada materia se tuvieron que haber visto ya los prerrequisitos
def prerrequisitos(x_current):
    resultado = 0
    for i in range(num_materias):
        num_veces = 0
        for j in range(num_max_semestres):
            if x_current[i, j] == 1:
                for k in range(num_materias):
                    if requisitos[i,k] == 1:
                        num_veces_prerreq = 0
                        for l in range(0,j):
                            num_veces_prerreq += 1
                        if num_veces_prerreq != 1:
                            resultado += -1
    return resultado


# OPTIMIZADOR

restricciones = ({'type': 'eq', 'fun': no_se_repite_materia},
                 {'type': 'eq', 'fun': no_se_excede_creditos_maximos},
                 {'type': 'eq', 'fun': prerrequisitos})

sol = minimize(funcion_objetivo, x_0, method='Nelder-Mead', constraints=restricciones)
               #bounds = limites)

print(sol.x)
