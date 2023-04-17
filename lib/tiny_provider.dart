import 'package:flutter/widgets.dart';

T tinyControllerOf<T extends ChangeNotifier>(BuildContext context,
    {bool listen = false}) {
  final parentInheritedWidget = context.dependOnInheritedWidgetOfExactType<
      TinyChangeNotifierProviderWidget<T>>();

  // assert T is not just a ChangeNotifier
  assert(T != ChangeNotifier,
      'T must implement ChangeNotifier but it is just ChangeNotifier.');

  assert(parentInheritedWidget != null,
      'No change notifier found of type $T in context');

  final element = context.getElementForInheritedWidgetOfExactType<
      TinyChangeNotifierProviderWidget<T>>();

  if (element != null && listen) {
    context.dependOnInheritedElement(element);
  }

  return parentInheritedWidget!.controller;
}

// InheritedWidget
class TinyChangeNotifierProviderWidget<T extends ChangeNotifier>
    extends InheritedWidget {
  const TinyChangeNotifierProviderWidget({
    super.key,
    required super.child,
    required this.controller,
  });

  final T controller;

  @override
  InheritedElement createElement() {
    return TinyChangeNotifierElement<T>(this);
  }

  @override
  bool updateShouldNotify(TinyChangeNotifierProviderWidget<T> oldWidget) {
    return oldWidget.controller != controller;
  }
}

class TinyChangeNotifierElement<T extends ChangeNotifier>
    extends InheritedElement {
  TinyChangeNotifierElement(TinyChangeNotifierProviderWidget<T> widget)
      : super(widget);

  @override
  TinyChangeNotifierProviderWidget<T> get widget =>
      super.widget as TinyChangeNotifierProviderWidget<T>;

  final List<Element> _dependents = [];

  @override
  void setDependencies(Element dependent, Object? value) {
    super.setDependencies(dependent, value);
    _dependents.add(dependent);

    _setListener();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _setListener();
  }

  void _setListener() {
    // remove old listener if any
    widget.controller.removeListener(listener);

    widget.controller.addListener(listener);
  }

  void listener() {
    // Notify the dependents that a rebuild is needed
    for (final dependent in _dependents) {
      dependent.markNeedsBuild();
    }
  }

  @override
  T? dependOnInheritedWidgetOfExactType<T extends InheritedWidget>(
      {Object? aspect}) {
    print(
        "Depends on ${super.dependOnInheritedWidgetOfExactType(aspect: aspect)}");
    return super.dependOnInheritedWidgetOfExactType(aspect: aspect);
  }

  @override
  void unmount() {
    _dependents.clear();
    widget.controller.removeListener(_setListener);
    super.unmount();
  }

  @override
  void update(TinyChangeNotifierProviderWidget<T> newWidget) {
    super.update(newWidget);
  }
}

class TinyProvider<T extends ChangeNotifier> extends StatefulWidget {
  const TinyProvider({
    super.key,
    required this.create,
    required this.builder,
    this.publishControllerToChildren = true,
  });

  final T Function(BuildContext context) create;

  final Widget Function(BuildContext context, T controller) builder;

  final bool publishControllerToChildren;

  @override
  TinyProviderState<T> createState() {
    return TinyProviderState<T>();
  }
}

class TinyProviderState<T extends ChangeNotifier>
    extends State<TinyProvider<T>> {
  late T controller;

  @override
  void initState() {
    super.initState();
    controller = widget.create(context);

    controller.addListener(() {
      setState(() {
        // Rebuild on change from controller
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return TinyChangeNotifierProviderWidget<T>(
      controller: controller,
      child: widget.builder(context, controller),
    );
  }

  @override
  void didUpdateWidget(TinyProvider<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.create != widget.create) {
      controller = widget.create(context);
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}

class TinyChangeNotifierBuilder<T extends ChangeNotifier>
    extends StatelessWidget {
  const TinyChangeNotifierBuilder({
    super.key,
    required this.builder,
    this.listen = true,
  });

  final Widget Function(BuildContext context, T controller) builder;
  final bool listen;

  @override
  Widget build(BuildContext context) {
    final controller = tinyControllerOf<T>(context, listen: listen);

    return Builder(
      builder: (context) {
        return builder(context, controller);
      },
    );
  }
}

abstract class TinyConsumerWidget<T extends ChangeNotifier>
    extends StatelessWidget {
  const TinyConsumerWidget({
    super.key,
  });

  Widget buildWithController(BuildContext context, T controller);

  @override
  @protected
  Widget build(BuildContext context) {
    final controller = tinyControllerOf<T>(context, listen: true);

    return buildWithController(context, controller);
  }
}

abstract class TinyListenableProvider<T extends ChangeNotifier>
    extends StatefulWidget {
  const TinyListenableProvider({
    super.key,
    this.listen = true,
  });

  final bool listen;

  @override
  TinyListenableProviderState<TinyListenableProvider<T>, T> createState();
}

abstract class TinyListenableProviderState<A extends TinyListenableProvider<T>,
    T extends ChangeNotifier> extends State<A> {
  @override
  @protected
  Widget build(BuildContext context) {
    final controller = tinyControllerOf<T>(context, listen: widget.listen);

    return buildWithController(context, controller);
  }

  Widget buildWithController(BuildContext context, T controller);
}
