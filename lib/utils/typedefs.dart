import 'package:flutter/widgets.dart';
import 'package:tiny_provider/widgets/provider.dart';

/// The type signature for a builder function that takes in a [BuildContext] and
/// a value of type [R], and returns a widget tree that depends on the [R] value.
///
/// This type is commonly used as a parameter for widgets like [Provider], which
/// allow you to provide a value to their descendants and rebuild them whenever
/// that value changes.
typedef ProviderBuilder<R> = Widget Function(
  BuildContext context,
  R value,
);

/// A type alias for the [InheritedProvider] class.
///
/// This type alias is provided for convenience and readability, so that you can
/// use the name "Provider" instead of "InheritedProvider" when working with
/// provider widgets in your code.
typedef Provider = InheritedProvider;
