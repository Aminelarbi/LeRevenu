# Le Revenu — Mobile Home Page (Flutter Technical Test)

This repository contains the home page implementation of a fictional mobile app for **Le Revenu**, a French financial and economic news media, developed as a Flutter technical test.

The app displays financial news covering stock markets (Bourse), real estate (Immobilier), personal investments (Placements), taxation (Fiscalité), and insurance (Assurance). It demonstrates clean architecture, visual brand alignment, custom motion design, and separation of concerns using Riverpod.

---

## 1. Overview

The application features:
* **Market Index Ticker**: An interactive, horizontal scrolling bar showing real-time market updates (e.g., CAC 40, S&P 500, Bitcoin) with visual up/down arrows and tabular numbers.
* **Cinematic Featured Stories ("À la une")**: A swipeable page view presenting primary editorial headlines with custom high-contrast gradient overlays and signature brand-red badges.
* **Categorized News Feed**: Interactive filtering tabs allowing immediate in-memory re-filtering of articles, rendered using a staggered entrance animation.
* **Fluid Shared-Element Transitions**: Hero animations that glide thumbnail/banner images from the homepage list directly into the detailed article screen.
* **Adaptive Light & Dark Themes**: Full support for system-wide light/dark appearances mapped directly to Le Revenu's visual brand identity.
* **Interactive Widget Gallery**: A developer-focused utility to inspect and isolate UI components under varying states.

### Preview / Mockups
You can find placeholders for app mockups in the `screenshots/` directory:

| Light Theme | Dark Theme |
| :---: | :---: |
| ![Home Light](screenshots/home_light.png) | ![Home Dark](screenshots/home_dark.png) |

| Article Detail | Widget Gallery |
| :---: | :---: |
| ![Article Detail](screenshots/article_detail.png) | ![Widget Gallery](screenshots/widget_gallery.png) |

---

## 2. Getting Started

### Prerequisites
* **Flutter SDK**: `^3.9.2` (or latest stable)
* **Dart SDK**: `^3.0.0` compatible environment

### Execution Commands
Clone the repository and run the following command to retrieve packages:
```bash
flutter pub get
```

Launch the application on your target simulator or physical device:
```bash
flutter run
```

> [!NOTE]
> All application data is mocked locally inside a static layer (`MockData` and `MockHomeRepository`). No internet connectivity, API credentials, or backend services are required to run this project.

---

## 3. Architecture

The codebase adheres to a **Features-first (Domain-driven)** clean directory layout, ensuring modularity, isolation of concerns, and ease of scaling:

```
lib/
├── core/
│   ├── constants/       # AppSizes and spacing constants
│   └── theme/           # AppTheme, AppColors, AppTypography, DateHelper
├── data/
│   ├── mock/            # Static mock data (MockData)
│   ├── models/          # Immutable entities (Article, Author, Category, MarketIndex)
│   └── repositories/    # Contracts (HomeRepository) and mock implementations (MockHomeRepository)
├── features/
│   ├── article_detail/  # Presentation screens for the article detail feature
│   └── home/            # Presentation widgets, HomeController, and state providers
├── shared/
│   └── widgets/         # Reusable widgets (CategoryChip, ShimmerBox, FadeInWidget, WidgetGallery)
└── main.dart            # Application bootstrap configuration
```

### Layering Flow
```
[ Presentation (UI) ] ──> [ HomeController (State) ] ──> [ HomeRepository (Data Contract) ] ──> [ MockHomeRepository (Mock Data Layer) ]
```

* **Data Domain Abstraction**: Widgets do not access data directly. They fetch records from the `HomeRepository` interface. If we replace the `MockHomeRepository` with a real REST or GraphQL API backend in the future, the UI code, controller, and models require **zero modifications**.
* **State Management**: Chosen **Riverpod** (`flutter_riverpod`) for state management. It provides compile-time safety, enforces unidirectional data flow, avoids context-coupling, and makes mocking/unit-testing individual controllers clean and straightforward.

---

## 4. Key Design Decisions

* **Slivers-based Layouts**: Instead of nesting nested scroll widgets, the main screen uses `CustomScrollView` and sliver nodes (`SliverAppBar`, `SliverList.builder`, `SliverToBoxAdapter`). This delegates layout calculation directly to the engine's lazy loader, avoiding heavy CPU decodes of image frames off-screen and keeping scrolling at a locked 60/120fps.
* **Component Reusability**: Component tags like `CategoryChip` are used by both interactive selectors and static cards. Styling changes, color values, or tag radius settings propagate across all screens from a single component declaration.
* **Motion & UX Polish**:
  * **Hero Transitions**: Images morph smoothly from cards or list rows into the detail banner on tap.
  * **Staggered Animations**: Feed items flow into view with cascading delays (`FadeInWidget` with index-based offsets).
  * **Tab Switch Crossfade**: `AnimatedSwitcher` handles feed-swapping cleanly during category re-filtering.
  * **Tabular Figures**: Numeric stock indicators in `MarketTickerBar` utilize `FontFeature.tabularFigures()` to prevent visual numbers-jitter.

---

## 5. Packages Used

| Package | Version | Justification / Purpose |
|---|---|---|
| `flutter_riverpod` | `^2.5.1` | State management, chosen for compile-time safety, clean provider overrides, and testability. |
| `google_fonts` | `^6.2.1` | Typography, used to cleanly load editorial and system font pairings without heavy asset bundling. |
| `shimmer` | `^3.0.0` | Loading indicators, used to provide a modern, skeleton-based shimmer effect matching layout shapes during data fetches. |
| `cupertino_icons` | `^1.0.8` | Fallback system icons for iOS style designs. |

---

## 6. What's Mocked / Limitations

* **Faux News & Tickers**: All index percentages, quotes, authors, and articles are generated locally and static on refresh.
* **Tab Navigation**: Only the "Home" tab contains active layouts. The "Bourse", "Actualités", "Placements", and "Profil" tabs show structural placeholders.
* **Deliberately Scoped Out**:
  * **Theme Switcher UI**: The app adapts to the system-wide Dark/Light setting (`ThemeMode.system`) rather than embedding manual toggles to save development time.
  * **Search & Alerts**: Search bar and notification actions display a "Coming Soon" Snackbar notification.

---

## 7. What I'd Do With More Time

1. **Real API Integration**: Hook the repository layer to a real economic/financial feeds endpoint (e.g. trading rates API, RSS feeds, or headless CMS).
2. **Comprehensive Automated Testing**: Expand the unit tests (which already validate repo fetching) to cover full widget pumps, controller state shifts, and golden screenshots.
3. **Accessibility Pass (A11y)**: Add clear semantic labels for screen readers (`Semantics` widgets) and verify contrast guidelines and dynamic text scaling limits.
4. **CI/CD Pipeline Setup**: Configure GitHub Actions to automatically run `flutter analyze`, `dart format`, and executing tests on commits.
5. **Brand Logo / SVG Integration**: Embed high-resolution SVGs for Le Revenu's official typography/mark instead of utilizing serif text.
