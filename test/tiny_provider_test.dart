import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tiny_provider/widgets/consumer.dart';
import 'package:tiny_provider/widgets/provider.dart';

class SuperTestController extends ChangeNotifier {
  int myValue = 0;

  void increment() {
    myValue++;
    notifyListeners();
  }
}

void main() {
  group('ListenableProvider', () {
    testWidgets('builds with default parameters', (tester) async {
      await tester.pumpWidget(
        ListenableProvider<SuperTestController>(
          create: (context) => SuperTestController(),
          builder: (context, listener) {
            return Container();
          },
        ),
      );

      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets('builds with listen: true', (tester) async {
      await tester.pumpWidget(
        ListenableProvider<SuperTestController>(
          create: (context) => SuperTestController(),
          builder: (context, listener) {
            return Container();
          },
          listen: true,
        ),
      );

      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets('builds with listen: false', (tester) async {
      await tester.pumpWidget(
        ListenableProvider<SuperTestController>(
          create: (context) => SuperTestController(),
          builder: (context, listener) {
            return Container();
          },
          listen: false,
        ),
      );

      expect(find.byType(Container), findsOneWidget);
    });
  });

  group('Consumer', () {
    testWidgets('rebuilds when value changes', (tester) async {
      final myListenable = SuperTestController();

      await tester.pumpWidget(
        ListenableProvider<SuperTestController>(
          create: (context) => myListenable,
          builder: (context, listener) {
            return Consumer<SuperTestController>(
              builder: (context, listener) {
                return MaterialApp(
                    home: Text(
                  listener.myValue.toString(),
                ));
              },
            );
          },
        ),
      );

      expect(find.text('0'), findsOneWidget);

      myListenable.increment();
      await tester.pump();

      expect(find.text('1'), findsOneWidget);
    });
  });

  group('ChangeNotifierProvider', () {
    testWidgets('builds with default parameters', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<SuperTestController>(
          create: (context) => SuperTestController(),
          builder: (context, listener) {
            return Container();
          },
        ),
      );

      expect(find.byType(Container), findsOneWidget);
    });
  });

  group('InheritedProvider', () {
    testWidgets('throws an assertion error when no InheritedProvider is found',
        (tester) async {
      await tester.pumpWidget(
        Builder(
          builder: (context) {
            InheritedProvider.of<SuperTestController>(context);
            return Container();
          },
        ),
      );

      expect(tester.takeException(), isAssertionError);
    });
  });
}
