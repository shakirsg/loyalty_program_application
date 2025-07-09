import 'package:flutter/material.dart';
import 'package:loyalty_program_application/src/providers/guest_provider.dart';
import 'package:loyalty_program_application/src/providers/navigation_provider.dart';
import 'package:loyalty_program_application/src/providers/auth_provider.dart';
import 'package:loyalty_program_application/src/services/local_storage_service.dart';
import 'package:provider/provider.dart';
import 'src/config/route.dart';
import 'src/themes/theme.dart';
import 'src/providers/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // final token = await LocalStorageService.getToken();
  // print(token);
  final authProvider = AuthProvider();
  await authProvider.tryAutoLogin(); // this sets the token & isRemember internally

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GuestProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),

      ],
      child: MyApp(initialRoute: authProvider.isRemember != false ? '/main' : '/landing'),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: 'Loyalty App',
      theme: lightTheme, // Apply theme here

      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      routes: appRoutes,
    );
  }
}
