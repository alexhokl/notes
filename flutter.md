- [Links](#links)
- [Libraries](#libraries)
- [Files](#files)
- [Commands](#commands)
  * [Setup](#setup)
  * [Packges](#packges)
  * [Build and run](#build-and-run)
- [Widgets](#widgets)
  * [SteamBuilder](#steambuilder)
  * [Expanded](#expanded)
- [Concepts](#concepts)
____

## Links

- [DartPad](https://dartpad.dev/)
- [Material design](https://m3.material.io/)
- [Codelabs on Flutter](https://docs.flutter.dev/codelabs)
- [Flutter Samples](https://flutter.github.io/samples/)
- [fvm](https://fvm.app/) - flutter version management
- [flutter gems](https://fluttergems.dev/)
- [Codelabs - first
  project](https://codelabs.developers.google.com/codelabs/flutter-codelab-first#2)

## Libraries

- [flutter_animate](https://pub.dev/packages/flutter_animate)

## Files

- `analysis_options.yaml`
  * linter options

## Commands

### Setup

##### To upgrade flutter installation

```sh
flutter upgrade
```

##### To check flutter installation

```sh
flutter doctor
```

##### To list available emulators

```sh
flutter emulators
```

##### To start an emulator

```sh
flutter emulators --launch Pixel_3_API_28
```

##### To list connected devices

```sh
flutter devices
```

##### To disable web as connected device

```sh
flutter config --no-enable-web
```

##### To create an application

```sh
flutter create your_app_name
```

This also creates directory `your_app_name` but it does not include `git`
integration.

### Packges

##### To add a package

```sh
flutter pub add flutter_animate
```

This adds package `flutter_animate` to section `dependencies` in `pubspec.yaml`.

##### To download dependencies (packages)

```sh
flutter pub get
```

### Build and run

##### To run on either emulator or connected device

```sh
flutter run
```

##### To build the assets directory

```sh
flutter build bundle
```

##### To build an ahead-of-time compiled snapshot

```sh
flutter build aot
```

##### To build an Android APK file

```sh
flutter build apk
```

##### To build an Android App Bundle file

```sh
flutter build appbundle
```

##### To build an iOS application bundle

```sh
flutter build ios
```

## Widgets

### SteamBuilder<T>

* [reference](https://api.flutter.dev/flutter/widgets/StreamBuilder-class.html)
* it builds itself based on the latest snapshot of interaction with a `Stream`
  + via `State.setState`
  + rebuilding is decoupled from the timing of the stream (as per timing of
    `yield` is being invoked

### Expanded

* [reference](https://api.flutter.dev/flutter/widgets/Expanded-class.html)
* it must be a decendent of a `Row`, `Column` or `Flex`
* the path to it must contain only `StatelessWidget` or `StatefulWidget` (and
  not like `RenderObjectWidget`)

## Concepts

- builder as a delegate to make rendering more efficient

## State management

### Riverpod

- types of provider
  * Provider
  * FutureProvider
  * StreamProvider
- Family
  * it works like a factory method where different parameter produces different
    providers
  * for custom provider classes, equality operator must be implemented; `Family`
    will keep creating invalid instances of providers, otherwise
- AutoDispose
  * it automatically disposes the provider when it is no longer used; such as
    showing different screens
  * this is not the default behaviour
- all proivders are declared as singletons and global
- it caches values by default
  * the caching is pretty greedy; thus, invalidation logic is likely required
