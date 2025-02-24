// ignore_for_file: avoid_print, use_build_context_synchronously, body_might_complete_normally_nullable, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kingslabs_mt/config/routes.dart';
import 'package:kingslabs_mt/core/constants/app_colors.dart';
import 'package:kingslabs_mt/core/constants/strings.dart';
import 'package:kingslabs_mt/core/widgets/custom_dialog.dart';
import 'package:kingslabs_mt/core/widgets/custom_text_field.dart';
import 'package:kingslabs_mt/core/widgets/loader.dart';
import 'package:kingslabs_mt/core/widgets/snackbar.dart';
import 'package:kingslabs_mt/viewModels/auth_viewModel.dart';
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  final key = GlobalKey<FormState>();

  late final authViewModel = ref.watch(authProvider);

  final isObscureProvider = StateProvider<bool>((ref) => true);

  final isLoadingProvider = StateProvider<bool>((ref) => false);

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isObscure = ref.watch(isObscureProvider);
    final isLoading = ref.watch(isLoadingProvider);

    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      body: Stack(
        children: [
          Container(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Form(
                key: key,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      Strings.loginTitle,
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge!
                          .copyWith(color: AppColors.primaryColor),
                    ),
                    const SizedBox(height: 60),
                    CustomTextField(
                        controller: usernameController,
                        label: "Username",
                        hintText: "Enter Username",
                        prefixIcon: const Icon(Icons.person,
                            color: AppColors.primaryColor),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return Strings.usernameValidator;
                          }
                        }),
                    const SizedBox(height: 30),
                    CustomTextField(
                      prefixIcon:
                          const Icon(Icons.lock, color: AppColors.primaryColor),
                      controller: passwordController,
                      label: 'Password',
                      hintText: 'Enter password',
                      obscureText: isObscure,
                      suffixIcon: IconButton(
                        color: Colors.white,
                        icon: Icon(isObscure
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          ref.read(isObscureProvider.notifier).state =
                              !isObscure;
                        },
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return Strings.passwordValidator;
                        }
                      },
                    ),
                    const SizedBox(height: 30),
                    Container(
                      color: AppColors.primaryColor,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: isLoading
                            ? null
                            : () async {
                                if (key.currentState!.validate()) {
                                  ref.read(isLoadingProvider.notifier).state =
                                      true;
                      
                                  try {
                                    await authViewModel.login(
                                      usernameController.text.trim(),
                                      passwordController.text.trim(),
                                    );
                                    if (authViewModel.isAuthenticated) {
                                      showSnackbar("Logged in successfully!", context);
                      
                                      Navigator.pushNamedAndRemoveUntil(context,
                                          Routes.homePage, (route) => false);
                                    }
                                  } catch (e) {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return CustomDialog(
                                          title: "Invalid Credentials!",
                                          content:
                                              "The username or password you entered is incorrect. Please try again.",
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text("OK"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    print("----------------------------ERROR:${e.toString()}---------------------------");
                                  } finally {
                                    ref.read(isLoadingProvider.notifier).state =
                                        false;
                                  }
                                }
                              },
                        child: const Text(
                          Strings.loginButton,
                          style: TextStyle(
                            color: AppColors.secondaryColor,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withAlpha(128),
              child: const Loader(),
            ),
        ],
      ),
    );
  }
}