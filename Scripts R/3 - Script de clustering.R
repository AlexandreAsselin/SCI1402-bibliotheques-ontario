# ============================================================
# Analyse des bibliothèques publiques de l'Ontario (2021)
# Script de clustering
#
# Auteur : Alexandre Asselin
#
# Objectif :
# Regrouper les bibliothèques selon leurs principales
# caractéristiques afin d'identifier différents profils
# de bibliothèques publiques.
# ============================================================


# ------------------------------------------------------------
# SECTION 1 : IMPORTATION DES DONNÉES
# ------------------------------------------------------------

# Objectif général :
# Importer le jeu de données préparé utilisé pour l’analyse 
# de regroupement.


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


# Importer le jeu de données

donnees <- read.csv(fichier, stringsAsFactors = FALSE)


# Vérifier les dimensions

dim(donnees)


# ------------------------------------------------------------
# SECTION 2 : PRÉPARATION DES DONNÉES
# ------------------------------------------------------------

# Objectif général :
# Sélectionner les variables prévues pour le clustering et
# préparer les observations qui pourront être utilisées.


# ----- 2.1 Sélection des variables ---------------------------

# Objectif :
# Retenir les six variables qui seront utilisées pour regrouper 
# les bibliothèques selon leurs principales caractéristiques.


# Définir les variables de regroupement

variables_clustering <- c(
  "Population_desservie",
  "Nb_succursales",
  "Heures_ouverture",
  "Superficie",
  "Ratio_abonnes_population",
  "Indice_ressources_technologiques"
)


# Créer le tableau utilisé pour le clustering

donnees_clustering <- donnees[, variables_clustering]


# Vérifier les dimensions

dim(donnees_clustering)


# ----- 2.2 Vérification des valeurs manquantes ---------------

# Objectif :
# Vérifier la présence de valeurs manquantes dans les six variables
# retenues.


# Compter les valeurs manquantes par variable

colSums(is.na(donnees_clustering))


# Identifier les observations complètes

observations_completes <- complete.cases(donnees_clustering)


# Afficher les bibliothèques exclues en raison
# d'une valeur manquante

donnees[
  !observations_completes,
  c(
    "Nom_bibliotheque",
    "Superficie",
    "Indice_ressources_technologiques"
  )
]


# ----- 2.3 Sélection des observations complètes --------------

# Objectif :
# Conserver uniquement les bibliothèques qui possèdent une
# valeur pour chacune des six variables de regroupement.


# Conserver les observations complètes

donnees_clustering <- donnees_clustering[observations_completes,]


# Conserver les noms des bibliothèques correspondantes

noms_bibliotheques <- donnees$Nom_bibliotheque[observations_completes]


# Vérifier le tableau final

dim(donnees_clustering)


# ------------------------------------------------------------
# SECTION 3 : TRANSFORMATION ET STANDARDISATION DES VARIABLES
# ------------------------------------------------------------

# Objectif général :
# Examiner la distribution des variables, appliquer les
# transformations logarithmiques et standardiser les données
# avant le clustering.


# ----- 3.1 Distribution des variables ------------------------

# Objectif :
# Visualiser la distribution des six variables utilisées pour le 
# clustering.


# Définir les libellés des variables

libelles_variables <- c(
  "Population desservie",
  "Nombre de succursales",
  "Heures d'ouverture",
  "Superficie",
  "Ratio abonnés/population",
  "Indice technologique"
)


# Ouvrir une nouvelle fenêtre graphique

dev.new()


# Diviser la fenêtre en six graphiques

par(mfrow = c(2, 3))


# Créer les histogrammes

for (i in 1:length(variables_clustering)) {
  hist(
    donnees_clustering[[variables_clustering[i]]],
    main = libelles_variables[i],
    xlab = libelles_variables[i]
  )
}


# ----- 3.2 Transformation logarithmique ----------------------

# Objectif :
# Réduire l'influence des valeurs très élevées dans les
# quatre premières variables avant le clustering.


# Créer une copie des données

donnees_clustering_transformees <- donnees_clustering


# Transformer les quatre premières variables

for (i in 1:4) {
  donnees_clustering_transformees[, variables_clustering[i]] <-
    log10(donnees_clustering_transformees[, variables_clustering[i]])
}


# ----- 3.3 Distribution après transformation ----------------

# Objectif :
# Vérifier l'effet de la transformation logarithmique sur
# la distribution des quatre variables transformées.


# Ouvrir une nouvelle fenêtre graphique

dev.new()


# Diviser la fenêtre en quatre graphiques

par(mfrow = c(2, 2))


# Créer les histogrammes après transformation

for (i in 1:4) {
  hist(
    donnees_clustering_transformees[[variables_clustering[i]]],
    main = libelles_variables[i],
    xlab = "Valeurs après transformation log10"
  )
}


# ----- 3.4 Standardisation des variables ---------------------

# Objectif :
# Standardiser les six variables afin qu’elles soient comparables
# avant le clustering.

donnees_clustering_standardisees <- scale(donnees_clustering_transformees)


# ------------------------------------------------------------
# SECTION 4 : DÉTERMINATION DU NOMBRE DE GROUPES
# ------------------------------------------------------------

# Objectif général :
# Déterminer le nombre de groupes à utiliser avec la méthode
# du coude et la méthode de silhouette.


# ----- 4.1 Méthode du coude ----------------------------------

# Objectif :
# Observer la variation de l'inertie intra-groupes pour
# différents nombres de groupes.


# Créer un vecteur pour conserver les résultats

inertie <- numeric(10)


# Créer une liste pour conserver les clusterings

clusterings <- list()


# Fixer la sélection aléatoire

set.seed(20)


# Tester de 1 à 10 groupes

for (k in 1:10) {

  clusterings[[k]] <- kmeans(
    donnees_clustering_standardisees,
    centers = k,
    nstart = 20
  )

  inertie[k] <- sum(clusterings[[k]]$withinss)
}


# Afficher les résultats

inertie


# Ouvrir une nouvelle fenêtre graphique

dev.new()


# Créer le graphique de la méthode du coude

plot(
  inertie,
  type = "b",
  main = "Méthode du coude",
  xlab = "Nombre de groupes",
  ylab = "Inertie intra-groupes"
)


# ----- 4.2 Indice de silhouette ------------------------------

# Objectif :
# Comparer les solutions à deux, trois, quatre et cinq groupes 
# suggérées par la méthode du coude 


# Charger la bibliothèque cluster

library(cluster)


# Calculer les distances entre les bibliothèques

distances <- dist(donnees_clustering_standardisees)


# Créer un vecteur pour conserver
# les silhouettes moyennes

silhouettes_moyennes <- numeric(4)


# Calculer les silhouettes pour 2 à 5 groupes

for (k in 2:5) {

  # Calculer la silhouette

  s <- silhouette(
    clusterings[[k]]$cluster,
    distances
  )


  # Calculer la silhouette moyenne

  silhouettes_moyennes[k - 1] <- mean(s[, "sil_width"])


  # Ouvrir une nouvelle fenêtre graphique

  dev.new()


  # Afficher le graphique de silhouette

  plot(
    s,
    main = paste("Silhouette -", k, "groupes")
  )
}


# Créer un tableau récapitulatif

tableau_silhouettes <- data.frame(
  Nb_groupes = 2:5,
  Silhouette_moyenne = silhouettes_moyennes
)


# Arrondir les résultats

tableau_silhouettes$Silhouette_moyenne <-
  round(tableau_silhouettes$Silhouette_moyenne, 3)


# Afficher le tableau

tableau_silhouettes


# ----- 4.3 Comparaison des solutions -------------------------

# Objectif :
# Comparer la taille et les centres des groupes pour les
# solutions à deux et trois groupes.


# Solution à deux groupes

table(clusterings[[2]]$cluster)

round(clusterings[[2]]$centers, 2)


# Solution à trois groupes

table(clusterings[[3]]$cluster)

round(clusterings[[3]]$centers, 2)


# ----- 4.4 Choix de la solution finale -----------------------

# Objectif :
# Retenir la solution à trois groupes à partir des résultats
# obtenus dans les étapes précédentes.


# Retenir la solution à trois groupes

clustering_final <- clusterings[[3]]


# ------------------------------------------------------------
# SECTION 5 : REPRÉSENTATION DES GROUPES AVEC L'ACP
# ------------------------------------------------------------

# Objectif général :
# Représenter les groupes K-means selon les deux premières
# composantes principales.


# ----- 5.1 Réalisation de l'ACP ------------------------------

# Objectif :
# Réaliser une ACP à partir des mêmes variables standardisées
# que celles utilisées pour le K-means.


# Réaliser l'ACP

acp_clustering <- prcomp(
  donnees_clustering_standardisees,
  center = FALSE,
  scale. = FALSE
)


# Afficher le résumé de l'ACP

summary(acp_clustering)


# Afficher la contribution des variables

round(acp_clustering$rotation, 3)


# ----- 5.2 Représentation des groupes ------------------------

# Objectif :
# Représenter les bibliothèques selon les deux premières
# composantes principales et leur groupe K-means.


# Extraire les coordonnées des bibliothèques

coordonnees_acp <- acp_clustering$x


# Inverser la deuxième composante

coordonnees_acp[, 2] <- -coordonnees_acp[, 2]


# Définir les noms des groupes

noms_groupes <- c("Groupe 1", "Groupe 2", "Groupe 3")


# Définir les couleurs des groupes

couleurs_groupes <- c("#8064A2", "#ED7D31", "#70AD47")


# Ouvrir une nouvelle fenêtre graphique

dev.new()


# Représenter les groupes selon les deux premières composantes

plot(
  coordonnees_acp[, 1],
  coordonnees_acp[, 2],
  col = couleurs_groupes[clustering_final$cluster],
  pch = 20,
  xlab = "PC1 - Taille du réseau (59,6 %)",
  ylab = "PC2 - Abonnés et technologie (20,2 %)",
  main = "Groupes de bibliothèques - ACP"
)


# Ajouter une légende

legend(
  "topright",
  legend = noms_groupes,
  col = couleurs_groupes,
  pch = 20
)


# ------------------------------------------------------------
# SECTION 6 : DESCRIPTION ET VISUALISATION DES GROUPES
# ------------------------------------------------------------

# Objectif général :
# Décrire et représenter les trois groupes obtenus afin de
# faciliter l'interprétation des profils de bibliothèques.


# ----- 6.1 Création du tableau des résultats -----------------

# Objectif :
# Associer chaque bibliothèque à son groupe et aux valeurs
# originales des variables utilisées dans le clustering.


# Créer le tableau des résultats

resultats_clustering <- data.frame(
  Nom_bibliotheque = noms_bibliotheques,
  Groupe = clustering_final$cluster,
  donnees_clustering
)


# Afficher les premières observations

head(resultats_clustering)


# ----- 6.2 Profil standardisé des groupes --------------------

# Objectif :
# Comparer les centres des trois groupes sur les six variables
# standardisées utilisées dans le clustering.


# Ouvrir une nouvelle fenêtre graphique

dev.new()


# Ajuster les marges du graphique

par(mar = c(9, 4, 4, 9))


# Créer le diagramme en barres

barplot(
  clustering_final$centers,
  beside = TRUE,
  names.arg = libelles_variables,
  col = couleurs_groupes,
  main = "Profil standardisé des groupes",
  ylab = "Score Z"
)


# Ajouter une ligne représentant la moyenne

abline(h = 0, lty = 2)


# Ajouter la légende

legend(
  "topright",
  inset = c(-0.3, 0),
  xpd = TRUE,
  legend = noms_groupes,
  fill = couleurs_groupes
)


# ----- 6.3 Nuages de points ----------------------------------

# Objectif :
# Visualiser les groupes selon deux combinaisons de variables 
# qui font ressortir leurs principales différences.

# Population et indice technologique

dev.new()

plot(
  resultats_clustering$Population_desservie,
  resultats_clustering$Indice_ressources_technologiques,
  log = "x",
  pch = 20,
  col = couleurs_groupes[resultats_clustering$Groupe],
  main = "Population et indice technologique",
  xlab = "Population desservie",
  ylab = "Indice technologique"
)

legend(
  "topright",
  legend = noms_groupes,
  col = couleurs_groupes,
  pch = 20
)


# Ratio d'abonnés et indice technologique

dev.new()

plot(
  resultats_clustering$Ratio_abonnes_population,
  resultats_clustering$Indice_ressources_technologiques,
  pch = 20,
  col = couleurs_groupes[resultats_clustering$Groupe],
  main = "Utilisation et offre technologique",
  xlab = "Ratio abonnés/population",
  ylab = "Indice technologique"
)

legend(
  "topright",
  legend = noms_groupes,
  col = couleurs_groupes,
  pch = 20
)


# ------------------------------------------------------------
# SECTION 7 : SYNTHÈSE ET SAUVEGARDE DES RÉSULTATS
# ------------------------------------------------------------

# Objectif général :
# Résumer les caractéristiques des trois profils et enregistrer
# les principaux résultats du clustering.


# ----- 7.1 Attribution d'un nom aux profils ------------------

# Objectif :
# Attribuer un nom descriptif à chacun des trois groupes.


# Définir les noms des profils

noms_profils <- c(
  "Grands réseaux de bibliothèques",
  "Bibliothèques locales intermédiaires",
  "Petites bibliothèques à forte offre technologique"
)


# Ajouter le nom du profil au tableau des résultats

resultats_clustering$Profil <- noms_profils[resultats_clustering$Groupe]


# Vérifier les premières observations

head(resultats_clustering[, c("Nom_bibliotheque", "Groupe", "Profil")])


# ----- 7.2 Création du tableau synthèse des profils ----------

# Objectif :
# Présenter les principales caractéristiques des trois profils
# à partir des valeurs médianes.


# Calculer les médianes par groupe

medianes_groupes <- aggregate(
  donnees_clustering,
  by = list(Groupe = clustering_final$cluster),
  FUN = median
)


# Calculer la taille des groupes

taille_groupes <- table(clustering_final$cluster)


# Créer le tableau synthèse

tableau_profils <- data.frame(
  Groupe = 1:3,
  Profil = noms_profils,
  Nb_bibliotheques = as.numeric(taille_groupes),
  Population_mediane = medianes_groupes$Population_desservie,
  Succursales_medianes = medianes_groupes$Nb_succursales,
  Heures_ouverture_medianes = medianes_groupes$Heures_ouverture,
  Superficie_mediane = medianes_groupes$Superficie,
  Ratio_abonnes_median = medianes_groupes$Ratio_abonnes_population,
  Indice_technologique_median = medianes_groupes$Indice_ressources_technologiques
)


# Afficher le tableau

tableau_profils


# ----- 7.3 Création des profils standardisés -----------------

# Objectif :
# Préparer les centres standardisés pour le tableau de bord.


# Créer un tableau vide

profils_standardises <- data.frame(
  Groupe = integer(),
  Profil = character(),
  Variable = character(),
  Score_Z = numeric(),
  stringsAsFactors = FALSE
)


# Parcourir les trois groupes

for (groupe in 1:3) {
  

  # Parcourir les six variables
  
  for (i in 1:length(variables_clustering)) {
    

    # Créer une ligne
    
    ligne <- data.frame(
      Groupe = groupe,
      Profil = noms_profils[groupe],
      Variable = libelles_variables[i],
      Score_Z = clustering_final$centers[groupe, i],
      stringsAsFactors = FALSE
    )
    
    
    # Ajouter la ligne au tableau
    
    profils_standardises <- 
      rbind(profils_standardises, ligne)
  }
}


# Arrondir les scores Z

profils_standardises$Score_Z <- round(profils_standardises$Score_Z, 2)


# Afficher le tableau

profils_standardises


# ----- 7.4 Création du dossier de résultats ------------------

# Objectif :
# Créer le dossier destiné à enregistrer les résultats du clustering.


# Définir le dossier de destination

dossier_resultats <- file.path("Resultats", "Clustering")


# Créer le dossier au besoin

if (!dir.exists(dossier_resultats)) {
  dir.create(dossier_resultats, recursive = TRUE)
}


# ----- 7.5 Sauvegarde des résultats --------------------------

# Objectif :
# Enregistrer les résultats du clustering par bibliothèque et 
# le tableau synthèse des trois profils.


# Enregistrer les résultats par bibliothèque

write.csv(
  resultats_clustering,
  file.path(dossier_resultats, "Resultats_clustering_bibliotheques.csv"),
  row.names = FALSE,
  fileEncoding = "UTF-8"
)

# Enregistrer le tableau des profils

write.csv(
  tableau_profils,
  file.path(dossier_resultats, "Profils_bibliotheques.csv"),
  row.names = FALSE,
  fileEncoding = "UTF-8"
)


# Enregistrer les profils standardisés

write.csv(
  profils_standardises,
  file.path(dossier_resultats, "Profils_standardises.csv"),
  row.names = FALSE,
  fileEncoding = "UTF-8"
)