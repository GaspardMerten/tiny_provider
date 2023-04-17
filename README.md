# Tiny Provider

Tiny Provider is a Flutter package that provides a lightweight solution for state management in small applications or
packages that do not require a full-fledged state management solution. It is based on the Provider package and provides
two main widgets: ```ListenableProvider``` and ```ChangeNotifierProvider```.

## Installation

Add the following to your ```pubspec.yaml``` file:

```yaml
dependencies:
  tiny_provider: ^latest_version
```

## Getting Started

To use Tiny Provider, you must first import the package:

```dart
import 'package:tiny_provider/tiny_provider.dart';
```

Then, you can use the ```ListenableProvider``` or ```ChangeNotifierProvider``` widgets to create a ```Listenable```
object of type ```T``` and provide it to its descendants via an ```InheritedProvider``` widget. You can then use
the ```Consumer``` widget to listen to changes in the ```Listenable``` object and rebuild its child widgets whenever
the ```Listenable``` changes.

## Example

```dart
import 'package:flutter/material.dart';
import 'package:tiny_provider/tiny_provider.dart';

void main() {
  runApp(MyApp());
}

class Counter extends ChangeNotifier {
  int _count = 0;

  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => Counter(),
      child: MaterialApp(
        title: 'My App',
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Consumer<Counter>(
              builder: (context, counter, child) {
                return Text(
                  '${counter.count}',
                );
              },
            ),
            MyText(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.of<Counter>().increment(),
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

/// Or use an extension to access the Listenable object
class MyText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final counter = context.watch<Counter>();
    
        return Text(
          '${counter.count}',
      );
  }
}
```

## Extensions

Tiny Provider also provides an extension on the ```BuildContext``` class that adds methods for
retrieving ```Listenable``` objects from the nearest ```InheritedProvider``` ancestor widget. By using extensions, we
can simplify the code required to access ```Listenable``` objects in our widget tree. Instead of using
the ```InheritedProvider.of``` method directly, we can use the ```of``` and ```watch``` methods provided by
the ```ChangeNotifierProviderExtension``` extension on ```BuildContext```. These methods provide a more concise and
readable way of accessing ```Listenable``` objects, and make it easier to refactor our code if we need to change the
type of the ```Listenable```. The ```watch``` is simply a wrapper around the ```of``` method that has listen set to
true by default.


## ListenableProvider

The ```ListenableProvider``` widget is used to create a ```Listenable``` object of type ```T``` and provide it to its
descendants via an ```InheritedProvider``` widget. It takes in a ```create``` function that creates
the ```Listenable```, a ```builder``` function that builds the widget tree that depends on the ```Listenable```, and an
optional ```onDispose``` function that is called when the widget is disposed.

## ChangeNotifierProvider

The ```ChangeNotifierProvider``` widget is used to create a ```ChangeNotifier``` object of type ```T``` and provide it
to its descendants via a ```ListenableProvider``` widget. It takes in a ```create``` function that creates
the ```ChangeNotifier```, a ```builder``` function that builds the widget tree that depends on the ```ChangeNotifier```,
and an optional ```onDispose``` function that is called when the widget is disposed.

## Consumer

Tiny Provider also provides a ```Consumer``` widget that can be used to listen to changes in a ```Listenable``` object
and rebuild its child widgets whenever the ```Listenable``` changes. It takes in a ```listen``` boolean flag and
a ```builder``` function that builds the widget tree that depends on the ```Listenable```.

## InheritedProvider

Finally, Tiny Provider provides an ```InheritedProvider``` widget that is used to provide a ```Listenable``` to its
descendants via an ```InheritedWidget```. It takes in a ```notifier``` object of type ```T```, which must
extend ```Listenable```, and passes it down the widget tree to any widgets that call ```of``` on this context with a
matching ```T```.

So, if you need a lightweight solution for state management in your Flutter application, give Tiny Provider a try!

