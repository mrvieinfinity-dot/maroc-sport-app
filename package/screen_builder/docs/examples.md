# Exemples d'utilisation

## Vue d'ensemble

Cette section présente des exemples pratiques d'utilisation du système de navigation Screen Builder.

## Configuration de base

### Initialisation de l'application

```dart
// main.dart
import 'package:flutter/material.dart';
import 'package:screen_builder/screen_builder.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ScreenConfig(
        navigationPath: 'assets/pages/navigation.json',
        child: ScreenBuilderPage(),
      ),
    );
  }
}
```

### Configuration de navigation

```json
// assets/pages/navigation.json
{
  "navigation": {
    "type": "bottom",
    "items": [
      {
        "label": "Accueil",
        "icon": "home",
        "route": "home"
      },
      {
        "label": "Profil",
        "icon": "person",
        "route": "profile"
      }
    ]
  }
}
```

## Pages simples

### Page d'accueil basique

```json
// assets/pages/home.json
{
  "screen": {
    "type": "scaffold",
    "appBar": {
      "type": "appbar",
      "title": {
        "type": "text",
        "data": "Accueil"
      }
    },
    "body": {
      "type": "center",
      "child": {
        "type": "column",
        "mainAxisAlignment": "center",
        "children": [
          {
            "type": "text",
            "data": "Bienvenue !",
            "style": {
              "fontSize": 24,
              "fontWeight": "bold"
            }
          },
          {
            "type": "sized_box",
            "height": 20
          },
          {
            "type": "text",
            "data": "Ceci est une page construite avec Screen Builder"
          }
        ]
      }
    }
  }
}
```

### Page de profil avec actions

```json
// assets/pages/profile.json
{
  "screen": {
    "type": "scaffold",
    "appBar": {
      "type": "appbar",
      "title": {
        "type": "text",
        "data": "Profil"
      },
      "actions": [
        {
          "type": "icon_button",
          "icon": "settings",
          "onPressed": {
            "action": "navigate",
            "params": {
              "route": "settings"
            }
          }
        }
      ]
    },
    "body": {
      "type": "padding",
      "padding": {
        "all": 16
      },
      "child": {
        "type": "column",
        "crossAxisAlignment": "start",
        "children": [
          {
            "type": "circle_avatar",
            "radius": 50,
            "backgroundColor": "#2196F3"
          },
          {
            "type": "sized_box",
            "height": 16
          },
          {
            "type": "text",
            "data": "John Doe",
            "style": {
              "fontSize": 24,
              "fontWeight": "bold"
            }
          },
          {
            "type": "text",
            "data": "john.doe@example.com",
            "style": {
              "color": "#666666"
            }
          },
          {
            "type": "sized_box",
            "height": 32
          },
          {
            "type": "elevated_button",
            "child": {
              "type": "text",
              "data": "Modifier le profil"
            },
            "onPressed": {
              "action": "navigate",
              "params": {
                "route": "edit_profile"
              }
            }
          }
        ]
      }
    }
  }
}
```

## Actions avancées

### Navigation avec paramètres

```json
// Navigation vers une page avec paramètres
{
  "type": "elevated_button",
  "child": {
    "type": "text",
    "data": "Voir détails"
  },
  "onPressed": {
    "action": "navigate",
    "params": {
      "route": "product_detail",
      "arguments": {
        "productId": 123,
        "category": "electronics"
      }
    }
  }
}
```

### Appel API avec gestion d'état

```json
// Bouton qui charge des données
{
  "type": "elevated_button",
  "child": {
    "type": "text",
    "data": "Charger les données"
  },
  "onPressed": {
    "action": "api_get",
    "params": {
      "url": "https://api.example.com/users",
      "onSuccess": {
        "action": "set_state",
        "params": {
          "key": "users",
          "value": "${response}"
        }
      },
      "onError": {
        "action": "show_snackbar",
        "params": {
          "message": "Erreur de chargement"
        }
      }
    }
  }
}
```

### Actions conditionnelles

```json
// Action basée sur l'état
{
  "type": "elevated_button",
  "child": {
    "type": "text",
    "data": "${isLoggedIn ? 'Se déconnecter' : 'Se connecter'}"
  },
  "onPressed": {
    "action": "conditional",
    "params": {
      "condition": "${isLoggedIn}",
      "trueAction": {
        "action": "logout"
      },
      "falseAction": {
        "action": "navigate",
        "params": {
          "route": "login"
        }
      }
    }
  }
}
```

## Composants complexes

### Formulaire d'inscription

```json
// assets/pages/register.json
{
  "screen": {
    "type": "scaffold",
    "appBar": {
      "type": "appbar",
      "title": {
        "type": "text",
        "data": "Inscription"
      }
    },
    "body": {
      "type": "padding",
      "padding": {
        "all": 16
      },
      "child": {
        "type": "form",
        "key": "register_form",
        "child": {
          "type": "column",
          "children": [
            {
              "type": "text_form_field",
              "decoration": {
                "labelText": "Nom d'utilisateur"
              },
              "validator": {
                "required": true,
                "minLength": 3
              }
            },
            {
              "type": "sized_box",
              "height": 16
            },
            {
              "type": "text_form_field",
              "decoration": {
                "labelText": "Email"
              },
              "keyboardType": "emailAddress",
              "validator": {
                "required": true,
                "email": true
              }
            },
            {
              "type": "sized_box",
              "height": 16
            },
            {
              "type": "text_form_field",
              "decoration": {
                "labelText": "Mot de passe"
              },
              "obscureText": true,
              "validator": {
                "required": true,
                "minLength": 8
              }
            },
            {
              "type": "sized_box",
              "height": 32
            },
            {
              "type": "elevated_button",
              "child": {
                "type": "text",
                "data": "S'inscrire"
              },
              "onPressed": {
                "action": "submit_form",
                "params": {
                  "formKey": "register_form",
                  "url": "https://api.example.com/register",
                  "onSuccess": {
                    "action": "navigate",
                    "params": {
                      "route": "home"
                    }
                  }
                }
              }
            }
          ]
        }
      }
    }
  }
}
```

### Liste avec données dynamiques

```json
// assets/pages/user_list.json
{
  "screen": {
    "type": "scaffold",
    "appBar": {
      "type": "appbar",
      "title": {
        "type": "text",
        "data": "Utilisateurs"
      }
    },
    "body": {
      "type": "future_builder",
      "future": {
        "action": "api_get",
        "params": {
          "url": "https://api.example.com/users"
        }
      },
      "builder": {
        "type": "list_view",
        "children": {
          "type": "for_each",
          "items": "${data}",
          "itemBuilder": {
            "type": "list_tile",
            "title": {
              "type": "text",
              "data": "${item.name}"
            },
            "subtitle": {
              "type": "text",
              "data": "${item.email}"
            },
            "onTap": {
              "action": "navigate",
              "params": {
                "route": "user_detail",
                "arguments": {
                  "userId": "${item.id}"
                }
              }
            }
          }
        }
      }
    }
  }
}
```

## Gestion d'état

### État local avec Provider

```dart
// Configuration du provider
class AppState extends ChangeNotifier {
  bool _isLoggedIn = false;
  List<dynamic> _users = [];

  bool get isLoggedIn => _isLoggedIn;
  List<dynamic> get users => _users;

  void login() {
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }

  void setUsers(List<dynamic> users) {
    _users = users;
    notifyListeners();
  }
}

// Utilisation dans les actions
{
  "action": "set_state",
  "params": {
    "provider": "AppState",
    "method": "setUsers",
    "value": "${response}"
  }
}
```

### État global avec Riverpod

```dart
// Définition des providers
final isLoggedInProvider = StateProvider<bool>((ref) => false);
final usersProvider = StateNotifierProvider<UsersNotifier, List<User>>((ref) {
  return UsersNotifier();
});

// Actions Riverpod
{
  "action": "riverpod_set",
  "params": {
    "provider": "usersProvider",
    "value": "${response}"
  }
}
```

## Thèmes et styles

### Thème personnalisé

```json
// assets/pages/theme_example.json
{
  "screen": {
    "type": "theme",
    "data": {
      "primaryColor": "#2196F3",
      "accentColor": "#FF9800",
      "textTheme": {
        "headline1": {
          "fontSize": 32,
          "fontWeight": "bold"
        }
      }
    },
    "child": {
      "type": "scaffold",
      "body": {
        "type": "column",
        "children": [
          {
            "type": "text",
            "data": "Texte avec thème",
            "style": "headline1"
          },
          {
            "type": "elevated_button",
            "child": {
              "type": "text",
              "data": "Bouton thémé"
            },
            "style": {
              "backgroundColor": "primary"
            }
          }
        ]
      }
    }
  }
}
```

### Styles conditionnels

```json
{
  "type": "container",
  "decoration": {
    "color": "${isSelected ? '#E3F2FD' : '#FFFFFF'}",
    "border": {
      "all": {
        "color": "${isSelected ? '#2196F3' : '#E0E0E0'}",
        "width": "${isSelected ? 2 : 1}"
      }
    }
  },
  "child": {
    "type": "text",
    "data": "${item.name}",
    "style": {
      "color": "${isSelected ? '#2196F3' : '#000000'}",
      "fontWeight": "${isSelected ? 'bold' : 'normal'}"
    }
  }
}
```

## Animations et transitions

### Transitions de page personnalisées

```dart
// Dans navigation_handle.dart
class CustomPageTransitions {
  static PageRouteBuilder createRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }
}
```

### Animations de composants

```json
// Composant avec animation
{
  "type": "animated_container",
  "duration": 300,
  "decoration": {
    "color": "${isExpanded ? '#E3F2FD' : '#FFFFFF'}",
    "borderRadius": {
      "all": "${isExpanded ? 8 : 0}"
    }
  },
  "child": {
    "type": "text",
    "data": "Contenu animé"
  }
}
```

## Intégration avec des services externes

### Authentification Firebase

```dart
// Action d'authentification
class FirebaseAuthActions {
  static Future<void> signInWithEmail(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Mettre à jour l'état
      NavigationState.instance.setLoggedIn(true);
    } catch (e) {
      throw AuthException('Erreur de connexion: $e');
    }
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    NavigationState.instance.setLoggedIn(false);
  }
}

// Utilisation dans JSON
{
  "action": "firebase_signin",
  "params": {
    "email": "${email}",
    "password": "${password}"
  }
}
```

### Base de données locale

```dart
// Actions de base de données
class DatabaseActions {
  static Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await openDatabase('app.db');
    return await db.query('users');
  }

  static Future<void> saveUser(Map<String, dynamic> user) async {
    final db = await openDatabase('app.db');
    await db.insert('users', user);
  }
}

// Utilisation dans JSON
{
  "action": "db_query",
  "params": {
    "table": "users",
    "onSuccess": {
      "action": "set_state",
      "params": {
        "key": "users",
        "value": "${result}"
      }
    }
  }
}
```

## Tests et debugging

### Tests unitaires

```dart
void main() {
  group('Navigation Actions', () {
    test('Navigate action works', () async {
      final handle = NavigationHandle.instance;

      await handle.execute({
        'action': 'navigate',
        'params': {'route': 'home'}
      });

      expect(handle.currentRoute, equals('home'));
    });

    test('API action handles success', () async {
      final mockClient = MockClient((request) async {
        return http.Response('{"users": []}', 200);
      });

      await NavigationHandle.instance.execute({
        'action': 'api_get',
        'params': {
          'url': 'https://api.example.com/users',
          'client': mockClient
        }
      });

      // Vérifier que l'état a été mis à jour
      expect(NavigationState.instance.get('users'), isNotNull);
    });
  });
}
```

### Tests d'intégration

```dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Full navigation flow', (tester) async {
    await tester.pumpWidget(MyApp());

    // Vérifier la page d'accueil
    expect(find.text('Accueil'), findsOneWidget);

    // Naviguer vers le profil
    await tester.tap(find.byIcon(Icons.person));
    await tester.pumpAndSettle();

    // Vérifier la page profil
    expect(find.text('Profil'), findsOneWidget);
  });
}
```

### Debugging en développement

```dart
class DebugOverlay {
  static void showDebugInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Debug Info'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Current Route: ${NavigationHandle.instance.currentRoute}'),
            Text('Navigation Stack: ${NavigationHistory.stack}'),
            Text('State Keys: ${NavigationState.instance.keys}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}
```

Ces exemples montrent comment utiliser Screen Builder pour créer des applications Flutter complexes de manière déclarative.