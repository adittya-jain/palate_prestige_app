import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import the provider package
import 'package:palate_prestige/providers/cart_provider.dart'; // Import the CartProvider
import 'package:palate_prestige/screens/codia_page.dart';
import 'package:palate_prestige/screens/home_screen.dart';
import 'package:palate_prestige/utils/auth/userCheck.dart';
import 'screens/cart_screen.dart';
import 'screens/menu_screen.dart';
import 'screens/mobile_scanner_overlay.dart';
import 'utils/auth/authcheck.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => CartProvider()), // Add the CartProvider here
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: const ColorScheme.dark(),
          useMaterial3: true,
        ),
        // home: AuthCheck(),
        initialRoute: '/authCheck', // Starting page
        routes: {
          '/signInPage': (context) =>
              CodiaPage(), // Sign-in page with Google Auth
          '/homePage': (context) => HomeScreen(), // Home page
          '/userInfoPage': (context) =>
              const UserInfoPage(), // Sign-up form page
          '/authCheck': (context) => AuthCheck(),
          '/barCodeScanner': (context) => const BarcodeScannerWithOverlay(),
          '/menuScreen': (context) => MenuScreen(
                restaurantId:
                    ModalRoute.of(context)?.settings.arguments as String,
              ),
          '/cartScreen': (context) => CartScreen(
                restaurantId:
                    ModalRoute.of(context)?.settings.arguments as String,
              ),
        },
      ),
    );
  }
}
