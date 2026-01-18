# Dependencies Graph - Screen Builder

```mermaid
graph TD
    A[ScreenBuilderPage] --> B[PageEngine]
    A --> C[NavigationAdapter]
    B --> D[ComponentRegistry]
    B --> E[DataResolver]
    D --> F[ButtonBuilder]
    D --> G[TextBuilder]
    F --> H[ActionEngine]
    F --> I[ResolverManager]
    H --> J[ApiService]
    H --> K[NavigationService]
    J --> L[ApiClient]
    K --> M[RouteRegistry]
    I --> N[ColorResolver]
    I --> O[TextStyleResolver]
    P[initScreenBuilder] --> Q[DIContainer]
    P --> I
    P --> D
    Q --> J
    Q --> R[EventBus]
    Q --> H
    R --> S[DefaultEventHandlers]
```

## Explications
- ScreenBuilderPage dépend de PageEngine pour construire les pages.
- PageEngine utilise ComponentRegistry pour les builders et DataResolver pour les props.
- Builders comme ButtonBuilder dépendent d'ActionEngine pour actions et ResolverManager pour résolution.
- ActionEngine peut appeler ApiService ou NavigationService.
- initScreenBuilder configure tout via DIContainer.</content>
<parameter name="filePath">c:\Users\pc\Downloads\maroc_sport_copie-main\package\screen_builder\docs\dependencies-graph.md