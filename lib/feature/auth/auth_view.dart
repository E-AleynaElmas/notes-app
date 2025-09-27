import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'auth_view_model.dart';
import 'package:notes_app/product/widgets/custom_text_field.dart';
import 'package:notes_app/core/services/navigation_service.dart';
import 'package:notes_app/product/navigate/navigation_enums.dart';

class AuthView extends StatelessWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    final nav = NavigationService.instance;

    return ViewModelBuilder<AuthViewModel>.reactive(
      viewModelBuilder: () => AuthViewModel(),
      builder: (context, viewModel, child) {
        final isLogin = viewModel.mode == AuthMode.login;
        return Scaffold(
          appBar: AppBar(
            title: Text(isLogin ? 'Giriş' : 'Kayıt'),
            actions: [
              TextButton(
                onPressed: viewModel.switchMode,
                child: Text(isLogin ? 'Kayıt Ol' : 'Giriş Yap', style: const TextStyle(fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: viewModel.formKey,
              child: ListView(
                children: [
                  CustomTextField(
                    controller: viewModel.emailController,
                    label: 'E-posta',
                    keyboardType: TextInputType.emailAddress,
                    inputFormatters: viewModel.emailFormatters,
                    validator: viewModel.validateEmail,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: viewModel.passController,
                    label: 'Şifre',
                    obscureText: viewModel.obscure,
                    inputFormatters: viewModel.passwordFormatters,
                    validator: viewModel.validatePassword,
                    suffixIcon: IconButton(
                      icon: Icon(viewModel.obscure ? Icons.visibility : Icons.visibility_off),
                      onPressed: viewModel.toggleObscure,
                    ),
                  ),
                  if (!isLogin) ...[
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: viewModel.pass2Controller,
                      label: 'Şifre (tekrar)',
                      obscureText: viewModel.obscure,
                      inputFormatters: viewModel.passwordFormatters,
                      validator: viewModel.validateConfirm,
                      suffixIcon: IconButton(
                        icon: Icon(viewModel.obscure ? Icons.visibility : Icons.visibility_off),
                        onPressed: viewModel.toggleObscure,
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  if (viewModel.hasError)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(viewModel.modelError?.toString() ?? '', style: const TextStyle(color: Colors.red)),
                    ),
                  viewModel.isBusy
                      ? const Center(child: CircularProgressIndicator())
                      : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              final ok = await viewModel.submit();
                              if (ok && context.mounted) {
                                nav.navigateToPageClear(navEnum: NavigationEnums.home);
                              }
                            },
                            child: Text(isLogin ? 'Giriş Yap' : 'Kayıt Ol'),
                          ),
                        ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
