import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '/router/router.dart' show router;
import 'package:provider/provider.dart';
import '/data/cart_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Shop',
      theme: ThemeData(
        dividerTheme: const DividerThemeData(
            thickness: 1,
            color: Color.fromARGB(100, 0, 0, 0),
            indent: 10,
            endIndent: 10),
        colorScheme: const ColorScheme(
          primary: Color.fromARGB(255, 78, 174, 254),
          onPrimary: Color.fromARGB(255, 255, 255, 255),
          secondary: Color.fromARGB(255, 55, 229, 72),
          onSecondary: Color.fromARGB(255, 255, 255, 255),
          tertiary: Color.fromARGB(255, 38, 233, 176),
          onTertiary: Color.fromARGB(255, 255, 255, 255),
          brightness: Brightness.light,
          error: Color.fromARGB(255, 236, 9, 57),
          onError: Color.fromARGB(255, 255, 255, 255),
          surface: Color.fromARGB(255, 252, 188, 42),
          onSurface: Color.fromARGB(255, 255, 255, 255),
          background: Color.fromARGB(255, 0, 77, 139),
          onBackground: Color.fromARGB(255, 255, 255, 255),
        ),
        fontFamily: 'YouBlockHead',
        textTheme: const TextTheme(
            bodyMedium: TextStyle(color: Colors.white),
            titleMedium: TextStyle(color: Colors.white)),
        useMaterial3: true,
      ),
      routerConfig: router,
      builder: (context, child) {
        return ChangeNotifierProvider(
            create: (BuildContext context) => CartModel(), child: child!);
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage(
      {super.key, required this.child, required this.currentIndex});

  final int currentIndex;
  final Widget child;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        GoRouter.of(context).go('/shop');
        break;
      case 1:
        GoRouter.of(context).go('/panier');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_rounded),
            label: 'Cart',
          ),
        ],
        currentIndex: widget.currentIndex,
        onTap: (int idx) => _onItemTapped(idx, context),
      ),
    );
  }
}
