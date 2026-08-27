# ============================================================
# Analyse des bibliothèques publiques de l'Ontario (2021)
# Analyse statistique
#
# Auteur : Alexandre Asselin
#
# Description :
# Produit les statistiques descriptives, les visualisations,
# les corrélations de Pearson, la régression linéaire multiple
# et l'analyse en composantes principales (ACP) utilisées
# dans le projet.
#
# Exécution :
# Lancer le script depuis la racine du dépôt.
# ============================================================


# ------------------------------------------------------------
# SECTION 1 : IMPORTATION ET PRÉPARATION DES ANALYSES
# ------------------------------------------------------------

# Objectif général :
# Importer le jeu de données préparé et vérifier que les
# variables nécessaires sont prêtes pour les analyses.


# ----- 1.1 Importation du jeu de données préparé ------------

# Objectif :
# Importer le jeu de données nettoyé et enrichi afin de vérifier 
# qu'il est accessible et qu'il peut être utilisé pour les 
# analyses statistiques.


# Afficher le dossier de travail

cat("Dossier de travail :", getwd(), "\n")
cat("Exécuter ce script depuis la racine du dépôt.\n\n")


# Définir le chemin du jeu de données

fichier <- file.path(
  "Donnees",
  "Donnees_preparees",
  "Bibliotheques_preparees.csv"
)


# Vérifier que le fichier existe

if (!file.exists(fichier)) {
  stop("Le fichier de données est introuvable : ", fichier)
}


# Lire le fichier

donnees <- read.csv(fichier, stringsAsFactors = FALSE)


# Vérifier les dimensions du jeu de données

dim(donnees)


# Vérifier la structure des variables

str(donnees)


# Afficher les premières observations

head(donnees)


# ----- 1.2 Sélection des variables principales --------------

# Objectif :
# Sélectionner les variables qui seront utilisées dans les
# analyses statistiques.


variables_analyse <- c(
  "Population_desservie",
  "Nb_succursales",
  "Heures_ouverture",
  "Superficie",
  "Ratio_abonnes_population",
  "Indice_ressources_technologiques"
)


# Vérifier les variables sélectionnées

names(donnees[, variables_analyse])


# ------------------------------------------------------------
# SECTION 2 : STATISTIQUES DESCRIPTIVES
# ------------------------------------------------------------

# Objectif général :
# Décrire les principales caractéristiques des variables
# retenues à l'aide de statistiques descriptives.


# ----- 2.1 Initialisation du tableau -------------------------

# Objectif :
# Créer un tableau qui servira à regrouper les statistiques
# descriptives des variables retenues.


# Créer un tableau vide qui contiendra les résultats
statistiques_descriptives <- data.frame(

  Variable = character(),
  N = integer(),
  Moyenne = numeric(),
  Mediane = numeric(),
  Ecart_type = numeric(),
  Minimum = numeric(),
  Maximum = numeric(),
  stringsAsFactors = FALSE
)


# ----- 2.2 Calcul des statistiques descriptives -------------

# Objectif :
# Calculer les statistiques descriptives de chacune
# des variables sélectionnées.


for (variable in variables_analyse) {

  # Extraire la variable
  valeurs <- donnees[[variable]]


  # Calculer les statistiques
  ligne <- data.frame(
    Variable = variable,
    N = sum(!is.na(valeurs)),
    Moyenne = mean(valeurs, na.rm = TRUE),
    Mediane = median(valeurs, na.rm = TRUE),
    Ecart_type = sd(valeurs, na.rm = TRUE),
    Minimum = min(valeurs, na.rm = TRUE),
    Maximum = max(valeurs, na.rm = TRUE)
  )


  # Ajouter les résultats au tableau

  statistiques_descriptives <-
    rbind(statistiques_descriptives, ligne)
}


# ----- 2.3 Mise en forme du tableau -------------------------

# Objectif :
# Arrondir les statistiques descriptives à deux décimales.


statistiques_descriptives$Moyenne <-
  round(statistiques_descriptives$Moyenne, 2)

statistiques_descriptives$Mediane <-
  round(statistiques_descriptives$Mediane, 2)

statistiques_descriptives$Ecart_type <-
  round(statistiques_descriptives$Ecart_type, 2)

statistiques_descriptives$Minimum <-
  round(statistiques_descriptives$Minimum, 2)

statistiques_descriptives$Maximum <-
  round(statistiques_descriptives$Maximum, 2)


# ----- 2.4 Ajout de libellés lisibles -----------------------

# Objectif :
# Remplacer les noms techniques des variables par des
# libellés plus explicites.


statistiques_descriptives$Variable <- c(
  "Population desservie",
  "Nombre de succursales",
  "Heures d'ouverture",
  "Superficie",
  "Ratio abonnés/population",
  "Indice de ressources technologiques"
)


# ----- 2.5 Affichage du tableau ---------------------------

# Objectif :
# Présenter le tableau final des statistiques descriptives.


statistiques_descriptives


# ------------------------------------------------------------
# SECTION 3 : VISUALISATIONS DESCRIPTIVES
# ------------------------------------------------------------

# Objectif général :
# Illustrer la distribution des principales variables et
# examiner visuellement les relations entre elles.


# ----- 3.1 Préparation des libellés --------------------------

# Objectif :
# Préparer des libellés courts et explicites pour les graphiques.


# Créer les libellés des variables

libelles_variables <- c(
  "Population desservie",
  "Nombre de succursales",
  "Heures d'ouverture",
  "Superficie",
  "Ratio abonnés/population",
  "Indice technologique"
)


# ----- 3.2 Histogrammes --------------------------------------

# Objectif :
# Examiner la distribution et l'asymétrie des six variables étudiées.


# Ouvrir une nouvelle fenêtre graphique

dev.new()


# Diviser la fenêtre en six espaces

par(mfrow = c(2, 3))


# Créer un histogramme pour chaque variable

for (i in 1:length(variables_analyse)) {


  # Identifier la variable à représenter

  variable <- variables_analyse[i]


  # Extraire les valeurs de la variable

  valeurs <- donnees[[variable]]


  # Créer l'histogramme

  hist(
    valeurs,
    main = libelles_variables[i],
    xlab = libelles_variables[i],
    ylab = "Nombre de bibliothèques"
  )
}


# ----- 3.3 Boîtes à moustaches -------------------------------

# Objectif :
# Examiner la dispersion des variables et repérer les valeurs
# qui se distinguent du reste des observations.


# Ouvrir une deuxième fenêtre graphique

dev.new()


# Diviser la fenêtre en six espaces

par(mfrow = c(2, 3))


# Créer une boîte à moustaches pour chaque variable

for (i in 1:length(variables_analyse)) {

  # Identifier la variable à représenter

  variable <- variables_analyse[i]


  # Extraire les valeurs de la variable

  valeurs <- donnees[[variable]]


  # Créer la boîte à moustaches

  boxplot(
    valeurs,
    main = libelles_variables[i],
    ylab = libelles_variables[i]
  )
}

# ----- 3.4 Matrice de nuages de points -----------------------

# Objectif :
# Visualiser simultanément les relations entre les principales
# variables utilisées dans les analyses.


# Créer un tableau contenant les variables à représenter

donnees_visualisation <- donnees[, variables_analyse]


# Ouvrir une nouvelle fenêtre graphique

dev.new()


# Créer la matrice de nuages de points

pairs(
  donnees_visualisation,
  labels = libelles_variables,
  cex = 0.5,
  main = "Relations entre les principales variables"
)


# ----- 3.5 Matrice après transformation logarithmique --------

# Objectif :
# Visualiser simultanément les relations entre les principales
# variables après transformation des variables asymétriques.


# Créer un tableau contenant les variables transformées

donnees_visualisation_log <- data.frame(
  Population = log10(donnees$Population_desservie),
  Succursales = log10(donnees$Nb_succursales),
  Heures_ouverture = log10(donnees$Heures_ouverture),
  Superficie = log10(donnees$Superficie),
  Ratio_abonnes = log10(donnees$Ratio_abonnes_population),
  Indice_technologique = donnees$Indice_ressources_technologiques
)


# Ouvrir une nouvelle fenêtre graphique

dev.new()


# Créer la matrice de nuages de points

pairs(
  donnees_visualisation_log,
  labels = libelles_variables,
  cex = 0.5,
  main = "Relations après transformation logarithmique"
)


# ------------------------------------------------------------
# SECTION 4 : CORRÉLATIONS LINÉAIRES DE PEARSON
# ------------------------------------------------------------

# Objectif général :
# Évaluer les relations linéaires entre l'indice de
# ressources technologiques et les principales variables
# retenues pour l'analyse.


# ----- 4.1 Préparation des variables -------------------------

# Objectif :
# Préparer les variables et les libellés qui seront utilisés 
# dans les analyses de corrélation et la production des graphiques.


# Regrouper les variables à comparer avec l'indice technologique

variables_x <- list(
  donnees$Population_desservie,
  donnees$Heures_ouverture,
  donnees$Nb_succursales,
  donnees$Superficie,
  donnees$Ratio_abonnes_population
)


# Préparer les noms des relations pour le tableau

noms_relations <- c(
  "Population desservie",
  "Heures d'ouverture",
  "Nombre de succursales",
  "Superficie",
  "Ratio abonnés/population"
)


# Stocker l'indice technologique dans un vecteur

indice <- donnees$Indice_ressources_technologiques


# ----- 4.2 Nuages de points ----------------------------------

# Objectif :
# Visualiser les relations entre chacune des variables explicatives 
# et l'indice de ressources technologiques.


# Ouvrir une nouvelle fenêtre graphique

dev.new()


# Diviser la fenêtre en six espaces

par(mfrow = c(2, 3))


# Créer les cinq nuages de points

for (i in 1:length(variables_x)) {

  plot(
    variables_x[[i]],
    indice,
    main = noms_relations[i],
    xlab = noms_relations[i],
    ylab = "Indice technologique",
    pch = 20,
    col = "blue"
  )
}


# ----- 4.3 Calcul des corrélations de Pearson ----------------

# Objectif :
# Calculer les corrélations de Pearson entre chacune des
# variables étudiées et l'indice technologique.


# Créer un tableau pour recevoir les résultats

tableau_correlations <- data.frame(
  Relation = noms_relations,
  N = numeric(length(variables_x)),
  Coefficient = numeric(length(variables_x)),
  Valeur_p = numeric(length(variables_x)),
  R_carre = numeric(length(variables_x))
)


# Calculer les résultats pour chacune des variables

for (i in 1:length(variables_x)) {


  # Sélectionner la variable analysée

  variable <- variables_x[[i]]


  # Réaliser le test de corrélation de Pearson

  test_correlation <- cor.test(variable, indice)


  # Ajouter les résultats au tableau

  tableau_correlations$N[i] <- sum(complete.cases(variable, indice))
  tableau_correlations$Coefficient[i] <- test_correlation$estimate
  tableau_correlations$Valeur_p[i] <- test_correlation$p.value
  tableau_correlations$R_carre[i] <- test_correlation$estimate^2
}

# ----- 4.4 Tableau récapitulatif des corrélations ------------

# Objectif  : 
# Présenter et interpréter les résultats des corrélations de Pearson.


# Arrondir le coefficient de corrélation

tableau_correlations$Coefficient <-
  round(tableau_correlations$Coefficient, 3)


# Arrondir le coefficient de corrélation au carré

tableau_correlations$R_carre <-
  round(tableau_correlations$R_carre, 3)


# Présenter les petites valeurs p sous la forme "< 0.001"

tableau_correlations$Valeur_p <-
  ifelse(
    tableau_correlations$Valeur_p < 0.001,
    "< 0.001",
    round(tableau_correlations$Valeur_p, 3)
  )

# Afficher le tableau

tableau_correlations


# ------------------------------------------------------------
# SECTION 5 : CORRÉLATIONS DE PEARSON APRÈS TRANSFORMATION
#             LOGARITHMIQUE
# ------------------------------------------------------------

# Objectif général :
# Évaluer les relations linéaires entre l'indice de ressources
# technologiques et les principales variables après avoir
# appliqué une transformation logarithmique aux variables
# fortement asymétriques.


# ----- 5.1 Préparation des variables -------------------------

# Objectif :
# Transformer les variables explicatives à l'aide d'une 
# transformation logarithmique en base 10 et préparer
# les libellés.


# Transformer les variables et les regrouper dans une liste

variables_x_log <- list(
  log10(donnees$Population_desservie),
  log10(donnees$Heures_ouverture),
  log10(donnees$Nb_succursales),
  log10(donnees$Superficie),
  log10(donnees$Ratio_abonnes_population)
)


# Préparer les noms des relations pour le tableau

noms_relations_log <- c(
  "Population desservie (log10)",
  "Heures d'ouverture (log10)",
  "Nombre de succursales (log10)",
  "Superficie (log10)",
  "Ratio abonnés/population (log10)"
)


# ----- 5.2 Nuages de points ----------------------------------

# Objectif :
# Visualiser les relations entre chacune des variables transformées
# et l'indice de ressources technologiques.


# Ouvrir une nouvelle fenêtre graphique

dev.new()


# Diviser la fenêtre en six espaces

par(mfrow = c(2, 3))


# Créer les cinq nuages de points

for (i in 1:length(variables_x_log)) {

  plot(
    variables_x_log[[i]],
    indice,
    main = noms_relations[i],
    xlab = noms_relations[i],
    ylab = "Indice technologique",
    pch = 20,
    col = "blue"
  )
}


# ----- 5.3 Calcul des corrélations de Pearson ----------------

# Objectif :
# Calculer les corrélations de Pearson entre chacune des variables
# transformées et l'indice de ressources technologiques, puis
# enregistrer les résultats dans un tableau.


# Créer un tableau pour recevoir les résultats

tableau_correlations_log <- data.frame(
  Relation = noms_relations_log,
  N = numeric(length(variables_x_log)),
  Coefficient = numeric(length(variables_x_log)),
  Valeur_p = numeric(length(variables_x_log)),
  R_carre = numeric(length(variables_x_log))
)


# Calculer les résultats pour chacune des variables

for (i in 1:length(variables_x_log)) {


  # Sélectionner la variable analysée

  variable <- variables_x_log[[i]]


  # Réaliser le test de corrélation de Pearson

  test_correlation <- cor.test(variable, indice)


  # Ajouter les résultats au tableau

  tableau_correlations_log$N[i] <- sum(complete.cases(variable, indice))

  tableau_correlations_log$Coefficient[i] <- test_correlation$estimate

  tableau_correlations_log$Valeur_p[i] <- test_correlation$p.value

  tableau_correlations_log$R_carre[i] <- test_correlation$estimate^2
}


# ----- 5.4 Tableau récapitulatif des corrélations ------------

# Objectif :
# Présenter les résultats des corrélations de Pearson après
# transformation logarithmique dans un tableau clair et 
# facile à interpréter.


# Arrondir le coefficient de corrélation

tableau_correlations_log$Coefficient <-
  round(tableau_correlations_log$Coefficient, 3)


# Arrondir le coefficient de corrélation au carré

tableau_correlations_log$R_carre <-
  round(tableau_correlations_log$R_carre, 3)


# Présenter les petites valeurs p sous la forme "< 0.001"

tableau_correlations_log$Valeur_p <-
  ifelse(
    tableau_correlations_log$Valeur_p < 0.001,
    "< 0.001",
    round(tableau_correlations_log$Valeur_p, 3)
  )


# Afficher le tableau

tableau_correlations_log


# ------------------------------------------------------------
# SECTION 6 : RÉGRESSION LINÉAIRE MULTIPLE
# ------------------------------------------------------------

# Objectif général :
# Approfondir l'analyse en étudiant simultanément les relations
# entre plusieurs caractéristiques des bibliothèques et l'indice
# de ressources technologiques.

# Remarque :
# La population intervient dans le calcul de l'indice
# technologique. Son retrait est donc examiné avant de retenir
# le modèle final.


# ----- 6.1 Préparation des données ---------------------------

# Objectif :
# Préparer les variables utilisées dans la régression multiple.


# Créer un tableau contenant les variables de la régression

donnees_regression <- data.frame(
  Nom_bibliotheque = donnees$Nom_bibliotheque,
  Indice_technologique = donnees$Indice_ressources_technologiques,
  Population_log = log10(donnees$Population_desservie),
  Heures_ouverture_log = log10(donnees$Heures_ouverture),
  Succursales_log = log10(donnees$Nb_succursales),
  Superficie_log = log10(donnees$Superficie),
  Ratio_abonnes_log = log10(donnees$Ratio_abonnes_population)
)


# Conserver uniquement les observations complètes

donnees_regression <- 
  donnees_regression[complete.cases(donnees_regression),]


# Vérifier le nombre d'observations

dim(donnees_regression)


# ----- 6.2 Modèle initial ------------------------------------

# Objectif :
# Examiner simultanément la relation entre les cinq caractéristiques 
# étudiées et l'indice technologique.

# Construire le modèle

modele_initial <- lm(
  Indice_technologique ~
    Population_log +
    Heures_ouverture_log +
    Succursales_log +
    Superficie_log +
    Ratio_abonnes_log,
  data = donnees_regression
)


# Afficher les résultats

summary(modele_initial)


# ----- 6.3 Corrélations entre les variables explicatives -----

# Objectif :
# Vérifier si certaines variables explicatives sont fortement
# liées entre elles.


# Sélectionner les variables explicatives

variables_regression <- donnees_regression[
  ,
  c(
    "Population_log",
    "Heures_ouverture_log",
    "Succursales_log",
    "Superficie_log",
    "Ratio_abonnes_log"
  )
]


# Calculer les corrélations entre les variables explicatives

correlations_regression <- cor(variables_regression)


# Arrondir et afficher les corrélations

round(correlations_regression, 3)


# ----- 6.4 Vérification de la multicolinéarité ---------------

# Objectif :
# Vérifier la multicolinéarité à l'aide du VIF.


# Créer un vecteur pour conserver les VIF

vif_initial <- numeric(5)


# Calculer le VIF de chaque variable explicative

for (i in 1:5) {


  # Sélectionner la variable examinée

  variable_y <- variables_regression[, i]


  # Sélectionner les autres variables

  autres_variables <- variables_regression[, -i]


  # Expliquer la variable examinée par les autres variables

  modele_vif <- lm(variable_y ~ ., data = autres_variables)


  # Extraire le R carré

  r_carre <- summary(modele_vif)$r.squared


  # Calculer le VIF

  vif_initial[i] <- 1 / (1 - r_carre)
}


# Associer les noms des variables

names(vif_initial) <- names(variables_regression)


# Afficher les VIF

round(vif_initial, 2)


# ----- 6.5 Modèle sans la population -------------------------

# Objectif :
# Examiner le modèle sans la population puisqu'elle intervient
# dans la construction de l'indice technologique.


# Construire le modèle sans population

modele_sans_population <- lm(
  Indice_technologique ~
    Heures_ouverture_log +
    Succursales_log +
    Superficie_log +
    Ratio_abonnes_log,
  data = donnees_regression
)


# Afficher les résultats

summary(modele_sans_population)


# Sélectionner les variables du modèle sans population

variables_sans_population <- donnees_regression[
  ,
  c(
    "Heures_ouverture_log",
    "Succursales_log",
    "Superficie_log",
    "Ratio_abonnes_log"
  )
]


# Créer un vecteur pour conserver les nouveaux VIF

vif_sans_population <- numeric(4)


# Calculer les VIF

for (i in 1:4) {

  variable_y <- variables_sans_population[, i]

  autres_variables <- variables_sans_population[, -i]

  modele_vif <- lm(variable_y ~ ., data = autres_variables)

  r_carre <- summary(modele_vif)$r.squared

  vif_sans_population[i] <- 1 / (1 - r_carre)
}


# Associer les noms des variables

names(vif_sans_population) <- names(variables_sans_population)


# Afficher les VIF

round(vif_sans_population, 2)


# ----- 6.6 Modèle retenu -------------------------------------

# Objectif :
# Construire un modèle plus simple avec les deux variables
# significatives du modèle sans population.


# Construire le modèle retenu

modele_regression <- lm(
  Indice_technologique ~
    Superficie_log +
    Ratio_abonnes_log,
  data = donnees_regression
)


# Afficher les résultats

summary(modele_regression)


# Vérifier la relation entre les deux variables explicatives

cor(
  donnees_regression$Superficie_log,
  donnees_regression$Ratio_abonnes_log
)


# ----- 6.7 Validation graphique du modèle --------------------

# Objectif :
# Vérifier graphiquement les principales conditions du modèle
# et repérer d'éventuelles observations atypiques.


# Ouvrir une nouvelle fenêtre graphique

dev.new()


# Diviser la fenêtre en quatre espaces

par(mfrow = c(2, 2))


# Produire les graphiques diagnostiques

plot(modele_regression)


# Rétablir la disposition graphique initiale

par(mfrow = c(1, 1))


# ----- 6.8 Tableau des résultats de la régression -------------

# Objectif :
# Présenter les coefficients du modèle de régression retenu.

# Extraire les coefficients du modèle

tableau_regression <-
  as.data.frame(summary(modele_regression)$coefficients)


# Ajouter le nom des variables

tableau_regression$Variable <- row.names(tableau_regression)


# Réorganiser les colonnes

tableau_regression <- tableau_regression[
  ,
  c("Variable", "Estimate", "Std. Error", "t value", "Pr(>|t|)")
]


# Afficher le tableau

tableau_regression


# ------------------------------------------------------------
# SECTION 7 : ANALYSE EN COMPOSANTES PRINCIPALES
# ------------------------------------------------------------

# Objectif général :
# Examiner simultanément les principales caractéristiques
# des bibliothèques afin d'identifier les dimensions communes
# qui structurent les données.


# ----- 7.1 Préparation des données ---------------------------

# Objectif :
# Préparer les variables utilisées dans l'ACP.


# Sélectionner les variables transformées

donnees_acp <- donnees_regression[
  ,
  c(
    "Population_log",
    "Heures_ouverture_log",
    "Succursales_log",
    "Superficie_log",
    "Ratio_abonnes_log"
  )
]


# ----- 7.2 Réalisation de l'ACP ------------------------------

# Objectif :
# Réaliser l'ACP et déterminer l'importance des composantes obtenues.


# Réaliser l'ACP

acp <- prcomp(
  donnees_acp,
  center = TRUE,
  scale. = TRUE
)


# Afficher un résumé de l'ACP

summary(acp)


# ----- 7.3 Interprétation des composantes --------------------

# Objectif :
# Présenter la contribution des variables aux composantes
# principales afin de faciliter leur interprétation.


# Transformer les coefficients en tableau

tableau_composantes_acp <- as.data.frame(acp$rotation)


# Inverser la deuxième composante

tableau_composantes_acp$PC2 <- -tableau_composantes_acp$PC2


# Ajouter le nom des variables

tableau_composantes_acp$Variable <- row.names(tableau_composantes_acp)


# Réorganiser les colonnes

tableau_composantes_acp <- tableau_composantes_acp[
  ,
  c("Variable", "PC1", "PC2", "PC3", "PC4", "PC5")
]


# Arrondir les résultats

tableau_composantes_acp[, 2:6] <- round(tableau_composantes_acp[, 2:6], 3)


# Afficher le tableau

tableau_composantes_acp


# ----- 7.4 Représentation des bibliothèques ------------------

# Objectif :
# Représenter les bibliothèques selon les deux premières
# composantes principales.


# Extraire les coordonnées des bibliothèques

coordonnees_acp <- acp$x


# Inverser la deuxième composante

coordonnees_acp[, 2] <- -coordonnees_acp[, 2]


# Créer un tableau avec les coordonnées des bibliothèques

tableau_coordonnees_acp <- data.frame(
  Nom_bibliotheque = donnees_regression$Nom_bibliotheque,
  PC1 = coordonnees_acp[, 1],
  PC2 = coordonnees_acp[, 2]
)


# Afficher les premières observations

head(tableau_coordonnees_acp)


# Ouvrir une nouvelle fenêtre graphique

dev.new()


# Créer le graphique

plot(
  coordonnees_acp[, 1],
  coordonnees_acp[, 2],
  xlab = "PC1 - Taille du réseau (67,6 %)",
  ylab = "PC2 - Ratio d'abonnés (20,6 %)",
  main = "Bibliothèques selon les deux premières composantes",
  pch = 20
)


# ----- 7.5 Variance expliquée --------------------------------

# Objectif :
# Examiner la proportion de variance expliquée par
# chacune des composantes principales.


# Calculer la proportion de variance expliquée

variance_expliquee <- acp$sdev^2 / sum(acp$sdev^2)


# Préparer le tableau de la variance expliquée

tableau_variance_acp <- data.frame(
  Composante = c("PC1", "PC2", "PC3", "PC4", "PC5"),
  Variance_expliquee = round(variance_expliquee * 100, 2)
)


# Afficher le tableau

tableau_variance_acp


# Ouvrir une nouvelle fenêtre graphique

dev.new()


# Créer le graphique de la variance expliquée

barplot(
  variance_expliquee * 100,
  names.arg = c("PC1", "PC2", "PC3", "PC4", "PC5"),
  xlab = "Composantes principales",
  ylab = "Variance expliquée (%)",
  main = "Variance expliquée par les composantes"
)


# ------------------------------------------------------------
# SECTION 8 : SAUVEGARDE DES RÉSULTATS
# ------------------------------------------------------------

# Objectif général :
# Sauvegarder les principaux tableaux produits au cours
# des analyses statistiques.


# ----- 8.1 Préparation du dossier des résultats --------------

# Objectif :
# Créer le dossier destiné à recevoir les tableaux de résultats.


# Définir le dossier des résultats

dossier_resultats <- file.path(
  "Resultats",
  "Analyse_statistique"
)


# Créer le dossier des résultats s'il n'existe pas déjà

if (!dir.exists(dossier_resultats)) {
  dir.create(dossier_resultats, recursive = TRUE)
}


# ----- 8.2 Sauvegarde des tableaux ---------------------------

# Objectif :
# Enregistrer les tableaux produits par les analyses statistiques
# dans des fichiers CSV.


# Regrouper les tableaux à sauvegarder dans une liste

tableaux_resultats <- list(
  statistiques_descriptives,
  tableau_correlations,
  tableau_correlations_log,
  tableau_regression,
  tableau_variance_acp,
  tableau_composantes_acp,
  tableau_coordonnees_acp
)


# Préparer les noms des fichiers CSV

noms_fichiers <- c(
  "Statistiques_descriptives.csv",
  "Tableau_correlations_pearson.csv",
  "Tableau_correlations_pearson_log.csv",
  "Tableau_regression_multiple.csv",
  "Variance_expliquee_ACP.csv",
  "Composantes_ACP.csv",
  "Coordonnees_bibliotheques_ACP.csv"
)


# Sauvegarder chacun des tableaux

for (i in 1:length(tableaux_resultats)) {

  write.csv(
    tableaux_resultats[[i]],
    file.path(dossier_resultats, noms_fichiers[i]),
    row.names = FALSE
  )
}


# ----- 8.3 Confirmation de la sauvegarde --------------------

# Objectif :
# Confirmer que les tableaux ont été enregistrés dans
# le dossier prévu.


cat(
  "\nLes tableaux ont été enregistrés dans le dossier :",
  file.path(getwd(), dossier_resultats),
  "\n"
)