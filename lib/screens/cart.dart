import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:collection/collection.dart';
import 'package:provider/provider.dart';
import 'package:testproject/widgets/button_CR.dart';
import 'package:testproject/widgets/inner_shadow_ui.dart';
import 'package:testproject/widgets/loading_widget.dart';
import 'package:testproject/widgets/row_infos.dart';
import 'package:testproject/widgets/text_ui.dart';
import '/data/list_cards_model.dart';

import '/data/cart_model.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  ListCardsModel listModel = ListCardsModel();
  bool isLoaded = false;

  void Function()? _validatePanier(CartModel cart, BuildContext context) {
    if (const ListEquality().equals(cart.getCart(), []) == false) {
      return () {
        GoRouter.of(context).go('/panier/validate');
        cart.removeAll();
      };
    } else {
      return null;
    }
  }

  void Function()? _clearPanier(CartModel cart, BuildContext context) {
    if (const ListEquality().equals(cart.getCart(), []) == false) {
      return () {
        cart.removeAll();
      };
    } else {
      return null;
    }
  }

  Future<void> loadAsset() async {
    await listModel.init();
    setState(() => listModel);
    isLoaded = true;
  }

  @override
  void initState() {
    super.initState();
    loadAsset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          title: const Text("Cart")),
      body: LoadingWidget(
        isLoaded: isLoaded,
        child: Column(
          children: [
            Expanded(
              child: Consumer<CartModel>(
                builder: (BuildContext context, CartModel cart, Widget? child) {
                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    itemCount: cart.getLength(),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 8.0),
                        child: InnerShadow(
                          blur: 5,
                          color: const Color.fromARGB(100, 0, 0, 0),
                          offset: const Offset(5, 5),
                          child: Container(
                            padding: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.background,
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: RowInfos(
                                itemData:
                                    listModel.getCard(cart.getCartItem(index)),
                                iconColor:
                                    Theme.of(context).colorScheme.primary,
                                iconData: Icons.info_outline,
                                onTapIcon: () {
                                  GoRouter.of(context).push(
                                      '/shop/item/${cart.getCartItem(index)}');
                                },
                                iconColor2: Theme.of(context).colorScheme.error,
                                iconData2: Icons.delete_outline,
                                onTapIcon2: () {
                                  cart.remove(cart.getCartItem(index));
                                }),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Consumer<CartModel>(
              builder: (BuildContext context, CartModel cart, Widget? child) {
                return Container(
                  height: 60,
                  decoration: BoxDecoration(
                      border: const Border(
                          bottom: BorderSide(
                              width: 1, color: Color.fromARGB(100, 0, 0, 0))),
                      color: Theme.of(context).colorScheme.background,
                      boxShadow: const [
                        BoxShadow(
                            offset: Offset(0, -1),
                            blurRadius: 5,
                            spreadRadius: 0,
                            color: Color.fromARGB(255, 0, 0, 0))
                      ]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          Text(
                              "Total : ${listModel.getTotalExlixir(cart.getCart())}"),
                          const Image(
                            width: 32,
                            image: AssetImage('assets/Icon_CR/elixir.png'),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          ButtonCR(
                            onTapFunction: _clearPanier(cart, context),
                            color: Theme.of(context).colorScheme.error,
                            width: 90,
                            child: const TextUI(text: "Clear"),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          ButtonCR(
                            onTapFunction: _validatePanier(cart, context),
                            color: Theme.of(context).colorScheme.surface,
                            width: 110,
                            child: const TextUI(text: "Validate"),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
