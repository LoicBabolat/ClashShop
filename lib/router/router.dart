import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/screens/cart.dart';
import '/screens/shop.dart';
import '/screens/item.dart';
import '../screens/validate_cart.dart';

import '/main.dart';

final GoRouter router = GoRouter(
  initialLocation: '/shop',
  routes: <RouteBase>[
    ShellRoute(
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return MyHomePage(
          currentIndex: switch (state.uri.path) {
            var p when p.startsWith('/shop') => 0,
            var p when p.startsWith('/panier') => 1,
            // TODO: Handle this case.
            String() => 0,
          },
          child: child,
        );
      },
      routes: <RouteBase>[
        GoRoute(
          path: '/shop',
          pageBuilder: (context, state) {
            return FadeTransitionPage(
              child: const ShopList(),
              key: state.pageKey,
            );
          },
          routes: <RouteBase>[
            GoRoute(
              path: 'item/:item',
              pageBuilder: (BuildContext context, GoRouterState state) {
                return CustomTransitionPage(
                  fullscreenDialog: true,
                  opaque: false,
                  transitionsBuilder: (_, __, ___, child) => child,
                  child: Item(
                    item: int.parse(state.pathParameters['item']!),
                  ),
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: '/panier',
          pageBuilder: (context, state) {
            return FadeTransitionPage(
              child: const Cart(),
              key: state.pageKey,
            );
          },
          routes: <RouteBase>[
            GoRoute(
              path: 'item/:item',
              // Display on the root Navigator
              pageBuilder: (BuildContext context, GoRouterState state) {
                return CustomTransitionPage(
                  fullscreenDialog: true,
                  opaque: false,
                  transitionsBuilder: (_, __, ___, child) => child,
                  child: Item(
                    item: int.parse(state.pathParameters['item']!),
                  ),
                );
              },
            ),
            GoRoute(
              path: 'validate',
              builder: (BuildContext context, GoRouterState state) {
                return const ValidateCart();
              },
            )
          ],
        ),
      ],
    ),
  ],
);

class FadeTransitionPage extends CustomTransitionPage<void> {
  /// Creates a [FadeTransitionPage].
  FadeTransitionPage({
    required LocalKey key,
    required Widget child,
  }) : super(
            key: key,
            transitionsBuilder: (BuildContext context,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation,
                    Widget child) =>
                FadeTransition(
                  opacity: animation.drive(_curveTween),
                  child: child,
                ),
            child: child);

  static final CurveTween _curveTween = CurveTween(curve: Curves.easeIn);
}
