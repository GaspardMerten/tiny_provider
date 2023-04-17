# TinyProvider 🧩 

TinyProvider is a Flutter package that provides a simplified way of handling state management
using ```ChangeNotifier```. It includes a provider widget that can be used to create and share a single instance of
a ```ChangeNotifier``` across different parts of an application.Installation

## What is included ? 📦 

`tinyControllerOf<T>`: A function that returns the controller of type T from the nearest ancestor
TinyChangeNotifierProviderWidget<T>. It is used to get the state of a ChangeNotifier from anywhere in the widget tree.

`TinyProvider<T>`: A StatefulWidget that creates and manages a controller of type T. It is used to create and manage a
ChangeNotifier for use with TinyConsumerWidget and TinyListenableProvider.

`TinyChangeNotifierBuilder<T>`: A StatelessWidget that builds a widget tree with a controller of type T. It is used to
build a widget tree that depends on the state of a ChangeNotifier.

`TinyConsumerWidget<T>`: An abstract StatelessWidget that builds a widget tree with a controller of type T and provides
a method buildWithController that must be implemented by subclasses. It is used to build a widget tree that depends on
the state of a ChangeNotifier.

`TinyListenableProvider<T>`: An abstract StatefulWidget that provides a controller of type T to its descendants and
rebuilds the widget tree when the controller changes. It is used to rebuild the widget tree when the state of a
ChangeNotifier changes.

## Installation 🪛

To use TinyProvider in your Flutter project, add it to your ```pubspec.yaml``` file`:

```yaml
dependencies:
  tiny_provider: ^latest_version
```

Then, run ```flutter packages get``` to install the package.Usage```TinyProvider```

## Usage 🤖 

```TinyProvider``` is a widget that creates and manages a single instance of a ```ChangeNotifier```. Here is an example
of how to use it:dart

```dart
import 'package:tiny_provider/tiny_provider.dart';

class MyModel extends ChangeNotifier {
  int _counter = 0;

  int get counter => _counter;

  void incrementCounter() {
    _counter++;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TinyProvider<MyModel>(
        create: (context) => MyModel(),
        builder: (context, model) =>
            Scaffold(
              body: Center(
                child: CounterWidget(),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () => model.incrementCounter(),
                tooltip: 'Increment',
                child: Icon(Icons.add),
              ),
            ),
      ),
    );
  }
}

class CounterWidget extends StatelessWidget {
  const CounterWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final model = tinyControllerOf<MyModel>(context, listen: true);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'You have pushed the button this many times:',
        ),
        Text(
          '${model.counter}',
          style: Theme
              .of(context)
              .textTheme
              .headline4,
        ),
      ],
    );
  }
}

```

In this example, ```MyModel``` is a ```ChangeNotifier``` that manages a counter. The ```TinyProvider``` widget is used
to create an instance of ```MyModel``` and pass it down to the child widget tree. The child widget tree can then use the
provided ```MyModel``` instance to manage and update the counter.```TinyConsumerWidget```

```TinyConsumerWidget``` is a widget that can be used to listen to changes in a ```ChangeNotifier``` and rebuild its
child widget tree accordingly. Here is an example of how to use it:dart

```dart
class MyConsumerWidget extends TinyConsumerWidget<MyModel> {
  @override
  Widget buildWithController(BuildContext context, MyModel model) {
    return Text(
      '${model.counter}',
      style: Theme
          .of(context)
          .textTheme
          .headline4,
    );
  }
}
```

In this example, ```MyConsumerWidget``` is a child widget that listens to changes in the ```MyModel``` instance provided
by the parent ```TinyProvider``` widget. Whenever the counter in ```MyModel``` changes, ```MyConsumerWidget``` will
rebuild its child widget tree with the updated counter value.```tinyControllerOf```

```tinyControllerOf``` is a utility function that can be used to retrieve the instance of a ```ChangeNotifier```
provided by a parent ```TinyProvider``` widget. Here is an example of how to use it:dart

```dart

final myModel = tinyControllerOf<MyModel>(context, listen: true);
```

In this example, ```myModel``` is an instance of ```MyModel``` obtained from the parent ```TinyProvider``` widget using
the ```tinyControllerOf``` function. By setting ```listen``` to ```true```, the ```ChangeNotifier``` will automatically
listen for changes and rebuild the child widget tree whenever changes occur.Contribution

## Contribution 🙌 

If you would like to contribute to TinyProvider, feel free to submit a pull request on
the [GitHub repository](https://github.com/GaspardMerten/tiny_provider)

## License 📜

This project is licensed under the MIT License - see the LICENSE file for details.

## Credits

TinyProvider is inspired by the [Provider package](https://pub.dev/packages/provider) by Remi Rousselet.