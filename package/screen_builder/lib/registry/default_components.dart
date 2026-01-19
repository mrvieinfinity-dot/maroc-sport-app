import 'component_registry.dart';
import '../components/builders/button_builder.dart';
import '../components/builders/text_builder.dart';
import '../components/builders/container_builder.dart';
import '../components/builders/column_builder.dart';
import '../components/builders/row_builder.dart';
import '../components/builders/screen_builder.dart';
import '../components/builders/appbar_builder.dart';
import '../components/builders/spacer_builder.dart';

/// Registers default components in the registry
void registerDefaultComponents() {
  // UI components
  ComponentRegistry().register('button', ButtonBuilder());
  ComponentRegistry().register('text', TextBuilder());
  ComponentRegistry().register('appbar', AppBarBuilder());
  ComponentRegistry().register('spacer', SpacerBuilder());

  // Layout components
  ComponentRegistry().register('container', ContainerBuilder());
  ComponentRegistry().register('column', ColumnBuilder());
  ComponentRegistry().register('row', RowBuilder());
  ComponentRegistry().register('screen', ScreenBuilder());

  // TODO: Add remaining builders (image, list, popup)
}
