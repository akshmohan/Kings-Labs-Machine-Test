import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kingslabs_mt/core/widgets/loader.dart';
import 'package:kingslabs_mt/models/product_model.dart';
import 'package:kingslabs_mt/viewModels/details_viewModel.dart';

class ProductDetailsPage extends ConsumerStatefulWidget {
  const ProductDetailsPage({super.key, required this.id});

  final int id;

  @override
  ConsumerState<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends ConsumerState<ProductDetailsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(detailsProvider).getDetails(widget.id));
  }

  @override
  Widget build(BuildContext context) {
    final detailsViewModel = ref.watch(detailsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Product Details")),
      body: Center(
        child:
            detailsViewModel.isLoading
                ? const Loader()
                : detailsViewModel.errorMessage != null
                ? Text(
                  "Error: ${detailsViewModel.errorMessage}",
                  style: const TextStyle(color: Colors.red),
                )
                : detailsViewModel.product != null
                ? ProductDetailsView(product: detailsViewModel.product!)
                : const Text("No product data available"),
      ),
    );
  }
}

class ProductDetailsView extends StatelessWidget {
  final Product product;
  const ProductDetailsView({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Image.network(
              product.images.first,
              height: 200,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return SizedBox(height: 200, child: const Loader());
              },
              errorBuilder:
                  (context, error, stackTrace) => const Icon(
                    Icons.broken_image,
                    size: 100,
                    color: Colors.grey,
                  ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            product.title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            "Price: \$${product.price}",
            style: const TextStyle(fontSize: 18, color: Colors.green),
          ),
          const SizedBox(height: 8),
          Text(
            product.description,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                "Rating: ${product.rating}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Icon(Icons.star, color: Colors.orange),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            "Stock: ${product.stock > 0 ? 'Available' : 'Out of Stock'}",
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
