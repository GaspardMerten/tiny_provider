import 'package:flutter/material.dart';
import 'package:tiny_provider/tiny_provider.dart';

void main() {
  runApp(const MyApp());
}

class CounterController extends ChangeNotifier {
  int _counter = 0;

  int get counter => _counter;

  void increment() {
    _counter++;
    notifyListeners();
  }

  @override
  String toString() {
    return 'CounterController{counter: $_counter}';
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: ListenableProvider(
            listen: false,
            create: (_) {
              print("Creating");
              return CounterController();
            },
            builder: (context, controller) => Scaffold(
                appBar: AppBar(
                  title: const Text('Flutter Demo Home Page'),
                ),
                body: Scaffold(
                    body: Row(
                  children: [
                    Column(children: const [
                      Text("Version BuilderFor"),
                      IncrementCounter(),
                    ]),
                    Column(children: const [
                      Text("Version StatelessWidget"),
                      IncrementCounterExtendVersion(),
                    ]),
                  ],
                )),
                floatingActionButton: FloatingActionButton(
                  onPressed: controller.increment,
                  tooltip: 'Increment',
                  child: const Icon(Icons.add),
                ))));
  }
}

class IncrementCounter extends StatelessWidget {
  const IncrementCounter({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CounterController>(
      builder: (BuildContext context, CounterController controller) {
        return Text("Counter: ${controller.counter}");
      },
    );
  }
}

class IncrementCounterExtendVersion extends ConsumerWidget<CounterController> {
  const IncrementCounterExtendVersion({super.key});

  @override
  Widget buildWithController(
      BuildContext context, CounterController controller) {
    return Text("Counter: ${(controller).counter}");
  }
}
