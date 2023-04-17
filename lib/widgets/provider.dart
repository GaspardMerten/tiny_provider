import 'package:flutter/widgets.dart';
import 'package:tiny_provider/utils/typedefs.dart';
import 'package:tiny_provider/widgets/consumer.dart';

/// An [InheritedNotifier] that provides a [Listenable] to its descendants.
///
/// This widget is used to provide a [Listenable] to its descendants via an
/// [InheritedWidget]. It takes in a [notifier] object of type [T], which must
/// extend [Listenable], and passes it down the widget tree to any widgets that
/// call [of] on this context with a matching [T].
class InheritedProvider<T extends Listenable> extends InheritedNotifier<T> {
  const InheritedProvider({
    Key? key,
    required super.notifier,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedProvider<T> oldWidget) {
    return notifier != oldWidget.notifier;
  }

  /// Retrieves the [Listenable] object of type [T] from the nearest
  /// [InheritedProvider] ancestor widget.
  ///
  /// If [listen] is true, this widget will rebuild whenever the [Listenable]
  /// changes. Otherwise, it will only retrieve the current value of the
  /// [Listenable] and not rebuild when it changes.
  static T of<T extends Listenable>(BuildContext context,
      {bool listen = false}) {
    final parentInheritedWidget =
        context.dependOnInheritedWidgetOfExactType<InheritedProvider<T>>();

    assert(parentInheritedWidget != null,
        'No change notifier found of type $T in context');

    final element =
        context.getElementForInheritedWidgetOfExactType<InheritedProvider<T>>();

    if (element != null && listen) {
      context.dependOnInheritedElement(element);
    }

    return parentInheritedWidget!.notifier!;
  }
}

/// A widget that creates a [Listenable] and provides it to its descendants.
///
/// This widget is used to create a [Listenable] object of type [T] and provide
/// it to its descendants via an [InheritedProvider] widget. It takes in a
/// [create] function that creates the [Listenable], a [builder] function that
/// builds the widget tree that depends on the [Listenable], and an optional
/// [onDispose] function that is called when the widget is disposed.
class ListenableProvider<T extends Listenable> extends StatefulWidget {
  const ListenableProvider({
    Key? key,
    required this.create,
    required this.builder,
    this.listen = true,
    this.onDispose,
  }) : super(key: key);

  /// The function that creates the [Listenable].
  final T Function(BuildContext context) create;

  /// The builder function that builds the widget tree that depends on the
  /// [Listenable].
  final ProviderBuilder<T> builder;

  /// Whether or not this widget should listen to changes in the [Listenable].
  final bool listen;

  /// An optional function that is called when the widget is disposed.
  final Function(T controller)? onDispose;

  @override
  State<ListenableProvider<T>> createState() => _ListenableProviderState<T>();
}

class _ListenableProviderState<T extends Listenable>
    extends State<ListenableProvider<T>> {
  late final notifier = widget.create(context);

  @override
  Widget build(BuildContext context) {
    final Widget child;

    if (widget.listen) {
      child = Consumer<T>(
        listen: widget.listen,
        builder: widget.builder,
      );
    } else {
      child = widget.builder(context, notifier);
    }

    return InheritedProvider(
      notifier: notifier,
      child: child,
    );
  }

  @override
  void dispose() {
    super.dispose();
    widget.onDispose?.call(notifier);
  }
}

/// A widget that creates a [ChangeNotifier] and provides it to its descendants.
///
/// This widget is used to create a [ChangeNotifier] object of type [T] and
/// provide it to its descendants via a [ListenableProvider] widget. It takes in
/// a [create] function that creates the [ChangeNotifier], a [builder] function
/// that builds the widget tree that depends on the [ChangeNotifier], and an
/// optional [onDispose] function that is called when the widget is disposed.
class ChangeNotifierProvider<T extends ChangeNotifier> extends StatelessWidget {
  const ChangeNotifierProvider({
    Key? key,
    required this.create,
    required this.builder,
    this.onDispose,
  }) : super(key: key);

  /// The function that creates the [ChangeNotifier].
  final T Function(BuildContext context) create;

  /// The builder function that builds the widget tree that depends on the
  /// [ChangeNotifier].
  final ProviderBuilder<T> builder;

  /// An optional function that is called when the widget is disposed.
  final Function(T controller)? onDispose;

  @override
  Widget build(BuildContext context) {
    return ListenableProvider<T>(
      create: create,
      builder: builder,
      onDispose: onDispose,
    );
  }
}
