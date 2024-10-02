import 'dart:async';
import 'dart:developer';
import 'package:kasanipedido/exports/exports.dart';
import 'package:bloc/bloc.dart';
import 'package:kasanipedido/app/app_bloc_observer.dart';

void bootstrap(Widget Function() builder) {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();

  runZonedGuarded(
    () => runApp(builder()),
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}