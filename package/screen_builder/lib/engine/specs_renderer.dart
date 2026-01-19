import 'package:flutter/material.dart';
import '../../core/interfaces.dart';
import '../../core/logger.dart';
import '../components/props/component_specs.dart';
import '../handle/action_handle.dart';

/// Renderer for ComponentSpecs to Flutter Widgets
/// This is the ONLY place in the system that creates Flutter Widgets
/// All other code works with data-only ComponentSpecs
class SpecsRenderer {
  static final SpecsRenderer _instance = SpecsRenderer._internal();
  factory SpecsRenderer() => _instance;
  SpecsRenderer._internal();

  /// Renders a ComponentSpec to a Flutter Widget
  Widget render(BuildContext context, ComponentSpec spec) {
    try {
      switch (spec.type) {
        case 'text':
          return _renderText(context, spec);
        case 'button':
          return _renderButton(context, spec);
        case 'container':
          return _renderContainer(context, spec);
        case 'column':
          return _renderColumn(context, spec);
        case 'row':
          return _renderRow(context, spec);
        case 'screen':
          return _renderScreen(context, spec);
        case 'appbar':
          return _renderAppBar(context, spec);
        case 'spacer':
          return _renderSpacer(context, spec);
        case 'image':
          return _renderImage(context, spec);
        case 'card':
          return _renderCard(context, spec);
        case 'list':
          return _renderList(context, spec);
        case 'popup':
          return _renderPopup(context, spec);
        default:
          SBLogger.error('Unknown component type: ${spec.type}');
          return _renderUnknown(spec);
      }
    } catch (e, stackTrace) {
      SBLogger.error('Error rendering spec: $spec', e, stackTrace);
      return _renderError(spec, e);
    }
  }

  Widget _renderText(BuildContext context, ComponentSpec spec) {
    final content = spec.props['content'] ?? '';
    final styleKey = spec.props['styleKey'];
    final textAlign = spec.props['textAlign'];
    final style = _resolveTextStyle(styleKey);
    return Text(
      content,
      style: style,
      textAlign: textAlign is TextAlign ? textAlign : null,
    );
  }

  Widget _renderButton(BuildContext context, ComponentSpec spec) {
    final text = spec.props['text'] ?? '';
    final action = spec.props['action'];
    final colorKey = spec.props['colorKey'];
    final color = _resolveColor(colorKey);
    return ElevatedButton(
      onPressed: () {
        if (action != null) {
          ActionHandle().execute(
              {'type': 'custom', 'action': action, 'data': spec.props});
        }
      },
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(color),
      ),
      child: Text(text),
    );
  }

  Widget _renderContainer(BuildContext context, ComponentSpec spec) {
    final colorKey = spec.props['colorKey'];
    final padding = spec.props['padding'];
    final margin = spec.props['margin'];
    final color = _resolveColor(colorKey);
    return Container(
      color: color,
      padding: padding is EdgeInsets ? padding : null,
      margin: margin is EdgeInsets ? margin : null,
      child: (spec.props['children'] as List<ComponentSpec>?)?.isNotEmpty ==
              true
          ? render(
              context, (spec.props['children'] as List<ComponentSpec>).first)
          : null,
    );
  }

  Widget _renderColumn(BuildContext context, ComponentSpec spec) {
    debugPrint('[DEBUG] SpecsRenderer._renderColumn: spec=$spec');
    final mainAxisAlignment =
        spec.props['mainAxisAlignment'] ?? MainAxisAlignment.start;
    final crossAxisAlignment =
        spec.props['crossAxisAlignment'] ?? CrossAxisAlignment.center;
    final spacing = spec.props['spacing'] ?? 0.0;
    final children = (spec.props['children'] as List<ComponentSpec>?)
            ?.map((child) => render(context, child))
            .toList() ??
        [];
    return Column(
      mainAxisAlignment: mainAxisAlignment is MainAxisAlignment
          ? mainAxisAlignment
          : MainAxisAlignment.start,
      crossAxisAlignment: crossAxisAlignment is CrossAxisAlignment
          ? crossAxisAlignment
          : CrossAxisAlignment.center,
      children: _addSpacing(children, spacing.toDouble()),
    );
  }

  Widget _renderRow(BuildContext context, ComponentSpec spec) {
    final mainAxisAlignment =
        spec.props['mainAxisAlignment'] ?? MainAxisAlignment.start;
    final crossAxisAlignment =
        spec.props['crossAxisAlignment'] ?? CrossAxisAlignment.center;
    final spacing = spec.props['spacing'] ?? 0.0;
    final children = (spec.props['children'] as List<ComponentSpec>?)
            ?.map((child) => render(context, child))
            .toList() ??
        [];
    return Row(
      mainAxisAlignment: mainAxisAlignment is MainAxisAlignment
          ? mainAxisAlignment
          : MainAxisAlignment.start,
      crossAxisAlignment: crossAxisAlignment is CrossAxisAlignment
          ? crossAxisAlignment
          : CrossAxisAlignment.center,
      children: _addSpacing(children, spacing.toDouble()),
    );
  }

  Widget _renderScreen(BuildContext context, ComponentSpec spec) {
    final appBar = spec.props['appBar'] as ComponentSpec?;
    final drawer = spec.props['drawer'] as ComponentSpec?;
    final body =
        (spec.props['children'] as List<ComponentSpec>?)?.isNotEmpty == true
            ? (spec.props['children'] as List<ComponentSpec>).first
            : null;

    final scaffold = Scaffold(
      appBar: appBar != null ? _renderAppBar(context, appBar) : null,
      drawer: drawer != null ? _renderDrawer(context, drawer) : null,
      body: body != null ? render(context, body) : null,
    );
    return scaffold;
  }

  PreferredSizeWidget _renderAppBar(BuildContext context, ComponentSpec spec) {
    final title = spec.props['title'] ?? 'Screen';
    final actions = spec.props['actions'] as List<ComponentSpec>?;
    final backgroundColor = spec.props['backgroundColor'] as String?;
    final elevation = spec.props['elevation'] as double?;
    final centerTitle = spec.props['centerTitle'] as bool?;
    final automaticallyImplyLeading =
        spec.props['automaticallyImplyLeading'] as bool? ?? true;

    return AppBar(
      title: title is ComponentSpec
          ? render(context, title)
          : Text(title.toString()),
      actions: actions?.map((action) => render(context, action)).toList(),
      backgroundColor:
          backgroundColor != null ? _resolveColor(backgroundColor) : null,
      elevation: elevation,
      centerTitle: centerTitle,
      automaticallyImplyLeading: automaticallyImplyLeading,
    );
  }

  Widget _renderDrawer(BuildContext context, ComponentSpec spec) {
    final items = spec.props['items'] as List<ComponentSpec>?;
    return Drawer(
      child: ListView(
        children: items?.map((item) => render(context, item)).toList() ?? [],
      ),
    );
  }

  Widget _renderImage(BuildContext context, ComponentSpec spec) {
    final src = spec.props['src'] as String?;
    final width = spec.props['width'] as double?;
    final height = spec.props['height'] as double?;
    final fit = spec.props['fit'] as BoxFit?;

    if (src == null) return const SizedBox();

    return Image.network(
      src,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        SBLogger.error('Failed to load image: $src', error, stackTrace);
        return Icon(Icons.broken_image);
      },
    );
  }

  Widget _renderSpacer(BuildContext context, ComponentSpec spec) {
    final height = spec.props['height'] as double?;
    final width = spec.props['width'] as double?;
    final flex = spec.props['flex'] as int?;

    if (flex != null) {
      return Spacer(flex: flex);
    }

    return SizedBox(
      height: height,
      width: width,
    );
  }

  Widget _renderCard(BuildContext context, ComponentSpec spec) {
    final elevation = spec.props['elevation'] as double?;
    final colorKey = spec.props['colorKey'] as String?;
    final child =
        (spec.props['children'] as List<ComponentSpec>?)?.isNotEmpty == true
            ? (spec.props['children'] as List<ComponentSpec>).first
            : null;

    return Card(
      elevation: elevation,
      color: colorKey != null ? _resolveColor(colorKey) : null,
      child: child != null
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: render(context, child),
            )
          : null,
    );
  }

  Widget _renderList(BuildContext context, ComponentSpec spec) {
    final scrollDirection = spec.props['scrollDirection'] as Axis?;
    final items = spec.props['items'] as List<ComponentSpec>?;

    return ListView(
      scrollDirection: scrollDirection ?? Axis.vertical,
      children: items?.map((item) => render(context, item)).toList() ?? [],
    );
  }

  Widget _renderPopup(BuildContext context, ComponentSpec spec) {
    final title = spec.props['title'] as String?;
    final content = spec.props['content'] as ComponentSpec?;
    final actions = spec.props['actions'] as List<ComponentSpec>?;

    return AlertDialog(
      title: title != null ? Text(title) : null,
      content: content != null ? render(context, content) : null,
      actions: actions?.map((action) => render(context, action)).toList(),
    );
  }

  Widget _renderUnknown(ComponentSpec spec) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: Colors.red.withOpacity(0.1),
      child: Text('Unknown component: ${spec.type}'),
    );
  }

  Widget _renderError(ComponentSpec spec, dynamic error) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: Colors.red.withOpacity(0.1),
      child: Text('Error rendering ${spec.type}: $error'),
    );
  }

  List<Widget> _addSpacing(List<Widget> children, double spacing) {
    if (spacing == 0.0 || children.isEmpty) return children;
    final result = <Widget>[];
    for (int i = 0; i < children.length; i++) {
      result.add(children[i]);
      if (i < children.length - 1) {
        result.add(SizedBox(width: spacing, height: spacing));
      }
    }
    return result;
  }

  TextStyle? _resolveTextStyle(String? styleKey) {
    if (styleKey == null) return null;
    // TODO: Implement style resolution from theme
    return null;
  }

  Color? _resolveColor(String? colorKey) {
    if (colorKey == null) return null;
    // TODO: Implement color resolution from theme
    return ResolverManager().resolve<Color>(colorKey);
  }
}
