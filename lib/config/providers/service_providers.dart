import 'package:flutter/material.dart';
import 'package:kasanipedido/services/authentication_service.dart';
import 'package:provider/provider.dart';

class ServiceProviders extends StatelessWidget {
  const ServiceProviders({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => AuthenticationService()),
      ],
      child: child,
    );
  }
}
