# ============================================================
# PREPROCESAMIENTO DE DATOS
# ============================================================
# Objetivo: dejar los datos listos para un modelo, pasando por los pasos
# típicos de preprocesamiento: detectar y corregir datos faltantes,
# codificar variables categóricas, y escalar las variables numéricas.
#
# Qué vamos a hacer, paso a paso:
#   1. Cargar los datos
#   2. Detectar datos faltantes
#   3. Imputar los datos faltantes (reemplazarlos por la media)
#   4. Codificar la variable categórica Country (factor + dummy/one-hot) y
#      reemplazarla en el dataset por esas columnas dummy
#   5. Codificar la variable objetivo Purchased como 0/1
#   6. Dividir en entrenamiento y prueba
#   7. Comparar estandarización vs. normalización (ejemplo de referencia)
#   8. Escalar Age y Salary para el modelo (sin fuga de datos)
# ============================================================

# Librerías
#install.packages(c("caTools", "caret"))
library(caTools)  # nos sirve para dividir el dataset en entrenamiento/prueba
library(caret)    # nos da preProcess(): estandarizar/normalizar con funciones ya hechas


# ------------------------------------------------------------
# PASO 1: Cargar los datos
# ------------------------------------------------------------
dataset <- read.csv("data_preprocessing.csv")
dataset


# ------------------------------------------------------------
# PASO 2: Detectar datos faltantes
# ------------------------------------------------------------
# colSums(is.na(...)) cuenta cuántos NA hay por columna.
colSums(is.na(dataset))


# ------------------------------------------------------------
# PASO 3: Imputar los datos faltantes (por la media)
# ------------------------------------------------------------
# TODO: reemplaza los NA de Age por la media de esa columna, y los NA de
# Salary por la media de Salary. Pista:
#   dataset$Age[is.na(dataset$Age)] <- mean(dataset$Age, na.rm = TRUE)


dataset$Age[is.na(dataset$Age)] <- mean(dataset$Age, na.rm = TRUE)
dataset$Salary[is.na(dataset$Salary)] <- mean(dataset$Salary, na.rm = TRUE)
colSums(is.na(dataset))  # debe quedar en 0


# ------------------------------------------------------------
# PASO 4: Codificar la variable categórica 'Country'
# ------------------------------------------------------------
# TODO: declara dataset$Country como factor con factor()

dataset$Country<- factor(dataset$Country)

levels(dataset$Country)

# TODO: crea la codificación dummy/one-hot con model.matrix() y guárdala en
# una variable llamada country_dummies. Pista:
#   model.matrix(~ Country - 1, data = dataset)
# (cada categoría de Country debe quedar como su propia columna binaria 0/1)

country_dummies<- model.matrix(~ Country - 1, data = dataset)

head(country_dummies)

# TODO: ahora hay que USARLAS. Reemplaza la columna de texto Country por
# sus columnas dummy en el dataset, con cbind(). Pista:
#   dataset <- cbind(
#     as.data.frame(country_dummies),
#     dataset[, c("Age", "Salary", "Purchased")]
#   )

dataset <- cbind(
       as.data.frame(country_dummies),
       dataset[, c("Age", "Salary", "Purchased")]
     )

head(dataset)  # ya no debería quedar columna Country de texto


# ------------------------------------------------------------
# PASO 5: Codificar la variable objetivo 'Purchased' como 0/1
# ------------------------------------------------------------
dataset$Purchased <- factor(
  dataset$Purchased,
  levels = c("No", "Yes"),
  labels = c(0, 1)
)

head(dataset)
# ------------------------------------------------------------
# PASO 6: Dividir en entrenamiento y prueba
# ------------------------------------------------------------
# El modelo "aprende" con el training_set y se evalúa con el testing_set,
# datos que nunca vio durante el entrenamiento.

set.seed(123)  
split <- sample.split(dataset$Purchased, SplitRatio = 0.8)
split

training_set <- subset(dataset, split == TRUE)
testing_set  <- subset(dataset, split == FALSE)


# ------------------------------------------------------------
# PASO 7: Estandarización vs. normalización (ejemplo de referencia)
# ------------------------------------------------------------
# Estandarización (z-score): z = (x - media) / desviación_estándar
# Normalización (min-max):   x_norm = (x - min) / (max - min)
#
# En vez de escribir las fórmulas a mano, usa preProcess() de la librería
# caret: "aprende" los parámetros de una columna, y predict() los aplica.
#
# TODO:
prep_estandar <- preProcess(training_set["Age"], method = c("center","scale"))
prep_normal   <- preProcess(training_set["Age"], method = "range")
#   3) arma un data.frame llamado comparacion_age con tres columnas:
#        original      -> training_set$Age
#        estandarizada -> predict(prep_estandar, training_set["Age"])$Age
#        normalizada   -> predict(prep_normal, training_set["Age"])$Age

comparacion_age <- data.frame(
  original      = training_set$Age,                              # valores crudos
  estandarizada = predict(prep_estandar, training_set["Age"])$Age, # z-score (media 0, sd 1)
  normalizada   = predict(prep_normal, training_set["Age"])$Age    # min-max (entre 0 y 1)
)
head(comparacion_age)






# ------------------------------------------------------------
# PASO 8: Escalar Age y Salary para el modelo (sin fuga de datos)
# ------------------------------------------------------------
# Regla de oro: los parámetros de escalado se calculan UNA sola vez, con el
# training_set, y ese mismo objeto preProcess se reutiliza para escalar el
# testing_set. Si se calculan de nuevo sobre el testing_set, el modelo
# estaría "viendo" indirectamente información que no debería ver todavía
# (esto se llama fuga de datos / data leakage).
#
# TODO:
#   1) prep_escalado <- preProcess(training_set[, c("Age","Salary")],
#        method = c("center", "scale"))
#   2) training_set[, c("Age","Salary")] <- predict(prep_escalado, training_set[, c("Age","Salary")])
#   3) testing_set[, c("Age","Salary")]  <- predict(prep_escalado, testing_set[, c("Age","Salary")])
#      (NO crees un prep_escalado nuevo con el testing_set)

prep_escalado <- preProcess(training_set[, c("Age","Salary")],
     method = c("center", "scale"))
training_set[, c("Age","Salary")] <- predict(prep_escalado, training_set[, c("Age","Salary")])
testing_set[, c("Age","Salary")]  <- predict(prep_escalado, testing_set[, c("Age","Salary")])
head(training_set)
head(testing_set)
