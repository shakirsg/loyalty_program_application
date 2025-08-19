import 'package:flutter/material.dart';
import 'package:metsec_loyalty_app/src/providers/guest_provider.dart';
import 'package:metsec_loyalty_app/src/providers/navigation_provider.dart';
import 'package:metsec_loyalty_app/src/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'src/config/route.dart';
import 'src/themes/theme.dart';
import 'src/providers/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final authProvider = AuthProvider();
  await authProvider
      .tryAutoLogin();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GuestProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MyApp(
        initialRoute: authProvider.isRemember != false ? '/main' : '/landing',
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MFundi',
      theme: lightTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      routes: appRoutes,
    );
  }
}
