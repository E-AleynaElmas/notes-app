import 'package:flutter/material.dart';
import 'package:notes_app/product/widgets/custom_text_field.dart';
import 'package:stacked/stacked.dart';
import 'auth_view_model.dart';
import 'package:notes_app/core/services/navigation_service.dart';
import 'package:notes_app/product/navigate/navigation_enums.dart';
import 'package:notes_app/core/constants/layout_constants.dart';
import 'package:notes_app/product/theme/theme_styles.dart';
import 'package:notes_app/product/constants/typography_constants.dart';

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
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: LayoutConstants.padding20All,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text('Welcome to', style: h4.white.regular),
                          Text('Notes', style: h2.white.bold),
                          LayoutConstants.emptyHeight48,
                        ],
                      ),
                      Container(
                        height: LayoutConstants.size48,
                        decoration: BoxDecoration(
                          color: ThemeStyles.secondaryColor,
                          borderRadius: BorderRadius.circular(LayoutConstants.radius20),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  if (!isLogin) viewModel.switchMode();
                                },
                                child: Container(
                                  height: LayoutConstants.size48,
                                  decoration: BoxDecoration(
                                    color: isLogin ? ThemeStyles.primaryColor : Colors.transparent,
                                    borderRadius: BorderRadius.circular(LayoutConstants.radius20),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Login',
                                      style: bodyXL
                                          .copyWith(color: isLogin ? ThemeStyles.whiteColor : ThemeStyles.grayColor)
                                          .w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  if (isLogin) viewModel.switchMode();
                                },
                                child: Container(
                                  height: LayoutConstants.size48,
                                  decoration: BoxDecoration(
                                    color: !isLogin ? ThemeStyles.primaryColor : Colors.transparent,
                                    borderRadius: BorderRadius.circular(LayoutConstants.radius20),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Register',
                                      style: bodyXL
                                          .copyWith(color: !isLogin ? ThemeStyles.whiteColor : ThemeStyles.grayColor)
                                          .w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      LayoutConstants.emptyHeight32,

                      Form(
                        key: viewModel.formKey,
                        child: Column(
                          children: [
                            CustomTextField(
                              controller: viewModel.emailController,
                              hintText: 'Email',
                              keyboardType: TextInputType.emailAddress,
                              validator: viewModel.validateEmail,
                            ),
                            LayoutConstants.emptyHeight16,
                            CustomTextField(
                              controller: viewModel.passController,
                              hintText: 'Password',
                              obscureText: viewModel.obscure,
                              validator: viewModel.validatePassword,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  viewModel.obscure ? Icons.visibility : Icons.visibility_off,
                                  color: ThemeStyles.grayColor,
                                ),
                                onPressed: viewModel.toggleObscure,
                              ),
                            ),
                            if (!isLogin) ...[
                              LayoutConstants.emptyHeight16,
                              CustomTextField(
                                controller: viewModel.pass2Controller,
                                hintText: 'Password again',
                                obscureText: viewModel.obscure,
                                validator: viewModel.validateConfirm,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    viewModel.obscure ? Icons.visibility : Icons.visibility_off,
                                    color: ThemeStyles.grayColor,
                                  ),
                                  onPressed: viewModel.toggleObscure,
                                ),
                              ),
                            ],
                            if (!isLogin) ...[
                              LayoutConstants.emptyHeight16,
                              Row(
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    color: ThemeStyles.primaryColor,
                                    size: LayoutConstants.size20,
                                  ),
                                  LayoutConstants.emptyWidth8,
                                  Expanded(
                                    child: Text(
                                      'Agree with Term & Conditions',
                                      style: TextStyle(color: ThemeStyles.grayColor, fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            LayoutConstants.emptyHeight32,
                            if (viewModel.hasError)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Text(viewModel.modelError?.toString() ?? '', style: bodyL.error),
                              ),
                            viewModel.isBusy
                                ? CircularProgressIndicator(color: ThemeStyles.primaryColor)
                                : SizedBox(
                                    width: double.infinity,
                                    height: LayoutConstants.size48,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        final ok = await viewModel.submit();
                                        if (ok && context.mounted) {
                                          nav.navigateToPageClear(navEnum: NavigationEnums.home);
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: ThemeStyles.primaryColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(LayoutConstants.radius20),
                                        ),
                                        elevation: 0,
                                      ),
                                      child: Text(isLogin ? 'Login' : 'Register', style: bodyXL.white.w600),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}