
library(e1071)
library(caret)

data(iris)
head(iris)

#Separar em training y testing
set.seed(123)

filas <- createDataPartition(iris$Species,
                             p = 0.8,
                             list = FALSE)

training_set <- iris[filas, ]
testing_set <- iris[-filas, ]

#Entrenar modelo SVM
modelo <- svm(
  Species ~ .,
  data = training_set,
  type = "C-classification",
  kernel = "radial",
  scale = TRUE
)
#ver modelo
print(modelo)

 #Realizar predicciones con testing set
y_pred <- predict(modelo, testing_set)


#Matriz de confusión
confusionMatrix(y_pred, testing_set$Species)


# Calcular precisión del modelo
accuracy <- mean(y_pred == testing_set$Species)

print(accuracy)

#Crear flor de prueba

flor_prueba <- data.frame(
  Sepal.Length = 5.1,
  Sepal.Width = 3.5,
  Petal.Length = 1.4,
  Petal.Width = 0.2
)

#Predecir especie de la for de prueba
prediccion <- predict(modelo, flor_prueba)

print(prediccion)

# 10. Graficar modelo SVM
plot(modelo, training_set,
     Petal.Width ~ Petal.Length)