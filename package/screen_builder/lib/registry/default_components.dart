import 'component_registry.dart';
import '../components/ui/button.dart';
import '../components/ui/text.dart';
import '../components/ui/image.dart';
import '../components/ui/popup.dart';
import '../components/ui/appbar.dart';
import '../components/layout/column.dart';
import '../components/layout/row.dart';
import '../components/layout/container.dart';
import '../components/layout/spacer.dart';
import '../components/layout/screen.dart';

/// Registers default components in the registry
void registerDefaultComponents() {
  // UI components
  ComponentRegistry().register('button', buildButton);
  ComponentRegistry().register('text', buildText);
  ComponentRegistry().register('image', buildImage);
  ComponentRegistry().register('popup', buildPopup);
  ComponentRegistry().register('appbar', buildAppBar);

  // Layout components
  ComponentRegistry().register('column', buildColumn);
  ComponentRegistry().register('row', buildRow);
  ComponentRegistry().register('container', buildContainer);
  ComponentRegistry().register('spacer', buildSpacer);
  ComponentRegistry().register('screen', buildScreen);
}
