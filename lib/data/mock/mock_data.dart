import 'package:flutter/material.dart';
import '../models/article.dart';
import '../models/author.dart';
import '../models/category.dart';
import '../models/market_index.dart';
import '../models/stock_quote.dart';
import '../models/subscription_plan.dart';

abstract class MockData {
  // 1. Mock Categories
  static const Category categoryBourse = Category(
    id: 'bourse',
    label: 'Bourse',
    colorHex: '0xFF1A365D',
    icon: Icons.candlestick_chart_rounded,
  );

  static const Category categoryImmobilier = Category(
    id: 'immobilier',
    label: 'Immobilier',
    colorHex: '0xFFA24823',
    icon: Icons.apartment_rounded,
  );

  static const Category categoryPlacements = Category(
    id: 'placements',
    label: 'Placements',
    colorHex: '0xFFC59B27',
    icon: Icons.savings_rounded,
  );

  static const Category categoryFiscalite = Category(
    id: 'fiscalite',
    label: 'Fiscalité',
    colorHex: '0xFF5C6B73',
    icon: Icons.receipt_long_rounded,
  );

  static const Category categoryAssurance = Category(
    id: 'assurance',
    label: 'Assurance',
    colorHex: '0xFF008080',
    icon: Icons.shield_rounded,
  );

  static final List<Category> categories = [
    categoryBourse,
    categoryImmobilier,
    categoryPlacements,
    categoryFiscalite,
    categoryAssurance,
  ];

  // 2. Mock Authors
  static const Author author1 = Author(
    id: 'a1',
    name: 'Christian Fontaine',
    avatarUrl: 'https://i.pravatar.cc/150?img=60',
  );

  static const Author author2 = Author(
    id: 'a2',
    name: 'Marianne Py',
    avatarUrl: 'https://i.pravatar.cc/150?img=47',
  );

  static const Author author3 = Author(
    id: 'a3',
    name: 'Gilles Leseul',
    avatarUrl: 'https://i.pravatar.cc/150?img=11',
  );

  static const Author author4 = Author(
    id: 'a4',
    name: 'Jérôme Bougarel',
    avatarUrl: 'https://i.pravatar.cc/150?img=33',
  );

  // 3. Mock Market Indices
  static final List<MarketIndex> marketIndices = [
    const MarketIndex(
      id: 'm1',
      name: 'CAC 40',
      value: 7842.15,
      variationPercent: 1.24,
    ),
    const MarketIndex(
      id: 'm2',
      name: 'S&P 500',
      value: 5137.08,
      variationPercent: -0.45,
    ),
    const MarketIndex(
      id: 'm3',
      name: 'Nasdaq',
      value: 16274.94,
      variationPercent: -0.82,
    ),
    const MarketIndex(
      id: 'm4',
      name: 'EUR / USD',
      value: 1.0845,
      variationPercent: 0.12,
    ),
    const MarketIndex(
      id: 'm5',
      name: 'Nikkei 225',
      value: 39120.70,
      variationPercent: 2.15,
    ),
    const MarketIndex(
      id: 'm6',
      name: 'Bitcoin',
      value: 62450.00,
      variationPercent: 4.89,
    ),
    const MarketIndex(
      id: 'm7',
      name: 'Or (oz)',
      value: 2082.40,
      variationPercent: 0.35,
    ),
    const MarketIndex(
      id: 'm8',
      name: 'Brent Crude',
      value: 83.55,
      variationPercent: -1.18,
    ),
  ];

  // 4. Mock Articles
  static final List<Article> articles = [
    // Featured Article 1 (Bourse Hero)
    Article(
      id: 'art1',
      title:
          'Bourse : le CAC 40 franchit un nouveau seuil historique porté par le luxe',
      excerpt:
          'Soutenu par des résultats d\'entreprises étincelants et les géants du luxe LVMH et Hermès, l\'indice parisien clôture la semaine à des sommets inédits. Notre analyse pour orienter votre portefeuille.',
      imageUrl: 'https://picsum.photos/seed/art1/800/500',
      category: categoryBourse,
      author: author1,
      publishedAt: DateTime.now().subtract(const Duration(minutes: 45)),
      readTimeMinutes: 5,
      isFeatured: true,
    ),
    // Featured Article 2 (Immobilier Hero)
    Article(
      id: 'art2',
      title:
          'Crédit immobilier : les banques ouvrent à nouveau les vannes en 2026',
      excerpt:
          'Après deux années de gel et de taux prohibitifs, les conditions d\'octroi se détendent enfin. Découvrez notre baromètre exclusif des taux région par région et comment négocier au mieux votre dossier.',
      imageUrl: 'https://picsum.photos/seed/art2/800/500',
      category: categoryImmobilier,
      author: author3,
      publishedAt: DateTime.now().subtract(const Duration(hours: 3)),
      readTimeMinutes: 6,
      isFeatured: true,
    ),
    // Standard Articles
    Article(
      id: 'art3',
      title:
          'Assurance-vie : faut-il encore arbitrer vers les fonds en euros cette année ?',
      excerpt:
          'Avec le regain des rendements obligataires, les assureurs rivalisent de bonus de versement. Est-ce le moment idéal pour sécuriser vos gains ou faut-il privilégier les unités de compte ?',
      imageUrl: 'https://picsum.photos/seed/art3/800/500',
      category: categoryAssurance,
      author: author2,
      publishedAt: DateTime.now().subtract(const Duration(hours: 1)),
      readTimeMinutes: 4,
      isFeatured: false,
    ),
    Article(
      id: 'art4',
      title:
          'Déclaration d\'impôts 2026 : ces 3 niches fiscales méconnues à activer d\'urgence',
      excerpt:
          'Investissements dans les PME, dons de proximité ou travaux de rénovation énergétique : optimisez votre feuille d\'imposition avant la date limite grâce à nos conseils d\'experts.',
      imageUrl: 'https://picsum.photos/seed/art4/800/500',
      category: categoryFiscalite,
      author: author4,
      publishedAt: DateTime.now().subtract(const Duration(hours: 5)),
      readTimeMinutes: 8,
      isFeatured: false,
    ),
    Article(
      id: 'art5',
      title:
          'Placements de précaution : le Livret A reste-t-il la meilleure option face à l\'inflation ?',
      excerpt:
          'Alors que son taux de rendement est gelé à 3%, nous comparons le livret réglementé aux comptes à terme et aux livrets bancaires boostés pour optimiser votre trésorerie court terme.',
      imageUrl: 'https://picsum.photos/seed/art5/800/500',
      category: categoryPlacements,
      author: author2,
      publishedAt: DateTime.now().subtract(const Duration(hours: 8)),
      readTimeMinutes: 4,
      isFeatured: false,
    ),
    Article(
      id: 'art6',
      title:
          'SCPI de rendement : vers une baisse généralisée des prix des parts ?',
      excerpt:
          'La correction des valeurs d\'expertises immobilières secoue le secteur de la pierre-papier. Panorama complet des SCPI qui résistent et de celles dont la décote offre des opportunités d\'achat.',
      imageUrl: 'https://picsum.photos/seed/art6/800/500',
      category: categoryImmobilier,
      author: author3,
      publishedAt: DateTime.now().subtract(const Duration(hours: 12)),
      readTimeMinutes: 7,
      isFeatured: false,
    ),
    Article(
      id: 'art7',
      title:
          'Action LVMH : après des sommets, est-il encore temps de monter à bord ?',
      excerpt:
          'Le leader mondial du luxe a publié des ventes records, rassurant les marchés sur sa dynamique en Asie et aux États-Unis. Quelle stratégie adopter sur le titre pour le reste de l\'année ?',
      imageUrl: 'https://picsum.photos/seed/art7/800/500',
      category: categoryBourse,
      author: author1,
      publishedAt: DateTime.now().subtract(const Duration(days: 1)),
      readTimeMinutes: 5,
      isFeatured: false,
    ),
    Article(
      id: 'art8',
      title:
          'Succession : comment transmettre votre patrimoine sans payer d\'impôts',
      excerpt:
          'Grâce à des abattements renouvelables tous les 15 ans et des structures juridiques comme la SCI ou le démembrement de propriété, préparez la transmission de vos biens en toute légalité.',
      imageUrl: 'https://picsum.photos/seed/art8/800/500',
      category: categoryFiscalite,
      author: author4,
      publishedAt: DateTime.now().subtract(const Duration(days: 1, hours: 4)),
      readTimeMinutes: 9,
      isFeatured: false,
    ),
    Article(
      id: 'art9',
      title:
          'PER (Plan d\'Épargne Retraite) : pourquoi c\'est le placement phare pour réduire votre impôt',
      excerpt:
          'Allier préparation de la retraite et déduction fiscale immédiate : le PER s\'impose chez les contribuables imposés à 30% et plus. Méthodologie pour verser au bon moment.',
      imageUrl: 'https://picsum.photos/seed/art9/800/500',
      category: categoryPlacements,
      author: author2,
      publishedAt: DateTime.now().subtract(const Duration(days: 1, hours: 8)),
      readTimeMinutes: 6,
      isFeatured: false,
    ),
    Article(
      id: 'art10',
      title:
          'Plan d\'épargne en actions (PEA) : notre sélection de 5 valeurs de rendement pour 2026',
      excerpt:
          'Dans un contexte de marchés volatils, miser sur des entreprises distribuant des dividendes solides et pérennes est une stratégie payante. Découvrez notre Top 5.',
      imageUrl: 'https://picsum.photos/seed/art10/800/500',
      category: categoryBourse,
      author: author1,
      publishedAt: DateTime.now().subtract(const Duration(days: 2)),
      readTimeMinutes: 5,
      isFeatured: false,
    ),
    Article(
      id: 'art11',
      title:
          'Pinel : fin du dispositif de défiscalisation, quelles alternatives pour le locatif neuf ?',
      excerpt:
          'Avec l\'extinction programmée du Pinel, les investisseurs doivent réorienter leurs projets. Focus sur le dispositif LMNP (Loueur en Meublé Non Professionnel) et le déficit foncier.',
      imageUrl: 'https://picsum.photos/seed/art11/800/500',
      category: categoryImmobilier,
      author: author3,
      publishedAt: DateTime.now().subtract(const Duration(days: 2, hours: 6)),
      readTimeMinutes: 7,
      isFeatured: false,
    ),
    Article(
      id: 'art12',
      title:
          'Assurance emprunteur : comment économiser des milliers d\'euros grâce à la loi Lemoine',
      excerpt:
          'La possibilité de résilier votre contrat à tout moment et sans frais permet de diviser la facture par deux pour des garanties équivalentes. Les étapes clés pour changer d\'assureur.',
      imageUrl: 'https://picsum.photos/seed/art12/800/500',
      category: categoryAssurance,
      author: author4,
      publishedAt: DateTime.now().subtract(const Duration(days: 2, hours: 12)),
      readTimeMinutes: 4,
      isFeatured: false,
    ),
    Article(
      id: 'art13',
      title:
          'Or physique : la valeur refuge s\'envole, notre guide complet pour en acheter en toute sécurité',
      excerpt:
          'Pièces de monnaie Napoléon, lingotins, plateformes en ligne ou banques traditionnelles : où acheter de l\'or physique sans payer de frais exorbitants et comment est imposée la revente ?',
      imageUrl: 'https://picsum.photos/seed/art13/800/500',
      category: categoryPlacements,
      author: author1,
      publishedAt: DateTime.now().subtract(const Duration(days: 3)),
      readTimeMinutes: 5,
      isFeatured: false,
    ),
    Article(
      id: 'art14',
      title:
          'Bourse US : Nvidia continue sa course folle, faut-il prendre ses bénéfices ?',
      excerpt:
          'La capitalisation boursière du géant de l\'IA flirte avec des records inimaginables. Entre valorisation tendue et carnet de commandes plein, nos recommandations de trading.',
      imageUrl: 'https://picsum.photos/seed/art14/800/500',
      category: categoryBourse,
      author: author1,
      publishedAt: DateTime.now().subtract(const Duration(days: 3, hours: 2)),
      readTimeMinutes: 6,
      isFeatured: false,
    ),
    Article(
      id: 'art15',
      title:
          'Contrôle fiscal : les nouveaux outils de détection par intelligence artificielle du fisc',
      excerpt:
          'Le fisc croise désormais réseaux sociaux, déclarations de revenus et images satellites. Les contribuables doivent redoubler de rigueur face aux algorithmes de Bercy.',
      imageUrl: 'https://picsum.photos/seed/art15/800/500',
      category: categoryFiscalite,
      author: author4,
      publishedAt: DateTime.now().subtract(const Duration(days: 3, hours: 6)),
      readTimeMinutes: 8,
      isFeatured: false,
    ),
    Article(
      id: 'art16',
      title:
          'Investir dans le viager : une solution gagnant-gagnant face à la crise immobilière ?',
      excerpt:
          'Pour les seniors désireux de monétiser leur logement et les acheteurs cherchant une décote sur le prix d\'acquisition, le viager recèle de réels atouts. Analyse financière.',
      imageUrl: 'https://picsum.photos/seed/art16/800/500',
      category: categoryImmobilier,
      author: author3,
      publishedAt: DateTime.now().subtract(const Duration(days: 4)),
      readTimeMinutes: 7,
      isFeatured: false,
    ),
    Article(
      id: 'art17',
      title:
          'Assurance-vie luxembourgeoise : les avantages secrets réservés aux gros patrimoines',
      excerpt:
          'Neutralité fiscale, super-privilège des souscripteurs et univers d\'investissement illimité : pourquoi les épargnants aisés choisissent de domicilier leur épargne au Luxembourg.',
      imageUrl: 'https://picsum.photos/seed/art17/800/500',
      category: categoryAssurance,
      author: author2,
      publishedAt: DateTime.now().subtract(const Duration(days: 4, hours: 8)),
      readTimeMinutes: 6,
      isFeatured: false,
    ),
  ];

  // 5. Mock Stock Quotes — typed by QuoteType
  static final List<StockQuote> stockQuotes = [
    const StockQuote(
      name: 'LVMH',
      ticker: 'MC',
      price: 812.40,
      variationPercent: 1.45,
      volume: '185K',
      type: QuoteType.stock,
      sparklinePoints: [790.0, 800.5, 795.0, 805.0, 808.0, 811.0, 812.4],
    ),
    const StockQuote(
      name: 'TotalEnergies',
      ticker: 'TTE',
      price: 64.18,
      variationPercent: -0.72,
      volume: '1.2M',
      type: QuoteType.stock,
      sparklinePoints: [65.5, 65.1, 64.9, 64.7, 64.5, 64.3, 64.18],
    ),
    const StockQuote(
      name: 'Sanofi',
      ticker: 'SAN',
      price: 89.50,
      variationPercent: 0.15,
      volume: '450K',
      type: QuoteType.stock,
      sparklinePoints: [89.0, 89.1, 89.3, 89.2, 89.4, 89.5, 89.5],
    ),
    const StockQuote(
      name: "L'Oréal",
      ticker: 'OR',
      price: 438.10,
      variationPercent: -1.12,
      volume: '120K',
      type: QuoteType.stock,
      sparklinePoints: [443.0, 441.5, 440.0, 439.5, 439.0, 438.5, 438.1],
    ),
    const StockQuote(
      name: 'BNP Paribas',
      ticker: 'BNP',
      price: 66.85,
      variationPercent: 2.34,
      volume: '980K',
      type: QuoteType.stock,
      sparklinePoints: [63.5, 64.0, 64.5, 65.0, 65.8, 66.4, 66.85],
    ),
    const StockQuote(
      name: 'Airbus',
      ticker: 'AIR',
      price: 158.20,
      variationPercent: 0.88,
      volume: '340K',
      type: QuoteType.stock,
      sparklinePoints: [156.5, 157.0, 157.2, 157.5, 157.8, 158.0, 158.2],
    ),
    const StockQuote(
      name: 'Schneider Electric',
      ticker: 'SU',
      price: 205.60,
      variationPercent: 1.15,
      volume: '290K',
      type: QuoteType.stock,
      sparklinePoints: [203.0, 203.5, 204.0, 204.5, 205.0, 205.3, 205.6],
    ),
    const StockQuote(
      name: 'Air Liquide',
      ticker: 'AI',
      price: 188.40,
      variationPercent: -0.42,
      volume: '190K',
      type: QuoteType.stock,
      sparklinePoints: [189.2, 189.0, 188.8, 188.7, 188.6, 188.5, 188.4],
    ),
  ];

  // 5b. Mock Index Quotes (European + US + Commodities)
  static final List<StockQuote> indexQuotes = [
    const StockQuote(
      name: 'CAC 40',
      ticker: 'FCHI',
      price: 7842.15,
      variationPercent: 1.24,
      volume: '—',
      type: QuoteType.indexQuote,
      sparklinePoints: [7700.0, 7730.0, 7760.0, 7780.0, 7800.0, 7825.0, 7842.15],
    ),
    const StockQuote(
      name: 'DAX',
      ticker: 'GDAXI',
      price: 18540.80,
      variationPercent: 0.78,
      volume: '—',
      type: QuoteType.indexQuote,
      sparklinePoints: [18300.0, 18360.0, 18420.0, 18450.0, 18490.0, 18520.0, 18540.8],
    ),
    const StockQuote(
      name: 'Eurostoxx 50',
      ticker: 'STOXX50E',
      price: 5020.40,
      variationPercent: 0.55,
      volume: '—',
      type: QuoteType.indexQuote,
      sparklinePoints: [4970.0, 4980.0, 4990.0, 5000.0, 5008.0, 5015.0, 5020.4],
    ),
    const StockQuote(
      name: 'S&P 500',
      ticker: 'SPX',
      price: 5137.08,
      variationPercent: -0.45,
      volume: '—',
      type: QuoteType.indexQuote,
      sparklinePoints: [5160.0, 5155.0, 5150.0, 5145.0, 5142.0, 5139.0, 5137.08],
    ),
    const StockQuote(
      name: 'Nasdaq',
      ticker: 'IXIC',
      price: 16274.94,
      variationPercent: -0.82,
      volume: '—',
      type: QuoteType.indexQuote,
      sparklinePoints: [16410.0, 16390.0, 16360.0, 16340.0, 16315.0, 16292.0, 16274.94],
    ),
    const StockQuote(
      name: 'Nikkei 225',
      ticker: 'N225',
      price: 39120.70,
      variationPercent: 2.15,
      volume: '—',
      type: QuoteType.indexQuote,
      sparklinePoints: [38280.0, 38500.0, 38750.0, 38950.0, 39000.0, 39080.0, 39120.7],
    ),
  ];

  // 5c. Mock Crypto Quotes
  static final List<StockQuote> cryptoQuotes = [
    const StockQuote(
      name: 'Bitcoin',
      ticker: 'BTC',
      price: 62450.00,
      variationPercent: 4.89,
      volume: '28.4B',
      type: QuoteType.crypto,
      sparklinePoints: [58000.0, 59500.0, 60200.0, 61000.0, 61800.0, 62100.0, 62450.0],
    ),
    const StockQuote(
      name: 'Ethereum',
      ticker: 'ETH',
      price: 3420.50,
      variationPercent: 3.12,
      volume: '12.1B',
      type: QuoteType.crypto,
      sparklinePoints: [3250.0, 3290.0, 3320.0, 3360.0, 3390.0, 3408.0, 3420.5],
    ),
    const StockQuote(
      name: 'Solana',
      ticker: 'SOL',
      price: 148.80,
      variationPercent: -2.15,
      volume: '3.5B',
      type: QuoteType.crypto,
      sparklinePoints: [154.0, 152.5, 151.0, 150.0, 149.5, 149.0, 148.8],
    ),
    const StockQuote(
      name: 'BNB',
      ticker: 'BNB',
      price: 582.30,
      variationPercent: 1.44,
      volume: '1.8B',
      type: QuoteType.crypto,
      sparklinePoints: [570.0, 573.0, 576.0, 578.0, 580.0, 581.5, 582.3],
    ),
    const StockQuote(
      name: 'XRP',
      ticker: 'XRP',
      price: 0.5285,
      variationPercent: -0.92,
      volume: '2.2B',
      type: QuoteType.crypto,
      sparklinePoints: [0.535, 0.533, 0.531, 0.530, 0.529, 0.528, 0.5285],
    ),
  ];

  // 6. Mock Subscription Plans
  static final List<SubscriptionPlan> subscriptionPlans = [
    const SubscriptionPlan(
      id: 'sub_digital',
      title: 'Le Revenu Mensuel – Digital',
      price: 29,
      pricePerIssue: 'Soit seulement 2,6€ par numéro',
      description: 'Idéal pour suivre l\'actualité financière en temps réel.',
      features: [
        'Accès illimité aux articles en ligne',
        'Magazine numérique (11 numéros/an)',
        'Questions à la rédaction',
      ],
      isPopular: false,
    ),
    const SubscriptionPlan(
      id: 'sub_paper_digital',
      title: 'Papier + Digital',
      price: 49,
      pricePerIssue: 'Économisez plus de 15€ vs le kiosque',
      description: 'Le meilleur des deux mondes pour ne rien rater.',
      features: [
        'Accès illimité en ligne',
        'Magazine numérique',
        '11 numéros papier livrés',
        'Questions à la rédaction',
      ],
      isPopular: true,
      badge: 'Plus populaire',
    ),
    const SubscriptionPlan(
      id: 'sub_hs',
      title: 'Papier + Digital + Hors-séries',
      price: 75,
      pricePerIssue: 'Économisez plus de 25€ vs le kiosque',
      description: 'Une expertise complète pour optimiser votre patrimoine.',
      features: [
        'Accès illimité',
        '6 guides sectoriels (fiscal, immobilier, bourse, épargne, actifs alternatifs, luxe & collection)',
        '11 numéros papier',
      ],
      isPopular: false,
    ),
    const SubscriptionPlan(
      id: 'sub_premium',
      title: 'Pack Premium',
      price: 440,
      pricePerIssue: null,
      description: 'L\'offre ultime pour les passionnés de finance.',
      features: [
        'Formule papier + digital complète',
        'Accès intégral Décision Bourse',
        'Réponses prioritaires de la rédaction',
        'Webinaires exclusifs avec nos analystes',
      ],
      isPopular: false,
    ),
  ];
}
