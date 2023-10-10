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
import 'package:laundry_app/config/custom_snackbar.dart';
import 'package:laundry_app/config/exception_response.dart';
import 'package:laundry_app/datasources/user_datasource.dart';
import 'package:laundry_app/providers/register_provider.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final edtUsername = TextEditingController();
  final edtEmail = TextEditingController();
  final edtPassword = TextEditingController();
  final formKey = GlobalKey<FormState>();

  executeRegiter() {
    bool validInput = formKey.currentState!.validate();

    if (!validInput) return null;

    setRegisterStatus(ref, "Loading");

    UserDatasource.register(
      edtUsername.text,
      edtEmail.text,
      edtPassword.text,
    ).then((value) {
      String newStatus = '';

      value.fold(
        (failure) {
          switch (failure.runtimeType) {
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
              newStatus = 'Error Bad Request';
              ShowSnackbarCustom.showCustomSnackbarError(context, newStatus);
              break;
            case InvalidInputFailur:
              newStatus = 'Error Invalid Input';
              AppResponse.invalidInput(context, failure.message ?? '{}');
              break;
            case UnauthorizedFailure:
              newStatus = 'Unauthorised';
              ShowSnackbarCustom.showCustomSnackbarError(context, newStatus);
              break;
            default:
              newStatus = 'Request Error';
              ShowSnackbarCustom.showCustomSnackbarError(context, newStatus);
              newStatus = failure.message ?? '-';
              break;
          }
          setRegisterStatus(ref, newStatus);
        },
        (result) {
          ShowSnackbarCustom.showCustomSnackbarSuccess(
              context, 'Register Success');
          setRegisterStatus(ref, 'Success');
        },
      );
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
                        height: 5,
                        width: 40,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
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
                                  Icons.person,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                            DView.spaceWidth(10.0),
                            Expanded(
                              child: DInput(
                                controller: edtUsername,
                                fillColor: Colors.white70,
                                hint: 'Username',
                                radius: BorderRadius.circular(10.0),
                                validator: (input) =>
                                    input == '' ? 'Dont Empty' : null,
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
                                  Icons.email,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                            DView.spaceWidth(10.0),
                            Expanded(
                              child: DInput(
                                controller: edtEmail,
                                fillColor: Colors.white70,
                                hint: 'Email',
                                radius: BorderRadius.circular(10.0),
                                validator: (input) =>
                                    input == '' ? 'Dont Empty' : null,
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
                                  color: Colors.green,
                                ),
                              ),
                            ),
                            DView.spaceWidth(10.0),
                            Expanded(
                              child: DInputPassword(
                                controller: edtPassword,
                                fillColor: Colors.white70,
                                hint: 'Password',
                                radius: BorderRadius.circular(10.0),
                                validator: (input) =>
                                    input == '' ? 'Dont Empty' : null,
                              ),
                            ),
                          ],
                        ),
                      ),
                      DView.spaceHeight(10.0),
                      IntrinsicHeight(
                        child: Row(
                          children: [
                            AspectRatio(
                              aspectRatio: 1,
                              child: DButtonFlat(
                                onClick: () {
                                  Navigator.pop(context);
                                },
                                mainColor: Colors.white70,
                                padding: const EdgeInsets.all(0),
                                radius: 10,
                                child: const Text(
                                  "Log",
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            DView.spaceWidth(10.0),
                            Expanded(
                              child: Consumer(
                                builder: (_, wiRef, __) {
                                  String status =
                                      wiRef.watch(registerStatusProvider);
                                  if (status == 'Loading') {
                                    return DView.loadingCircle();
                                  }
                                  return ElevatedButton(
                                    onPressed: () => executeRegiter(),
                                    style: const ButtonStyle(
                                      alignment: Alignment.centerLeft,
                                    ),
                                    child: const Text('Register'),
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
