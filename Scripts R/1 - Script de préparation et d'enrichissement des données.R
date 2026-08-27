# ============================================================
# Analyse des bibliothèques publiques de l'Ontario (2021)
# Script de préparation et d'enrichissement des données
#
# Auteur : Alexandre Asselin
#
# Objectif :
# Importer le jeu de données, le préparer, créer les
# indicateurs nécessaires aux analyses et obtenir un jeu
# de données fiable et enrichi, prêt pour les phases
# suivantes.
# ============================================================


# ------------------------------------------------------------
# SECTION 1 : IMPORTATION DES DONNÉES
# ------------------------------------------------------------

# Objectif général :
# Examiner le fichier brut, corriger sa structure et l'importer
# sous forme de tableau.


# ----- 1.1 Observation du fichier brut ----------------------

# Objectif :
# Observer le fichier CSV avant son importation afin de 
# comprendre sa structure.


# Afficher le dossier de travail

cat("Dossier de travail :", getwd(), "\n")
cat("Le dossier de travail doit être le dossier racine du projet.\n\n")


# Définir le chemin du fichier brut

fichier <- file.path(
  "Donnees",
  "Donnees_brutes",
  "bibliotheques_ontario_2021.csv"
)


# Vérifier que le fichier existe

if (!file.exists(fichier)) {
  stop("Le fichier de données brutes est introuvable : ", fichier)
}


# Lire le fichier comme du texte

lignes <- readLines(fichier, encoding = "UTF-8")


# Afficher les premières lignes du fichier brut

head(lignes, 10)


# Vérifier le nombre total de lignes

length(lignes)


# ----- 1.2 Suppression des lignes descriptives --------------

# Objectif :
# Retirer les lignes descriptives situées au début du fichier.


# Retirer les quatre premières lignes

lignes <- lignes[-c(1:4)]


# Vérifier le résultat

head(lignes, 10)


# ----- 1.3 Correction des guillemets extérieurs -------------

# Objectif :
# Retirer les guillemets placés au début et à la fin de
# certaines lignes.


# Corriger les lignes entourées de guillemets

for (i in 1:length(lignes)) {

  debut <- substr(lignes[i], 1, 1)
  fin <- substr(lignes[i], nchar(lignes[i]), nchar(lignes[i]))

  if (debut == '"' && fin == '"') {
    lignes[i] <- substr(lignes[i], 2, nchar(lignes[i]) - 1)
  }
}


# Vérifier le résultat

head(lignes, 10)


# ----- 1.4 Correction des guillemets doubles ----------------

# Objectif :
# Remplacer les guillemets doubles par des guillemets simples.


# Corriger les guillemets doubles

lignes <- gsub('""', '"', lignes)


# Vérifier le résultat

head(lignes, 10)


# ----- 1.5 Importation du tableau ---------------------------

# Objectif :
# Importer le fichier préparé sous forme de tableau.


# Importer le tableau

donnees <- read.csv(text = lignes, stringsAsFactors = FALSE)


# Vérifier l'importation

head(donnees)

dim(donnees)


# ------------------------------------------------------------
# SECTION 2 : PRÉPARATION DES DONNÉES
# ------------------------------------------------------------

# Objectif général :
# Corriger la structure du tableau, vérifier la qualité des
# données et traiter les valeurs incohérentes.


# ----- 2.1 Suppression des lignes non pertinentes -----------

# Objectif :
# Retirer les lignes qui ne correspondent pas à des
# bibliothèques.


# Examiner les dernières lignes du tableau

tail(donnees, 15)


# Conserver uniquement les lignes des bibliothèques

donnees <- donnees[1:303, ]


# Vérifier le résultat

dim(donnees)


# ----- 2.2 Correction des observations décalées -------------

# Objectif :
# Corriger les observations décalées par une virgule dans le
# nom de certaines bibliothèques.


# Repérer les observations décalées

lignes_decalees <- donnees$X.2 != ""

sum(lignes_decalees)


donnees[
  lignes_decalees,
  c("X", "X.1", "X.2")
]


# Repérer les lignes principales et les lignes parasites

indices_decalees <- which(lignes_decalees)
indices_parasites <- indices_decalees + 1


# Corriger les observations décalées

for (i in indices_decalees) {

  ligne_parasite <- i + 1

  donnees$X[i] <- paste(
    trimws(donnees$X[i]),
    trimws(donnees$X.1[i]),
    sep = ", "
  )

  donnees$X.1[i] <- donnees$X.2[i]
  donnees[i, 3:19] <- donnees[i, 4:20]
  donnees$E.readers[i] <- donnees$X[ligne_parasite]
}


# Vérifier les observations corrigées

donnees[indices_decalees, ]


# Supprimer les lignes parasites

donnees <- donnees[-indices_parasites, ]


# Supprimer la colonne devenue inutile

donnees$X.2 <- NULL


# Vérifier les dimensions du tableau

dim(donnees)


# ----- 2.3 Renommer les variables --------------------------

# Objectif :
# Remplacer les noms des variables par des noms courts et en
# français.


# Afficher les noms d'origine

names(donnees)


# Renommer les variables

names(donnees) <- c(
  "Nom_bibliotheque",
  "Nom_responsable",
  "Population_residente",
  "Population_contractuelle",
  "Nb_abonnes_actifs",
  "Nb_menages_servis",
  "Nb_points_service",
  "Nb_succursales",
  "Heures_ouverture",
  "Nb_imprimantes_3D",
  "Nb_espaces_creation",
  "Nb_locations_salles",
  "Nb_bibliotheques_ephemeres",
  "Superficie",
  "Nb_postes_publics",
  "Nb_postes_OPAC",
  "Nb_postes_internet",
  "Nb_appareils_pretes",
  "Nb_liseuses"
)


# Vérifier les nouveaux noms

names(donnees)


# ----- 2.4 Conversion des variables numériques --------------

# Objectif :
# Convertir les variables numériques dans le format approprié.


# Examiner la structure du tableau

str(donnees)


# Définir les variables numériques

variables_numeriques <- c(
  "Population_residente",
  "Population_contractuelle",
  "Nb_abonnes_actifs",
  "Nb_menages_servis",
  "Nb_points_service",
  "Nb_succursales",
  "Heures_ouverture",
  "Nb_imprimantes_3D",
  "Nb_espaces_creation",
  "Nb_locations_salles",
  "Nb_bibliotheques_ephemeres",
  "Superficie",
  "Nb_postes_publics",
  "Nb_postes_OPAC",
  "Nb_postes_internet",
  "Nb_appareils_pretes",
  "Nb_liseuses"
)


# Convertir les variables numériques

for (variable in variables_numeriques) {
  donnees[[variable]] <- gsub(",", "", donnees[[variable]])
  donnees[[variable]] <- as.numeric(donnees[[variable]])
}


# Vérifier la structure du tableau

str(donnees)


# ----- 2.5 Vérification des doublons ------------------------

# Objectif :
# Vérifier si une bibliothèque apparaît plus d'une fois.


# Compter les noms de bibliothèques en double

sum(duplicated(donnees$Nom_bibliotheque))


# ----- 2.6 Vérification des valeurs manquantes --------------

# Objectif :
# Vérifier les valeurs manquantes avant les corrections.


# Compter les valeurs manquantes par variable

colSums(is.na(donnees))


# ----- 2.7 Vérification des valeurs extrêmes ----------------

# Objectif :
# Examiner les plus petites et les plus grandes valeurs de
# chaque variable numérique.


# Afficher les valeurs extrêmes de chaque variable

for (variable in variables_numeriques) {

  cat("\n========================================\n")
  cat(variable, "\n")
  cat("========================================\n")

  cat("\n10 plus petites valeurs\n")

  print(
    donnees[
      order(donnees[[variable]]),
      c("Nom_bibliotheque", variable)
    ][1:10, ]
  )

  cat("\n10 plus grandes valeurs\n")

  print(
    donnees[
      order(-donnees[[variable]]),
      c("Nom_bibliotheque", variable)
    ][1:10, ]
  )
}


# ----- 2.8 Correction du nombre de ménages servis -----------

# Objectif :
# Remplacer les valeurs nulles par des valeurs manquantes.


# Remplacer les valeurs nulles

donnees$Nb_menages_servis[donnees$Nb_menages_servis == 0] <- NA


# Vérifier la correction

summary(donnees$Nb_menages_servis)


# ----- 2.9 Correction de la superficie ----------------------

# Objectif :
# Traiter les valeurs nulles dans la variable Superficie.


# Remplacer les superficies nulles

donnees$Superficie[donnees$Superficie == 0] <- NA


# Vérifier la correction

summary(donnees$Superficie)


# ----- 2.10 Correction des espaces de création --------------

# Objectif :
# Remplacer la valeur incohérente de Kapuskasing par une valeur
# manquante.


# Corriger la valeur de Kapuskasing

donnees$Nb_espaces_creation[donnees$Nom_bibliotheque == "Kapuskasing"] <- NA


# Vérifier la correction

donnees[
  donnees$Nom_bibliotheque == "Kapuskasing",
  c("Nom_bibliotheque", "Nb_espaces_creation")
]


# ----- 2.11 Correction du nombre de postes publics ----------

# Objectif :
# Remplacer les nombres de postes publics incohérents par des
# valeurs manquantes.


# Repérer les valeurs incohérentes

donnees[
  donnees$Nb_postes_publics < donnees$Nb_postes_OPAC |
    donnees$Nb_postes_publics < donnees$Nb_postes_internet,
  c(
    "Nom_bibliotheque",
    "Nb_postes_publics",
    "Nb_postes_OPAC",
    "Nb_postes_internet"
  )
]


# Corriger les valeurs incohérentes

donnees$Nb_postes_publics[
  donnees$Nb_postes_publics < donnees$Nb_postes_OPAC |
    donnees$Nb_postes_publics < donnees$Nb_postes_internet
] <- NA


donnees$Nb_postes_publics[donnees$Nom_bibliotheque == "Essex County"] <- NA


# Vérifier les corrections

donnees[
  is.na(donnees$Nb_postes_publics),
  c(
    "Nom_bibliotheque",
    "Nb_postes_publics",
    "Nb_postes_OPAC",
    "Nb_postes_internet"
  )
]


# ----- 2.12 Abonnés actifs et population désservie ----------

# Objectif :
# Vérifier si certaines bibliothèques comptent plus d'abonnés 
# actifs que de personnes dans leur population desservie.


# Afficher les bibliothèques concernées

donnees[
  donnees$Nb_abonnes_actifs >
    donnees$Population_residente +
    donnees$Population_contractuelle,
  c(
    "Nom_bibliotheque",
    "Nb_abonnes_actifs",
    "Population_residente",
    "Population_contractuelle"
  )
]


# ----- 2.13 Vérification des succursales --------------------

# Objectif :
# Vérifier si certaines bibliothèques comptent plus de 
# succursales que de point de service.


# Afficher les bibliothèques concernées

donnees[
  donnees$Nb_succursales > donnees$Nb_points_service,
  c(
    "Nom_bibliotheque",
    "Nb_points_service",
    "Nb_succursales"
  )
]


# ----- 2.14 Diagrammes en boîte -----------------------------

# Objectif :
# Visualiser la distribution et les valeurs extrêmes des 
# variables numériques à l'aide de diagrammes en boîte.


# Définir la disposition des graphiques

par(mfrow = c(2, 3))


# Créer un diagramme en boîte pour chaque variable

for (variable in variables_numeriques) {
  boxplot(
    donnees[[variable]],
    main = variable
  )
}


# Rétablir la disposition graphique initiale

par(mfrow = c(1, 1))


# ------------------------------------------------------------
# SECTION 3 : CRÉATION DES INDICATEURS
# ------------------------------------------------------------

# Objectif général :
# Créer les indicateurs nécessaires aux analyses et vérifier
# leur cohérence.


# ----- 3.1 Calcul de la population desservie ----------------

# Objectif :
# Calculer la population totale desservie par chaque bibliothèque 
# afin de créer une base commune pour les indicateurs exprimés 
# par habitant.


# Calculer la population desservie

donnees$Population_desservie <-
  donnees$Population_residente + donnees$Population_contractuelle


# Vérifier le calcul

summary(donnees$Population_desservie)


# Vérifier les valeurs manquantes

sum(is.na(donnees$Population_desservie))


# Vérifier les populations nulles ou négatives

sum(donnees$Population_desservie <= 0, na.rm = TRUE)


# ----- 3.2 Calcul du ratio abonnés/population ---------------

# Objectif :
# Calculer le ratio entre le nombre d'abonnés actifs et la
# population desservie et vérifier les valeurs supérieures à 1.


# Calculer le ratio abonnés-population

donnees$Ratio_abonnes_population <-
  donnees$Nb_abonnes_actifs / donnees$Population_desservie


# Vérifier le calcul

summary(donnees$Ratio_abonnes_population)


# Compter les ratios supérieurs à 1

sum(donnees$Ratio_abonnes_population > 1, na.rm = TRUE)


# Afficher les bibliothèques concernées

donnees[
  donnees$Ratio_abonnes_population > 1,
  c(
    "Nom_bibliotheque",
    "Nb_abonnes_actifs",
    "Population_desservie",
    "Ratio_abonnes_population"
  )
]


# ----- 3.3 Ressources technologiques par 1 000 habitants ----

# Objectif :
# Calculer le nombre de ressources technologiques pour 1 000
# habitants afin de comparer les bibliothèques malgré les 
# différences de population.

# Note :
# La population desservie entre directement dans le calcul de
# ces indicateurs. Les relations ultérieures entre la population
# et l'indice technologique devront donc être interprétées avec
# prudence.


# Calculer les ressources technologiques par 1 000 habitants

donnees$Imprimantes_3D_1000 <-
  donnees$Nb_imprimantes_3D / donnees$Population_desservie * 1000


donnees$Espaces_creation_1000 <-
  donnees$Nb_espaces_creation / donnees$Population_desservie * 1000


donnees$Postes_internet_1000 <-
  donnees$Nb_postes_internet / donnees$Population_desservie * 1000


donnees$Appareils_pretes_1000 <-
  donnees$Nb_appareils_pretes / donnees$Population_desservie * 1000


donnees$Liseuses_1000 <-
  donnees$Nb_liseuses / donnees$Population_desservie * 1000


# Résumer les indicateurs

variables_technologiques_1000 <- c(
  "Imprimantes_3D_1000",
  "Espaces_creation_1000",
  "Postes_internet_1000",
  "Appareils_pretes_1000",
  "Liseuses_1000"
)

summary(donnees[, variables_technologiques_1000])


# Vérifier les valeurs manquantes

colSums(
  is.na(donnees[, variables_technologiques_1000])
)


# ----- 3.4 Standardisation des ressources technologiques ----

# Objectif :
# Standardiser les ressources technologiques afin de les rendre
# comparables et vérifier les résultats de la standardisation.


# Standardiser les ressources technologiques

donnees$Z_Imprimantes_3D <-
  as.numeric(scale(donnees$Imprimantes_3D_1000))

donnees$Z_Espaces_creation <-
  as.numeric(scale(donnees$Espaces_creation_1000))

donnees$Z_Postes_internet <-
  as.numeric(scale(donnees$Postes_internet_1000))

donnees$Z_Appareils_pretes <-
  as.numeric(scale(donnees$Appareils_pretes_1000))

donnees$Z_Liseuses <-
  as.numeric(scale(donnees$Liseuses_1000))


# Définir les composantes de l'indice

composantes_indice <- c(
  "Z_Imprimantes_3D",
  "Z_Espaces_creation",
  "Z_Postes_internet",
  "Z_Appareils_pretes",
  "Z_Liseuses"
)


# Vérifier les moyennes des variables standardisées

colMeans(donnees[, composantes_indice], na.rm = TRUE)


# Vérifier les écarts-types des variables standardisées

sapply(
  donnees[, composantes_indice],
  sd,
  na.rm = TRUE
)


# ----- 3.5 Construction de l'indice technologique -----------

# Objectif :
# Construire un indice global à partir des cinq ressources
# technologiques standardisées.


# Compter le nombre de composantes disponibles pour chaque bibliothèque

donnees$Nb_composantes_indice <-
  rowSums(!is.na(donnees[, composantes_indice]))


# Vérifier le nombre de composantes disponibles

table(donnees$Nb_composantes_indice)


# Afficher les bibliothèques qui n'ont pas les cinq composantes

donnees[
  donnees$Nb_composantes_indice < 5,
  c("Nom_bibliotheque", "Nb_composantes_indice")
]


# Construire l'indice technologique

donnees$Indice_ressources_technologiques <-
  rowMeans(donnees[, composantes_indice])


# Résumer l'indice technologique

summary(donnees$Indice_ressources_technologiques)


# ----- 3.6 Validation des indicateurs -----------------------

# Objectif :
# Visualiser la distribution du ratio abonnés-population et de
# l'indice de ressources technologiques.


# Ouvrir une nouvelle fenêtre graphique

dev.new()


# Définir la disposition des graphiques

par(mfrow = c(2, 2))


# Créer l'histogramme du ratio abonnés-population

hist(
  donnees$Ratio_abonnes_population,
  main = "Ratio abonnés-population",
  xlab = "Ratio abonnés-population"
)


# Créer le diagramme en boîte du ratio abonnés-population

boxplot(
  donnees$Ratio_abonnes_population,
  main = "Ratio abonnés-population"
)


# Créer l'histogramme de l'indice technologique

hist(
  donnees$Indice_ressources_technologiques,
  main = "Indice de ressources technologiques",
  xlab = "Indice de ressources technologiques"
)


# Créer le diagramme en boîte de l'indice technologique

boxplot(
  donnees$Indice_ressources_technologiques,
  main = "Indice de ressources technologiques"
)


# Rétablir la disposition graphique initiale

par(mfrow = c(1, 1))


# Identifier les valeurs les plus élevées du ratio abonnés-population

donnees[
  order(-donnees$Ratio_abonnes_population),
  c("Nom_bibliotheque", "Ratio_abonnes_population")
][1:10, ]


# Identifier les valeurs les plus élevées de l'indice technologique

donnees[
  order(-donnees$Indice_ressources_technologiques),
  c("Nom_bibliotheque", "Indice_ressources_technologiques")
][1:10, ]


# ----- 3.7 Validation finale --------------------------------

# Objectif :
# Vérifier que le jeu de données enrichi est cohérent et prêt 
# pour les analyses.


# Vérifier les dimensions du tableau

dim(donnees)


# Vérifier les valeurs manquantes

colSums(is.na(donnees))


# ----- 3.8 Sauvegarde du jeu de données préparé -------------

# Objectif :
# Enregistrer le jeu de données préparé.


# Définir le dossier de destination

dossier_donnees <- file.path(
  "Donnees",
  "Donnees_preparees"
)


# Créer le dossier au besoin

if (!dir.exists(dossier_donnees)) {
  dir.create(dossier_donnees, recursive = TRUE)
}


# Définir le fichier de sortie

fichier_sortie <- file.path(
  dossier_donnees,
  "Bibliotheques_preparees.csv"
)


# Enregistrer le jeu de données préparé

write.csv(
  donnees,
  fichier_sortie,
  row.names = FALSE,
  fileEncoding = "UTF-8"
)


# Vérifier que le fichier a été créé

if (!file.exists(fichier_sortie)) {
  stop(
    "Le jeu de données préparé n'a pas pu être enregistré : ",
    fichier_sortie
  )
}


# Afficher un message de confirmation

cat(
  "\nLe jeu de données préparé a été enregistré dans :",
  file.path(getwd(), fichier_sortie),
  "\n"
)