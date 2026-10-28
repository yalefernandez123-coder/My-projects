# Business Analytics Portfolio

Welcome to my Business Analytics portfolio!

I am an Investment Banking Associate with a background in Agricultural Economics and Business Analytics.

This repository showcases my technical projects in data analysis, statistical modeling, machine learning, and data visualization.

## Project 1: KNN Missing Data Imputation in R

**Objective:** Estimate missing salary values using the K-Nearest Neighbors (KNN) imputation algorithm.

**Technologies:** R, Caret, RANN, ggplot2.

**Methodology:**
- Introduced 20 missing salary values.
- Applied KNN imputation.
- Performed 5-fold cross-validation.
- Evaluated different K values using RMSE.
- Selected the best K to estimate missing values.

**Skills demonstrated:** Data Cleaning, Machine Learning, Cross-Validation, Statistical Analysis.
## Project 2: Data Preprocessing and Feature Engineering in R

Project 2: Data Preprocessing and Feature Engineering in R

### Project Overview
This project demonstrates essential data preprocessing techniques used to prepare datasets for machine learning and statistical analysis.

### Objective
Clean, transform, and prepare raw data for predictive modeling while applying appropriate preprocessing techniques.

### Technologies
- R Programming
- Caret
- caTools
- Data Preprocessing
- Feature Engineering

### Methodology
1. **Missing Value Detection:** Identified missing values in the dataset.
2. **Mean Imputation:** Replaced missing Age and Salary values with their respective means.
3. **Categorical Encoding:** Converted Country into numerical dummy variables using one-hot encoding.
4. **Target Encoding:** Converted the Purchased variable into binary categories.
5. **Train-Test Split:** Divided the dataset into 80% training and 20% testing data.
6. **Standardization:** Applied z-score scaling to numerical variables.
7. **Normalization:** Compared min-max normalization with standardization.
8. **Data Leakage Prevention:** Used scaling parameters learned from the training set to transform the testing set.

### Skills Demonstrated
- Data Cleaning
- Missing Value Treatment
- Feature Engineering
- Categorical Encoding
- Data Transformation
- Train-Test Splitting
- Data Leakage Awareness
- 
##Project 3: Iris Species Classification Using Support Vector Machines (SVM)
Overview
This project demonstrates a supervised machine learning classification model built in R using a Support Vector Machine (SVM) with a radial basis function (RBF) kernel. The goal is to predict iris flower species based on four measurements.
Dataset
The built-in iris dataset contains 150 observations, four numeric predictors (Sepal.Length, Sepal.Width, Petal.Length, Petal.Width), and three target classes (setosa, versicolor, virginica). No external CSV is required.
Workflow
1. Load e1071 and caret and inspect the dataset.
2. Create a reproducible, stratified 80/20 train-test split (set.seed(123)).
3. Train a C-classification SVM with an RBF kernel and feature scaling.
4. Predict species on the held-out test set.
5. Evaluate the model using a confusion matrix and accuracy.
6. Predict the species of a new flower.
7. Visualize a two-feature slice of the model's decision regions.
How to run
Install dependencies once:
install.packages(c("e1071", "caret"))
Then open Modelo_SVM.R in RStudio and run the script, or execute:
Rscript Modelo_SVM.R
Model configuration
modelo <- svm(
  Species ~ .,
  data = training_set,
  type = "C-classification",
  kernel = "radial",
  scale = TRUE
)
The model uses all four predictors. Default cost = 1 and gamma = 1 / 4 are used unless changed explicitly.
Evaluation
The script prints a confusion matrix and test-set accuracy. No numeric accuracy is claimed here because the script's results have not been executed and verified in this repository.
Visualization
The script plots the SVM decision regions using Petal.Length and Petal.Width. Since the model is trained on four predictors, this two-dimensional plot is only a slice of its decision function.

To include a saved image, run the plot in RStudio, export it as images/svm_visualization.png, and commit it to the repository.
Tools
R · e1071 · caret · RStudio
Future improvements
- Tune cost and gamma with cross-validation.
- Compare SVM with LDA and other classification models.
- Report per-class precision, recall, and F1-score.
References
- R e1071 package documentation: https://cran.r-project.org/package=e1071
- R caret package documentation: https://cran.r-project.org/package=caret
- Iris dataset documentation: https://stat.ethz.ch/R-manual/R-devel/library/datasets/html/iris.html

### Business Applications
These techniques can be applied to customer analytics, financial datasets, predictive modeling, and business intelligence projects.
## Additional Projects

Coming soon:
- Power BI Dashboards
- Tableau Analytics
- KNIME Data Preparation
- Predictive Modeling in R
