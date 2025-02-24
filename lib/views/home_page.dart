import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kingslabs_mt/core/constants/app_colors.dart';
import 'package:kingslabs_mt/core/widgets/custom_dialog.dart';
import 'package:kingslabs_mt/core/widgets/loader.dart';
import 'package:kingslabs_mt/core/widgets/snackbar.dart';
import 'package:kingslabs_mt/viewModels/auth_viewModel.dart';
import 'package:kingslabs_mt/viewModels/product_viewModel.dart';
import 'package:kingslabs_mt/views/product_details_page.dart';

final themeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.light);

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(productProvider.notifier).getAllProducts());
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final productViewModel = ref.watch(productProvider);
    final themeMode = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome, ${authState.username}"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              ref.read(themeProvider.notifier).state =
                  themeMode == ThemeMode.light
                      ? ThemeMode.dark
                      : ThemeMode.light;
            },
            icon: Icon(
              themeMode == ThemeMode.light ? Icons.dark_mode : Icons.light_mode,
            ),
          ),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return CustomDialog(
                    title: "Logout",
                    content: "Are you sure you want to logout?",
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("No"),
                      ),
                      TextButton(
                        onPressed: () async {
                          await ref.read(authProvider.notifier).logout();
                          Navigator.of(context).pop();
                          showSnackbar("Logged out Successfully!", context);
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            "/login",
                            (route) => false,
                          );
                        },
                        child: const Text("Yes"),
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body:
          productViewModel.isLoading
              ? const Center(child: Loader())
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.builder(
                  itemCount: productViewModel.products.length,
                  itemBuilder: (context, index) {
                    final product = productViewModel.products[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => ProductDetailsPage(id: product.id),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: AppColors.secondaryColor,
                            width: 2,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  product.thumbnail,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (
                                    context,
                                    child,
                                    loadingProgress,
                                  ) {
                                    if (loadingProgress == null) return child;
                                    return const SizedBox(
                                      width: 80,
                                      height: 80,
                                      child: Center(
                                        child: Loader(),
                                      ),
                                    );
                                  },
                                  errorBuilder:
                                      (context, error, stackTrace) =>
                                          const Icon(
                                            Icons.image_not_supported,
                                            size: 80,
                                            color: Colors.grey,
                                          ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.title,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      product.description,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "\$${product.price.toStringAsFixed(2)}",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                              size: 16,
                                            ),
                                            Text(
                                              product.rating.toString(),
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
    );
  }
}
