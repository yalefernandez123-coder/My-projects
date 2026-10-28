install.packages("RANN")
#Cargar Caret
library(caret)
library(RANN)

# Leer archivo
datos <- read.csv("Social_Network_Ads.csv")

salarios_originales <- datos$EstimatedSalary

# CREAR 20 SALARIOS FALTANTES

set.seed(123)

filas <- sample(
  which(!is.na(datos$EstimatedSalary)),
  20
)

datos$EstimatedSalary[filas] <- NA_real_

# Verificar valores faltantes

colSums(is.na(datos))

# 3. PREPARAR LOS DATOS


# Seleccionar variables numericas
datos_knn <- datos[, c("Age", "EstimatedSalary")]

# Conservar registros completos

datos_completos <- na.omit(datos_knn)


# 4. CREAR 5 FOLDS

set.seed(123)

folds <- createFolds(
  datos_completos$EstimatedSalary,
  k = 5,
  returnTrain = FALSE
)

# Valores de K a evaluar
valores_k <- c(1, 3, 5, 7, 9, 11, 13, 15)

# Tabla para guardar resultados
resultados <- data.frame(
  k = valores_k,
  RMSE = NA_real_
)

# 5. VALIDACION CRUZADA K-FOLD
# ==========================================

for (i in seq_along(valores_k)) {
  
  errores <- c()
  
  for (fold in folds) {
    
    # Separar entrenamiento y prueba
    entrenamiento <- datos_completos[-fold, ]
    prueba <- datos_completos[fold, ]
    
    # Guardar salarios reales
    salarios_reales <- prueba$EstimatedSalary
    
    # Preparar imputacion KNN
    prep <- preProcess(
      entrenamiento,
      method = "knnImpute",
      k = valores_k[i]
    )
    
    # Ocultar salarios de prueba
    prueba$EstimatedSalary <- NA_real_
    
    # Imputar salarios
    imputados <- predict(prep, prueba)
    
    # Revertir estandarizacion del salario
    salarios_estimados <-
      imputados$EstimatedSalary *
      prep$std["EstimatedSalary"] +
      prep$mean["EstimatedSalary"]
    
    # Calcular RMSE
    error <- sqrt(mean(
      (salarios_reales - salarios_estimados)^2
    ))
    
    errores <- c(errores, error)
  }
  
  # RMSE promedio de los 5 folds
  resultados$RMSE[i] <- mean(errores)
}

# MOSTRAR RESULTADOS
# ==========================================

print(resultados)

# Seleccionar K con menor RMSE
mejor_k <- resultados$k[
  which.min(resultados$RMSE)
]

cat("El mejor valor de K es:", mejor_k)

# 7. GRAFICAR RESULTADOS
# ==========================================

ggplot(resultados, aes(x = k, y = RMSE)) +
  geom_line(color = "blue") +
  geom_point(color = "red", size = 3) +
  labs(
    title = "Validacion cruzada K-Fold",
    x = "Numero de vecinos (K)",
    y = "RMSE promedio"
  ) +
  theme_minimal()

 #IMPUTACION DEFINITIVA
# ==========================================

# Preparar KNN con el mejor K
prep_final <- preProcess(
  datos_completos,
  method = "knnImpute",
  k = mejor_k
)

# Imputar los 20 salarios faltantes
imputados_final <- predict(
  prep_final,
  datos_knn
)

# Revertir estandarizacion
salarios_finales <-
  imputados_final$EstimatedSalary *
  prep_final$std["EstimatedSalary"] +
  prep_final$mean["EstimatedSalary"]

# Reemplazar solo los salarios faltantes
datos$EstimatedSalary[filas] <-
  salarios_finales[filas]

# Verificar que no queden NA
sum(is.na(datos$EstimatedSalary))


# ==========================================
# 9. COMPARAR SALARIOS
# ==========================================

comparacion <- data.frame(
  Fila = filas,
  Salario_Real = salarios_originales[filas],
  Salario_Imputado = datos$EstimatedSalary[filas]
)

print(comparacion)

# EVALUAR IMPUTACION FINAL
# ==========================================

rmse_final <- sqrt(mean(
  (comparacion$Salario_Real -
     comparacion$Salario_Imputado)^2
))

cat("RMSE de los 20 salarios:", rmse_final)

