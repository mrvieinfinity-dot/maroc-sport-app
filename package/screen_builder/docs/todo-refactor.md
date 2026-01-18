# TODO Refactor - Screen Builder

## Points durs à refondre
- **Builders UI** : Actuellement retournent Widgets Flutter directement. Pour composable, introduire une abstraction (ex. ViewModel ou RenderProps).
- **Resolvers** : Tokens hard-codés, rendre configurable.
- **Navigation** : Ajouter support nested avec router comme GoRouter.
- **DI** : Améliorer avec GetIt ou Provider pour injection automatique.
- **Tests** : Ajouter mocks pour Flutter, utiliser flutter_test avec WidgetTester.
- **Actions** : ActionEngine semble basique, étendre pour plus de types d'actions.
- **Modèles** : Ajouter validation avec freezed ou json_serializable.

## Étapes suggérées
1. Créer interfaces pour UI abstraction.
2. Refactor builders pour retourner des objets au lieu de Widgets.
3. Améliorer DI.
4. Ajouter tests unitaires.
5. Implémenter navigation nested.</content>
<parameter name="filePath">c:\Users\pc\Downloads\maroc_sport_copie-main\package\screen_builder\docs\todo-refactor.md