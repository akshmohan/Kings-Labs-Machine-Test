import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kingslabs_mt/config/routes.dart';
import 'package:kingslabs_mt/core/widgets/loader.dart';
import 'package:kingslabs_mt/viewModels/auth_viewModel.dart';
import 'package:kingslabs_mt/views/home_page.dart';
import 'package:kingslabs_mt/views/login_page.dart';


void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final authViewModel = ref.watch(authProvider);
    final themeMode = ref.watch(themeProvider);

   if (!authViewModel.isInitialised) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(
            child: Loader(),
          ),
        ),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      routes: Routes.route,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeMode ,
      home: authViewModel.isAuthenticated ? const HomePage() : const LoginPage(),
    );
  }
}