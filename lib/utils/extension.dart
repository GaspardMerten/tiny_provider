import 'package:flutter/material.dart';
import 'package:tiny_provider/widgets/provider.dart';

/// An extension on [BuildContext] that adds methods for retrieving [Listenable]
/// objects from the nearest [InheritedProvider] ancestor widget.
extension ChangeNotifierProviderExtension on BuildContext {
  /// Retrieves the [Listenable] object of type [T] from the nearest
  /// [InheritedProvider] ancestor widget.
  ///
  /// If [listen] is true, this widget will rebuild whenever the [Listenable]
  /// changes. Otherwise, it will only retrieve the current value of the
  /// [Listenable] and not rebuild when it changes.
  T of<T extends Listenable>({bool listen = false}) => InheritedProvider.of<T>(
        this,
        listen: listen,
      );

  /// Retrieves the [Listenable] object of type [T] from the nearest
  /// [InheritedProvider] ancestor widget and rebuilds the widget tree when it
  /// changes.
  ///
  /// This method is equivalent to calling [of] with [listen] set to true.
  T watch<T extends Listenable>() => InheritedProvider.of<T>(
        this,
        listen: true,
      );
}
