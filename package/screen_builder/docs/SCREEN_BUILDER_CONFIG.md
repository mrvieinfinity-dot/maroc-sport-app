Voici la traduction du guide technique en français. J'ai conservé les termes techniques (comme `build`, `package`, `widgets`) qui sont couramment utilisés en anglais par les développeurs, tout en traduisant les explications et les commentaires de code pour plus de clarté.

---

# Guide de Configuration de Screen Builder

## Vue d'ensemble

Screen Builder est un package Flutter qui vous permet de construire des écrans dynamiques à partir de configurations JSON. Ce guide explique comment configurer et utiliser le package dans votre application Flutter.

## Installation

Ajoutez ceci à votre fichier `pubspec.yaml` :

```yaml
dependencies:
  screen_builder:
    path: packages/screen_builder

```

## Initialisation

Initialisez Screen Builder dans votre fichier `main.dart` ou au démarrage de votre application :

```dart
import 'package:screen_builder/screen_builder.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initScreenBuilder(
    config: ScreenBuilderConfig(
      env: 'prod', // 'local', 'staging', 'prod'
      jsonPath: 'assets/pages/',
      homePage: 'home',
      navigationFile: 'assets/pages/navigation.json',
      apiAdapter: MyApiService(), // Service API personnalisé (optionnel)
      eventHandlers: [/* gestionnaires d'événements personnalisés */],
    ),
  );

  runApp(const DemoApp());
}

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ScreenBuilderPage(),
    );
  }
}
```

## Options de Configuration

### ScreenBuilderConfig

* `env` : Chaîne de caractère de l'environnement ('local', 'staging', 'prod'). Utilisée pour la logique conditionnelle.
* `jsonPath` : Chemin vers les fichiers JSON contenant les définitions des pages (ex : 'assets/pages/').
* `homePage` : Nom de la page d'accueil (sans extension .json).
* `navigationFile` : Chemin vers le fichier JSON de navigation.
* `apiAdapter` : Implémentation optionnelle personnalisée de `ApiService` pour les appels API.
* `eventHandlers` : Liste de `EventHandler` personnalisés pour gérer les événements.

## Structure JSON des Pages

Les pages sont définies dans des fichiers JSON avec une structure arborescente utilisant `component` et `children`. Exemple `home.json` :

```json
{
  "component": "screen",
  "props": { "title": "Page d'accueil" },
  "children": [
    { "component": "appbar", "props": { "title": "Bienvenue" } },
    {
      "component": "column",
      "children": [
        { "component": "text", "props": { "text": "Hello from home page" } },
        { "component": "spacer", "props": { "height": "m" } },
        {
          "component": "button",
          "props": { "text": "Aller au profil", "action": "navigate:profile" }
        }
      ]
    }
  ]
}
```

## Structure JSON de Navigation

La navigation est définie dans un fichier JSON séparé. Exemple `navigation.json` :

```json
{
  "items": [
    {
      "label": "Accueil",
      "icon": "home",
      "page": "home"
    },
    {
      "label": "Profil",
      "icon": "person",
      "page": "profile"
    }
  ]
}
```

### Composants Supportés

* **Composants UI** : `button` (bouton), `text` (texte), `image`, `popup`, `appbar`
* **Composants de mise en page** : `column` (colonne), `row` (ligne), `container` (conteneur), `spacer`, `screen`

### Actions

Les actions sont déclenchées par les composants :

* `Maps` : Naviguer vers une route
* `http` : Effectuer des appels API
* `custom` : Actions personnalisées

## Composant Popup

Le composant `popup` écoute les événements `api_success` et `api_error` et affiche des SnackBars.

Pour l'utiliser dans le JSON :

```json
{
  "type": "popup"
}

```

Les événements sont publiés par des actions, par exemple après un appel HTTP.

## Composants Personnalisés

Enregistrez vos composants personnalisés :

```dart
ComponentRegistry().register('my_component', (context, props) => MyWidget());

```

## Intégration API

Implémentez `ApiService` pour une gestion personnalisée de l'API :

```dart
class MyApiService implements ApiService {
  // Implémentez les méthodes
}

```

## Événements

Abonnez-vous aux événements :

```dart
EventBus().subscribe('my_event', (event) => print(event.payload));

```

## Navigation

Configurez l'adaptateur de navigation :

```dart
NavigationAdapter.setInstance(MyNavigationAdapter());

```

## Tests

Lancez les tests :

```bash
flutter test

```

## Application d'Exemple

Voir `example/demo_app.dart` pour un exemple complet.

---