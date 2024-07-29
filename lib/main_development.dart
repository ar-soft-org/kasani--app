import 'package:flutter/widgets.dart';
import 'package:kasanipedido/app/app.dart';
import 'package:kasanipedido/bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // FIXME create instances for services, and repositories

  await bootstrap(() {
    return const App();
  });
}
