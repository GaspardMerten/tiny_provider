import 'package:flutter/widgets.dart';
import 'package:tiny_provider/utils/extension.dart';
import 'package:tiny_provider/utils/typedefs.dart';

/// A widget that rebuilds when a [Listenable] it depends on changes.
///
/// This widget allows you to listen to changes in a [Listenable] and rebuild
/// your UI whenever a change occurs. To use it, simply pass in a [builder]
/// function that takes in a [BuildContext] and a [T] object, and returns a
/// widget tree that depends on the [T] object.
class Consumer<T extends Listenable> extends ConsumerWidget<T> {
  const Consumer({
    Key? key,
    required this.builder,
    bool listen = true,
  }) : super(key: key, listen: listen);

  /// The builder function that returns the widget tree that depends on the
  /// [T] object.
  final ProviderBuilder<T> builder;

  @override
  Widget buildWithController(BuildContext context, T controller) {
    return builder(context, controller);
  }
}

/// An abstract widget that rebuilds when a [Listenable] it depends on changes.
///
/// This widget serves as a base class for the [Consumer] widget, and should not
/// be used directly. To use it, simply extend it and implement the
/// [buildWithController] method, which should return the widget tree that
/// depends on the [T] object.
abstract class ConsumerWidget<T extends Listenable> extends StatelessWidget {
  const ConsumerWidget({
    Key? key,
    this.listen = true,
  }) : super(key: key);

  /// Whether or not this widget should listen to changes in the [Listenable].
  final bool listen;

  /// Builds the widget tree that depends on the [T] object.
  ///
  /// This method is called whenever a change occurs in the [T] object.
  Widget buildWithController(BuildContext context, T controller);

  @override
  Widget build(BuildContext context) {
    final controller = context.of<T>(listen: listen);

    return buildWithController(context, controller);
  }
}
