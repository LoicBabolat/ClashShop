import 'package:flutter/material.dart';

import '../widgets/text_ui.dart';

class ValidateCart extends StatelessWidget {
  const ValidateCart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          title: const Text("Validation")),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
                child: TextUI(text: "Your shopping cart has been validated")),
            Icon(
              Icons.done_sharp,
              size: 40,
            )
          ],
        ),
      ),
    );
  }
}
