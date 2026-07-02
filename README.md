# Le Revenu - Test technique Flutter

Application mobile Flutter réalisée dans le cadre d'un test technique pour Overlord Technologies. Le projet reproduit une expérience éditoriale inspirée de Le Revenu, média français spécialisé dans l'information financière, patrimoniale et boursière.

L'application propose un fil d'actualité, un carrousel "À la une", un bandeau de marché animé, une rubrique Bourse, une recherche locale, des écrans de détail, une section Placements, un profil utilisateur simulé et un parcours d'abonnement. Le travail met surtout l'accent sur la structure du code, la séparation des responsabilités, les composants réutilisables et une interface mobile cohérente avec un univers média financier.

---

## 1. Aperçu et captures d'écran

Les captures ci-dessous correspondent à de vrais écrans de l'application exécutée, et non à des placeholders.

| Accueil clair | Accueil sombre |
| :---: | :---: |
| ![Accueil clair](screenshots/home_light.png) | ![Accueil sombre](screenshots/home_dark.png) |

| Détail d'article |
| :---: |
| ![Détail d'article](screenshots/article_detail.png) |

Fonctionnalités principales :

* **Accueil éditorial** : articles mis en avant, fil d'actualité, filtres par rubrique et bannière d'abonnement.
* **Ticker boursier animé** : bandeau horizontal avec indices, variations positives ou négatives et chiffres alignés.
* **Rubrique Bourse** : indices, actions, cryptomonnaies, tri par nom, hausses ou baisses, fiches de valeurs et graphiques simulés.
* **Recherche locale** : recherche dans les titres et extraits, avec filtrage par rubrique.
* **Thèmes clair et sombre** : l'application suit le thème système via `ThemeMode.system`.
* **Micro-interactions** : carrousel automatique, transitions `Hero`, animations d'apparition et skeleton loaders.

---

## 2. Installation et lancement

### Prérequis

Le projet a été vérifié avec :

* Flutter 3.35.7, canal stable
* Dart 3.9.2

Le fichier `pubspec.yaml` déclare :

```yaml
environment:
  sdk: ^3.9.2
```

### Commandes

```bash
flutter pub get
flutter run
```

Toutes les données sont fictives et déclarées localement dans `lib/data/mock/mock_data.dart`. Aucune API, clé d'accès, base de données ou configuration serveur n'est nécessaire.

---

## 3. Architecture du projet

Le projet suit une organisation orientée fonctionnalités, avec des couches communes pour le thème, les modèles et les composants partagés.

```text
lib/
  main.dart
  core/
    constants/
      app_sizes.dart
    theme/
      app_colors.dart
      app_theme.dart
      app_typography.dart
      date_helper.dart
  data/
    mock/
      mock_data.dart
    models/
      article.dart
      author.dart
      category.dart
      market_index.dart
      stock_quote.dart
      subscription_plan.dart
    providers/
      data_providers.dart
    repositories/
      home_repository.dart
      mock_home_repository.dart
  features/
    actualites/
    article_detail/
    bourse/
    home/
    placements/
    profil/
    search/
    splash/
    subscription/
  shared/
    widgets/
```

### Rôle des dossiers

* `core/` contient les fondations visuelles communes : couleurs, typographie, thème clair/sombre, espacements et aide au formatage des dates.
* `data/models/` contient les modèles métier immuables : `Article`, `Author`, `Category`, `MarketIndex`, `StockQuote` et `SubscriptionPlan`.
* `data/mock/` centralise toutes les données fictives utilisées par l'application.
* `data/repositories/` définit le contrat `HomeRepository` et son implémentation fictive `MockHomeRepository`.
* `data/providers/` expose les sources de données via Riverpod.
* `features/` regroupe les écrans par domaine fonctionnel : accueil, bourse, actualités, placements, profil, recherche, détail d'article, splash screen et abonnement.
* `shared/widgets/` rassemble les composants réutilisables : cartes d'articles, barre de catégories, ticker, navigation basse, shimmer, en-têtes de section et animations.

### Découpage en couches

Le flux principal de données de l'accueil suit cette chaîne :

```text
MockData
  -> MockHomeRepository
  -> HomeRepository
  -> homeRepositoryProvider
  -> HomeController
  -> HomeState
  -> HomeScreen
```

`MockData` représente la source de données actuelle. `MockHomeRepository` simule une couche d'accès aux données avec un délai artificiel, ce qui permet d'afficher de vrais états de chargement. `HomeRepository` sert de contrat : l'interface ne dépend donc pas directement de la donnée fictive.

`HomeController` orchestre le chargement initial, le rafraîchissement, les erreurs, les filtres par catégorie et la liste d'articles affichée. `HomeState` garde un état explicite : chargement, rafraîchissement, articles complets, articles filtrés, articles mis en avant, catégories, indices de marché et message d'erreur.

Cette séparation facilite une future intégration API. Il suffirait d'ajouter un repository réseau qui implémente `HomeRepository`, puis de remplacer le provider. Les écrans et widgets n'auraient pas besoin de connaître le détail de la nouvelle source de données.

### Gestion d'état

La gestion d'état repose sur `flutter_riverpod`, principalement avec `StateNotifierProvider<HomeController, HomeState>` pour l'accueil. Riverpod a été choisi pour garder une injection claire des dépendances, éviter de coupler l'état au `BuildContext` et rendre les contrôleurs plus simples à tester.

Les autres écrans utilisent de l'état local quand le besoin reste limité : tri dans Actualités, segment et tri dans Bourse, période de graphique dans le détail d'une valeur, recherche avec debounce, sélection mensuelle ou annuelle dans l'écran Abonnement.

### Organisation des fonctionnalités

* `home/` pilote l'expérience principale : `HomeScreen`, `HomeController`, `HomeState` et provider Riverpod.
* `bourse/` contient une section autonome avec app bar dédiée, cartes d'indices, lignes de valeurs, tri, détail de valeur, graphique simulé et actualités liées.
* `actualites/` affiche la liste complète des articles avec filtre par catégorie et tri par récence ou popularité simulée.
* `placements/` propose un simulateur visuel non fonctionnel, des guides thématiques et des articles de placement.
* `profil/` présente un profil utilisateur fictif, un état d'abonnement simulé et des entrées de paramètres non fonctionnelles.
* `search/` fournit une recherche locale avec debounce et normalisation simple des accents.
* `subscription/` affiche les formules d'abonnement, une FAQ et une boîte de dialogue indiquant que le paiement n'est pas implémenté.

---

## 4. Choix techniques et design

### Identité visuelle

La palette est centralisée dans `AppColors`. Le rouge sert de couleur de marque pour les appels à l'action, les badges et les éléments premium. Le bleu marine structure les zones éditoriales et les titres. Les hausses et baisses de marché utilisent des couleurs sémantiques distinctes.

Les rubriques disposent aussi de couleurs propres : Bourse, Immobilier, Placements, Fiscalité et Assurance. L'objectif est de conserver une interface sobre, lisible et crédible pour un média financier.

### Typographie

La typographie est définie dans `AppTypography` avec `google_fonts` :

* `Playfair Display` pour les titres éditoriaux et les grandes accroches.
* `Inter` pour les textes d'interface, libellés, listes et chiffres.

Ce choix permet de combiner une identité éditoriale avec une lecture confortable sur mobile.

### Interface et performance

L'accueil et la section Bourse utilisent des `CustomScrollView` avec slivers (`SliverAppBar`, `SliverList`, `SliverToBoxAdapter`). Cette approche évite d'empiler plusieurs zones scrollables et garde une structure adaptée aux longues listes.

Les widgets partagés évitent la duplication : une même carte d'article est utilisée dans l'accueil, Actualités, Placements, Bourse, Recherche et les actualités liées. Les fichiers de la section Bourse sont volontairement découpés en sous-widgets pour garder les écrans lisibles.

### Animations et détails UX

* Le carrousel "À la une" utilise un `PageView` avec avancement automatique et indicateurs de page.
* Le ticker boursier simule un flux financier continu avec une animation horizontale.
* Les listes utilisent `FadeInWidget` pour une apparition progressive des contenus.
* Les transitions `Hero` relient visuellement les cartes d'articles aux écrans de détail.
* Les skeleton loaders avec `shimmer` rendent les états de chargement plus proches d'une application réelle.
* Le splash screen utilise à la fois une configuration native et un écran Flutter dédié.

---

## 5. Composants réutilisables

* `ArticleListTile` : utilisé dans l'accueil, Actualités, Placements, Bourse, Recherche et les actualités liées aux valeurs boursières.
* `SectionHeader` : utilisé dans l'accueil, Bourse, Placements et la galerie de composants interne.
* `CategoryTabBar` : utilisé dans l'accueil et Actualités pour filtrer les articles par rubrique.
* `MarketTickerBar` : utilisé sur l'accueil pour afficher les indices de marché.
* `FadeInWidget` : utilisé pour animer l'arrivée progressive des listes.
* `AppBottomNavBar` : utilisé comme navigation principale entre Accueil, Bourse, Actualités, Placements et Profil.

---

## 6. Packages utilisés

| Package | Version | Utilisation |
|---|---:|---|
| `flutter_riverpod` | `^2.5.1` | Gestion d'état et injection du repository pour l'accueil. |
| `google_fonts` | `^6.2.1` | Chargement des polices `Playfair Display` et `Inter`. |
| `shimmer` | `^3.0.0` | Skeleton loaders pendant les états de chargement. |
| `cupertino_icons` | `^1.0.8` | Dépendance Flutter standard déclarée dans le projet, non utilisée directement dans `lib/`. |
| `flutter_native_splash` | `^2.4.0` | Génération du splash screen natif. |
| `flutter_launcher_icons` | `^0.13.1` | Génération des icônes d'application. |

---

## 7. Données simulées et limites connues

* Les articles, auteurs, indices, actions, cryptomonnaies, abonnements et informations de profil sont fictifs.
* Il n'y a pas de backend, d'authentification, de paiement réel ni de persistance locale.
* Les boutons secondaires comme notifications, paramètres, aide, mentions légales, déconnexion, simulateur de placements et suivi d'une valeur affichent un message "à venir".
* Les graphiques boursiers sont générés localement à partir de séries simulées.
* Les images d'articles et d'auteurs proviennent d'URLs publiques de démonstration.
* Certains textes dans le code source présentent des problèmes d'encodage d'accents à corriger avant une livraison réelle.

---

## 8. Améliorations possibles

1. Brancher une vraie API éditoriale et financière derrière `HomeRepository`.
2. Ajouter des tests widgets sur les principaux écrans et des tests unitaires plus complets sur les contrôleurs.
3. Renforcer l'accessibilité : labels sémantiques, contraste, tailles de texte dynamiques et navigation clavier.
4. Ajouter une persistance locale pour les favoris, les préférences et les derniers contenus consultés.
5. Mettre en place une intégration continue avec `flutter analyze`, `dart format` et `flutter test`.
