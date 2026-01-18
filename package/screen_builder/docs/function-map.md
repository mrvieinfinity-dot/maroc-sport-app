# Function Map - Screen Builder

| Nom de la fonction/classe | Emplacement (chemin relatif) | Utilisation principale | Dépendances | Remarques |
|---------------------------|-----------------------------|------------------------|-------------|-----------|
| PageEngine.buildPage() | lib/engine/page_engine.dart | Construit une page à partir de PageModel, retourne map de widgets | ComponentRegistry, DataResolver | Utilisé dans ScreenBuilderPage._loadPage(), hard-code pour Scaffold |
| PageEngine.buildComponent() | lib/engine/page_engine.dart | Construit un widget à partir de props JSON | ComponentRegistry, ResolverManager | Récursif pour children, throw si builder manquant |
| ComponentRegistry.register() | lib/registry/component_registry.dart | Enregistre un builder pour un type | - | Singleton, appelé dans registerDefaultComponents |
| ComponentRegistry.get() | lib/registry/component_registry.dart | Récupère builder par type | - | Log warn si pas trouvé |
| ButtonBuilder.build() | lib/components/ui/button.dart | Construit ElevatedButton avec action | ActionEngine, ResolverManager | Utilise onTap ou action prop |
| ApiService.get() | lib/services/api/api_service.dart | Fait requête GET | ApiClient | Retourne ApiResponse, utilisé dans actions probablement |
| ApiService.post() | lib/services/api/api_service.dart | Fait requête POST | ApiClient | Idem |
| NavigationService.navigate() | lib/navigation/navigation_service.dart | Navigue vers route avec params | RouteRegistry, NavigatorState | Push MaterialPageRoute |
| ScreenBuilderPage._loadPage() | lib/screen_builder_page.dart | Charge page JSON et construit widgets | PageEngine, DefaultAssetBundle | Async, setState pour UI |
| initScreenBuilder() | lib/bootstrap.dart | Initialise le système | DIContainer, ResolverManager, ComponentRegistry | Enregistre services, handlers |
| ActionEngine.execute() | lib/engine/actions/action_engine.dart | Exécute action depuis props | - | Non lu en détail, probablement appelle API ou navigation |
| EventBus.subscribe() | lib/engine/events/event_bus.dart | Abonne handler à event | - | Utilisé dans bootstrap |
| DataResolver.resolveProps() | lib/engine/resolvers/data_resolver.dart | Résout props avec tokens | ResolverManager | Non lu, probablement remplace placeholders |
| PageModel | lib/models/page_model.dart | Modèle pour page | - | Simple data class |
| ScreenConfig | lib/config/screen_config.dart | Config globale | - | Data class pour homePage, etc. |
| DIContainer.register() | lib/di/container.dart | Enregistre instance | - | Simple map |
| DIContainer.get() | lib/di/container.dart | Récupère instance | - | Type-safe via generics |

(Note: Liste non exhaustive, priorise les principales. Pour une liste complète, analyser tous les fichiers.)</content>
<parameter name="filePath">c:\Users\pc\Downloads\maroc_sport_copie-main\package\screen_builder\docs\function-map.md