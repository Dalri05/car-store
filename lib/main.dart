import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:provider/provider.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/add_vehicle_screen.dart';
// import 'services/auth_service.dart';
// import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // TODO: Inicializar Firebase
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  
  runApp(const CarStoreApp());
}

class CarStoreApp extends StatelessWidget {
  const CarStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Car Store',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        primaryColor: const Color(0xFF6A1B9A),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6A1B9A),
          brightness: Brightness.light,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Color(0xFF6A1B9A),
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6A1B9A),
            foregroundColor: Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Color(0xFF6A1B9A),
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/add-vehicle': (context) => const AddVehicleScreen(),
      },
    );
  }
}

// TODO: Implementar quando Firebase for integrado
// class CarStoreApp extends StatelessWidget {
//   const CarStoreApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => AuthService()),
//         // Adicionar outros providers conforme necessário
//       ],
//       child: MaterialApp(
//         title: 'Car Store',
//         debugShowCheckedModeBanner: false,
//         theme: ThemeData(
//           primarySwatch: Colors.blue,
//           visualDensity: VisualDensity.adaptivePlatformDensity,
//         ),
//         home: Consumer<AuthService>(
//           builder: (context, authService, _) {
//             if (authService.isLoading) {
//               return const Scaffold(
//                 body: Center(child: CircularProgressIndicator()),
//               );
//             }
//             return authService.currentUser != null
//                 ? const VehicleListScreen()
//                 : const LoginScreen();
//           },
//         ),
//         routes: {
//           '/login': (context) => const LoginScreen(),
//           '/home': (context) => const VehicleListScreen(),
//           '/add-vehicle': (context) => const AddVehicleScreen(),
//         },
//       ),
//     );
//   }
// }