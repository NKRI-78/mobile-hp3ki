import 'package:flutter/material.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> with TickerProviderStateMixin {
  bool isAddedToCart = false;
  AnimationController? _cartController;
  Animation<double>? _cartAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller for the cart shake
    _cartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _cartAnimation = Tween<double>(begin: 0, end: 8).chain(CurveTween(curve: Curves.elasticIn)).animate(_cartController!)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _cartController!.reverse();
        }
      });
  }

  @override
  void dispose() {
    _cartController!.dispose();
    super.dispose();
  }

  // Function to simulate adding product to the cart
  void addToCart() {
    setState(() {
      isAddedToCart = true;
    });

    // Start the cart shake animation
    _cartController!.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {},
        ),
        actions: [
          AnimatedBuilder(
            animation: _cartController!,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _cartAnimation!.value),
                child: IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () {},
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Product image and details
          Column(
            children: [
              Image.network('https://via.placeholder.com/300'),
              const Text('Rp 500'),
              const Text('Barang'),
              ElevatedButton(
                onPressed: addToCart,
                child: const Text('Tambah Keranjang'),
              ),
            ],
          ),
          // Add animation of product moving towards the cart
          if (isAddedToCart)
            AnimatedPositioned(
              top: 100,
              right: 50,
              duration: const Duration(milliseconds: 500),
              onEnd: () {
                setState(() {
                  isAddedToCart = false;
                });
              },
              child: const Icon(
                Icons.shopping_bag,
                size: 50,
                color: Colors.purple,
              ),
            ),
        ],
      ),
    );
  }
}