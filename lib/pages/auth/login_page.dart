import 'package:d_button/d_button.dart';
import 'package:d_input/d_input.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundry_app/config/app_assets.dart';
import 'package:laundry_app/config/app_colors.dart';
import 'package:laundry_app/config/app_constants.dart';
import 'package:laundry_app/config/app_response.dart';
import 'package:laundry_app/config/app_sessions.dart';
import 'package:laundry_app/config/custom_snackbar.dart';
import 'package:laundry_app/config/exception_response.dart';
import 'package:laundry_app/config/navigation.dart';
import 'package:laundry_app/datasources/user_datasource.dart';
import 'package:laundry_app/pages/auth/register_page.dart';
import 'package:laundry_app/pages/main_bottom_nav_page.dart';
import 'package:laundry_app/providers/login_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final edtEmail = TextEditingController();
  final edtPassword = TextEditingController();
  final formKey = GlobalKey<FormState>();

  executeLogin() {
    bool validInput = formKey.currentState!.validate();
    if (!validInput) return null;

    setStatusLoginProvider(ref, 'Loading');

    UserDatasource.login(
      edtEmail.text,
      edtPassword.text,
    ).then((value) {
      String newStatus = '';

      value.fold((fail) {
        switch (fail.runtimeType) {
          case ServerFailure:
            newStatus = 'Server Error';
            ShowSnackbarCustom.showCustomSnackbarError(context, newStatus);
            break;
          case NotFoundFailure:
            newStatus = 'Error Not Found';
            ShowSnackbarCustom.showCustomSnackbarError(context, newStatus);
            break;
          case ForbidenFailure:
            newStatus = 'You don\'t have access';
            ShowSnackbarCustom.showCustomSnackbarError(context, newStatus);
            break;
          case BadRequestFailure:
            newStatus = 'Bad request';
            ShowSnackbarCustom.showCustomSnackbarError(context, newStatus);
            break;
          case InvalidInputFailur:
            newStatus = 'Invalid Input';
            AppResponse.invalidInput(context, fail.message ?? '{}');
            break;
          case UnauthorizedFailure:
            newStatus = 'Login Failed';
            ShowSnackbarCustom.showCustomSnackbarError(context, newStatus);
            break;
          default:
            newStatus = 'Request Error';
            ShowSnackbarCustom.showCustomSnackbarError(context, newStatus);
            newStatus = fail.message ?? '-';
            break;
        }
        setStatusLoginProvider(ref, newStatus);
      }, (result) {
        AppSessions.setUser(result['data']);
        AppSessions.setBearerToken(result['data']['token']);
        ShowSnackbarCustom.showCustomSnackbarSuccess(context, 'Login Success');
        setStatusLoginProvider(ref, 'Success');
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const MainBottomNavPage(),
            ),
            (route) => false);
        // Nav.replace(context, const MainBottomNavPage());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            AppAssets.bgAuth,
            fit: BoxFit.cover,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height / 2,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.black54,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 60, 30, 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Column(
                    children: [
                      Text(
                        AppConstants.appName,
                        style: GoogleFonts.poppins(
                          fontSize: 40,
                          color: Colors.green[900],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Container(
                        width: 40,
                        height: 5,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      )
                    ],
                  ),
                ),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      IntrinsicHeight(
                        child: Row(
                          children: [
                            AspectRatio(
                              aspectRatio: 1,
                              child: Material(
                                color: Colors.white70,
                                borderRadius: BorderRadius.circular(10.0),
                                child: const Icon(
                                  Icons.email,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ),
                            DView.spaceWidth(10),
                            Expanded(
                              child: DInput(
                                controller: edtEmail,
                                fillColor: Colors.white70,
                                hint: 'Email',
                                radius: BorderRadius.circular(10),
                                validator: (input) =>
                                    input == '' ? "Don't empty" : null,
                              ),
                            ),
                          ],
                        ),
                      ),
                      DView.spaceHeight(16),
                      IntrinsicHeight(
                        child: Row(
                          children: [
                            AspectRatio(
                              aspectRatio: 1,
                              child: Material(
                                color: Colors.white70,
                                borderRadius: BorderRadius.circular(10.0),
                                child: const Icon(
                                  Icons.key,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ),
                            DView.spaceWidth(10),
                            Expanded(
                              child: DInputPassword(
                                controller: edtPassword,
                                fillColor: Colors.white70,
                                hint: 'Password',
                                radius: BorderRadius.circular(10),
                                validator: (input) =>
                                    input == '' ? "Don't empty" : null,
                              ),
                            ),
                          ],
                        ),
                      ),
                      DView.spaceHeight(16.0),
                      IntrinsicHeight(
                        child: Row(
                          children: [
                            AspectRatio(
                              aspectRatio: 1,
                              child: DButtonFlat(
                                onClick: () {
                                  Nav.push(context, const RegisterPage());
                                },
                                padding: const EdgeInsets.all(0),
                                radius: 10,
                                mainColor: Colors.white70,
                                child: const Text(
                                  'Reg',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            DView.spaceWidth(10),
                            Expanded(
                              child: Consumer(
                                builder: (_, wiRef, __) {
                                  final status =
                                      wiRef.watch(loginStatusProvider);
                                  if (status == "Loading") {
                                    return DView.loadingCircle();
                                  }
                                  return ElevatedButton(
                                    style: const ButtonStyle(
                                      alignment: Alignment.centerLeft,
                                    ),
                                    onPressed: () => executeLogin(),
                                    child: const Text(
                                      'Login',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
