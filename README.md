# Analyse de l’offre technologique et des profils des bibliothèques publiques de l’Ontario

Ce projet utilise les données de 2021 du programme *Ontario Public Library Statistics* afin d’analyser l’offre technologique des bibliothèques publiques de l’Ontario. Il vise à étudier les caractéristiques qui lui sont associées, son lien avec l’utilisation des bibliothèques et les profils qui émergent des données.

Le projet comprend la préparation et l’enrichissement des données, la construction d’un indice d’offre technologique et du ratio abonnés/population, des analyses statistiques descriptives et multivariées, une analyse de regroupement par *K-means* ainsi qu’un tableau de bord interactif réalisé avec Power BI.

## Objectifs du projet

Le projet poursuit trois objectifs complémentaires :

- brosser un portrait des bibliothèques publiques de l’Ontario à partir de leurs principales caractéristiques;
- analyser les facteurs associés à l’offre de ressources technologiques et examiner sa relation avec l’utilisation des bibliothèques;
- identifier différents profils de bibliothèques présentant des caractéristiques similaires.

## Questions de recherche

Le projet cherche à répondre aux trois questions suivantes :

1. Offre technologique et caractéristiques des bibliothèques  
     Quelles caractéristiques des bibliothèques publiques de l’Ontario sont associées à une offre technologique plus développée?

2. Offre technologique et utilisation  
     Existe-t-il une relation entre l’offre technologique des bibliothèques publiques de l’Ontario et leur ratio abonnés/population?

3. Profils de bibliothèques    
     Peut-on identifier différents profils de bibliothèques publiques de l’Ontario à partir des variables retenues?
   
## Source des données

Le projet utilise les données de 2021 du programme *Ontario Public Library Statistics*, qui recueille annuellement des statistiques sur les bibliothèques publiques et les bibliothèques publiques des Premières Nations de l’Ontario.

Le fichier utilisé dans ce projet a été obtenu à partir du jeu de données *Ontario Public Library Statistics 2021*, publié par Sophie Bicanic sur Kaggle. Celui-ci provient des données ouvertes publiées par le gouvernement de l’Ontario.

- Source utilisée : [Ontario Public Library Statistics 2021 – Kaggle](https://www.kaggle.com/datasets/sophiebicanic/ontario-public-library-statistics)
- Source originale : [Gouvernement de l’Ontario – Ontario Public Library Statistics](https://data.ontario.ca/en/dataset/ontario-public-library-statistics)
- Licence : [Open Government Licence – Ontario](https://www.ontario.ca/page/open-government-licence-ontario)

Le dépôt contient le fichier de données brutes utilisé pour le projet ainsi qu’une version préparée et enrichie produite au cours de l’analyse.

## Méthodologie

Le projet suit une démarche de science des données allant de la préparation des données à la communication des résultats.

### Préparation et enrichissement des données

Les données brutes ont été vérifiées et nettoyées afin de corriger les anomalies d’importation, traiter les valeurs manquantes et convertir les variables au format approprié. Deux indicateurs ont ensuite été construits :

- un indice de ressources technologiques, obtenu à partir de ressources technologiques rapportées à la population puis standardisées;
- un ratio abonnés/population, représentant la proportion d’abonnés actifs par rapport à la population desservie.

### Analyse statistique

Les principales variables ont d’abord été étudiées à l’aide de statistiques descriptives et de visualisations. Les relations avec l’indice de ressources technologiques ont ensuite été examinées à l’aide de corrélations de Pearson et de modèles de régression linéaire multiple.

Une analyse en composantes principales (ACP) a également été réalisée afin d’explorer conjointement les relations entre les variables et de produire une représentation multivariée des bibliothèques.

### Clustering

Un regroupement par K-means a été réalisé à partir de six variables standardisées. Le nombre de groupes a été évalué à l’aide de la méthode du coude et de l’indice de silhouette. Les groupes obtenus ont ensuite été décrits et interprétés afin d’identifier différents profils de bibliothèques.

### Visualisation

Les principaux résultats ont finalement été intégrés à un tableau de bord interactif réalisé avec Power BI. Celui-ci permet d’explorer les caractéristiques des bibliothèques, les relations étudiées et les profils obtenus lors du clustering.

## Principaux résultats

### Relations avec l’offre technologique

Les analyses montrent que l’indice de ressources technologiques varie selon plusieurs caractéristiques des bibliothèques. Les corrélations de Pearson indiquent notamment une relation négative avec la population desservie, les heures d’ouverture, le nombre de succursales et la superficie, ainsi qu’une relation positive avec le ratio abonnés/population.

La régression multiple permet de considérer simultanément plusieurs de ces caractéristiques. Le modèle complet explique environ 35 % de la variation de l’indice de ressources technologiques. Les résultats montrent également que certaines relations observées individuellement changent lorsque les autres variables sont prises en compte.

### Analyse multivariée

L’analyse en composantes principales (ACP) montre que les deux premières composantes expliquent environ 88 % de la variance totale. La première composante représente principalement la taille et l’ampleur des bibliothèques, en regroupant la population desservie, les heures d’ouverture, le nombre de succursales et la superficie. La deuxième composante fait davantage ressortir le ratio abonnés/population.

Cette représentation permet de résumer les principales différences entre les bibliothèques à partir d’un nombre réduit de dimensions et de visualiser leur positionnement les unes par rapport aux autres.

### Profils de bibliothèques

L’analyse de clustering par K-means a conduit à retenir trois groupes de bibliothèques :

- les grands réseaux de bibliothèques, caractérisés par une population desservie, un nombre de succursales, des heures d’ouverture et une superficie relativement élevés;
- les bibliothèques locales intermédiaires, qui présentent généralement des valeurs plus près de la moyenne ou légèrement inférieures pour les variables étudiées;
- les petites bibliothèques à forte offre technologique, qui se distinguent par leur petite taille ainsi que par un ratio abonnés/population et un indice de ressources technologiques particulièrement élevés.

Le clustering met ainsi en évidence un petit groupe de bibliothèques qui, malgré des ressources structurelles plus limitées, se distinguent par une offre technologique élevée relativement à la population qu’elles desservent.

## Tableau de bord interactif

Un tableau de bord interactif a été réalisé avec Power BI afin de rendre les résultats du projet accessibles et de permettre leur exploration.

Il comprend quatre pages :

- Portrait : vue d’ensemble des principales caractéristiques des bibliothèques;
- Relations : exploration des relations entre l’indice de ressources technologiques et les variables analysées;
- Profils : comparaison des trois profils de bibliothèques obtenus par clustering;
- Exploration : consultation détaillée et comparaison des bibliothèques.

### Consulter le tableau de bord

[Ouvrir le tableau de bord Power BI](https://app.powerbi.com/view?r=eyJrIjoiZDE5NDVjMDctMDhiZC00ODAwLWFkZjctOTEzOWI2YThjNjNiIiwidCI6ImQ0MWZkYWIxLTdlMTUtNGNmZC1iNWZhLTcyMDBlNTRkZWI2YiJ9&pageName=552b78830a1c9dae1a77)

Le [fichier source Power BI](Tableau_de_bord.pbix) est également disponible dans ce dépôt et peut être ouvert avec Power BI Desktop.

## Structure du dépôt

- Donnees/ : données brutes et données préparées utilisées dans le projet;
- Scripts R/ : scripts de préparation des données, d’analyse statistique et de clustering;
- Resultats/ : résultats exportés des analyses statistiques et du clustering;
- Rapports/ : rapports techniques et documents présentant l’évolution du projet;
- Tableau_de_bord.pbix : fichier source du tableau de bord Power BI.

## Reproduire les analyses

Les analyses peuvent être reproduites à partir des scripts R disponibles dans le dossier Scripts R/.

Les scripts utilisent des chemins relatifs. Le dossier racine du dépôt doit donc être utilisé comme dossier de travail dans R avant leur exécution.

Les scripts doivent être exécutés dans l’ordre suivant :

1. Script de préparation et d’enrichissement des données
Importe le fichier de données brutes, effectue les opérations de préparation et construit les indicateurs utilisés dans le projet. Le jeu de données obtenu est enregistré dans Donnees/Donnees_preparees/.

2. Script d’analyse statistique
Utilise le jeu de données préparé pour produire les statistiques descriptives, les analyses de corrélation, les régressions multiples et l’analyse en composantes principales (ACP). Les résultats exportés sont enregistrés dans Resultats/Analyse_statistique/.

3. Script de clustering
Utilise le jeu de données préparé pour réaliser le clustering par K-means, évaluer le nombre de groupes et décrire les profils obtenus. Les résultats exportés sont enregistrés dans Resultats/Clustering/.

### Environnement

Les analyses ont été réalisées avec R et RStudio. Certains scripts utilisent des packages supplémentaires qui sont chargés au début des sections concernées.

Le tableau de bord a été réalisé séparément avec Microsoft Power BI Desktop à partir des données et résultats produits au cours du projet.

## Auteur

Alexandre Asselin

Projet réalisé dans le cadre du cours SCI1402 - Projet en science des données à la TÉLUQ, dans le cadre du certificat en science des données.

Année : 2026
