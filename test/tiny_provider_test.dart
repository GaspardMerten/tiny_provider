import 'package:flutter/material.dart';
import 'package:tiny_provider/tiny_provider.dart';
import 'package:flutter_test/flutter_test.dart';

class MyChangeNotifier extends ChangeNotifier {
  int _counter = 0;

  int get counter => _counter;

  void increment() {
    _counter++;
    notifyListeners();
  }

  @override
  String toString() {
    return 'MyChangeNotifier{counter: $_counter}';
  }
}

void main() {
  group('Tiny Provider Tests', () {
    testWidgets(
        'TinyProvider creates controller with correct type and builds child widget',
        (tester) async {
      final widget = MaterialApp(
        home: TinyProvider<MyChangeNotifier>(
          create: (_) => MyChangeNotifier(),
          builder: (_, __) => Builder(
            builder: (BuildContext context) {
              return Text(
                  tinyControllerOf<MyChangeNotifier>(context).toString());
            },
          ),
        ),
      );

      await tester.pumpWidget(widget);

      expect(find.text('MyChangeNotifier{counter: 0}'), findsOneWidget);
    });

    testWidgets(
        'TinyProvider rebuilds child widget when controller notifies listeners',
        (tester) async {
      final controller = MyChangeNotifier();
      final widget = MaterialApp(
        home: TinyProvider<MyChangeNotifier>(
          create: (_) => controller,
          builder: (_, __) => Text('${controller.counter}'),
        ),
      );

      await tester.pumpWidget(widget);

      expect(find.text('0'), findsOneWidget);

      controller.increment();

      await tester.pump();

      expect(find.text('1'), findsOneWidget);
    });

    testWidgets(
        'TinyChangeNotifierBuilder builds child widget with correct controller type',
        (tester) async {
      final controller = MyChangeNotifier();
      final widget = MaterialApp(
        home: TinyChangeNotifierProviderWidget<MyChangeNotifier>(
          controller: controller,
          child: TinyChangeNotifierBuilder<MyChangeNotifier>(
            builder: (_, __) => Text('${controller.counter}'),
          ),
        ),
      );

      await tester.pumpWidget(widget);

      expect(find.text('0'), findsOneWidget);
    });

    testWidgets(
        'TinyConsumerWidget builds child widget with correct controller type and listens to controller',
        (tester) async {
      final controller = MyChangeNotifier();
      final widget = MaterialApp(
        home: TinyChangeNotifierProviderWidget<MyChangeNotifier>(
          controller: controller,
          child: _TestConsumerWidget(),
        ),
      );

      await tester.pumpWidget(widget);

      expect(find.text('0'), findsOneWidget);

      controller.increment();

      await tester.pump();

      expect(find.text('1'), findsOneWidget);
    });

    testWidgets(
        'TinyListenableProvider builds child widget with correct controller type and listens to controller',
        (tester) async {
      final controller = MyChangeNotifier();
      final widget = MaterialApp(
        home: TinyProvider(
            create: (_) => controller,
            builder: (_, __) => const _TestListenableProvider()),
      );

      await tester.pumpWidget(widget);

      expect(find.text('0'), findsOneWidget);

      controller.increment();

      await tester.pump();

      expect(find.text('1'), findsOneWidget);
    });
  });
}

class _TestConsumerWidget extends TinyConsumerWidget<MyChangeNotifier> {
  @override
  Widget buildWithController(
      BuildContext context, MyChangeNotifier controller) {
    return Text('${controller.counter}');
  }
}

class _TestListenableProvider extends TinyListenableProvider<MyChangeNotifier> {
  const _TestListenableProvider();


  @override
  TinyListenableProviderState<_TestListenableProvider, MyChangeNotifier>
      createState() {
    return _TestListenableProviderState();
  }
}

class _TestListenableProviderState extends TinyListenableProviderState<
    _TestListenableProvider, MyChangeNotifier> {
  @override
  Widget buildWithController(
      BuildContext context, MyChangeNotifier controller) {
    return Text('${controller.counter}');
  }
}
