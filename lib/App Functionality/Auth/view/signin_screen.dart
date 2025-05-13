import 'package:chat_app_bloc/App%20Functionality/Auth/bloc/authentication_bloc.dart';
import 'package:chat_app_bloc/App%20Functionality/Auth/bloc/authentication_event.dart';
import 'package:chat_app_bloc/App%20Functionality/Auth/bloc/authentication_state.dart';
import 'package:chat_app_bloc/App%20Functionality/Auth/view/forgot_password.dart';
import 'package:chat_app_bloc/App%20Functionality/Auth/view/signup_screen.dart';
import 'package:chat_app_bloc/App%20Functionality/Landing%20Page/view/landing_page.dart';
import 'package:chat_app_bloc/App%20Widget/custome_textformfield.dart';
import 'package:chat_app_bloc/Constent/app_color.dart';
import 'package:chat_app_bloc/Constent/app_font_style.dart';
import 'package:chat_app_bloc/Service/analytics_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final textFieldFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  final AnalyticsService service = AnalyticsService();
  bool showPasswords = true;

  void toggleShowPassword() {
    setState(() {
      showPasswords = !showPasswords;
      if (textFieldFocusNode.hasPrimaryFocus) return;
      textFieldFocusNode.canRequestFocus = false;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: BlocConsumer<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is AuthenticationSuccessState) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LandingPage()),
              (route) => false,
            );
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Login Successful')),
            );
          } else if (state is AuthenticationFailureState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage)),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 40.0),
                    child: AppText(
                      text: 'Login With Simple Chats',
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      size: 22,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Image.asset(
                    "assets/images/login.png",
                    width: 250,
                  ),
                  const SizedBox(height: 25),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomeTextformfield(
                          keybordType: TextInputType.emailAddress,
                          controller: emailController,
                          obscureText: false,
                          autofocus: true,
                          focusNode: emailFocusNode,
                          onFieldSubmitted: (value) {
                            FocusScope.of(context)
                                .requestFocus(passwordFocusNode);
                          },
                          prefixIcon: const Padding(
                            padding: EdgeInsets.all(15.0),
                            child: FaIcon(
                              FontAwesomeIcons.envelope,
                              size: 20,
                              semanticLabel: "Email",
                            ),
                          ),
                          labelText: "Email (john@gmail.com)",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (value.isEmpty ||
                                !value.contains('@') ||
                                !value.contains('.')) {
                              return 'Please enter valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        CustomeTextformfield(
                          keybordType: TextInputType.visiblePassword,
                          controller: passwordController,
                          obscureText: showPasswords,
                          autofocus: true,
                          focusNode: passwordFocusNode,
                          prefixIcon: const Padding(
                            padding: EdgeInsets.all(15.0),
                            child: FaIcon(
                              FontAwesomeIcons.key,
                              size: 20,
                              semanticLabel: "Password",
                            ),
                          ),
                          suffixIcon: IconButton(
                            onPressed: toggleShowPassword,
                            icon: showPasswords
                                ? const FaIcon(
                                    FontAwesomeIcons.eyeSlash,
                                    size: 20,
                                    color: Colors.black,
                                    semanticLabel: "Password",
                                  )
                                : const FaIcon(
                                    FontAwesomeIcons.eye,
                                    size: 20,
                                    color: Colors.black,
                                    semanticLabel: "Password",
                                  ),
                          ),
                          labelText: "Password",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 8) {
                              return 'Password should have atleast 8 characters';
                            }
                            if (!value.contains(RegExp(r'[A-Z]'))) {
                              return "Password must contain at least one uppercase letter";
                            }
                            if (!value.contains(RegExp(r'[a-z]'))) {
                              return "Password must contain at least one lowercase  letter";
                            }
                            if (!value.contains(RegExp(r'[0-9]'))) {
                              return "Password must contain at least one numeric character";
                            }
                            if (!value
                                .contains(RegExp(r'[!@#\$%^&*()<>?/|}{~:]'))) {
                              return "Password must contain at least one special character";
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        debugPrint('Forgot Password');
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ForgotPassword(),
                            ));
                      },
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.mainColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          BlocProvider.of<AuthenticationBloc>(context).add(
                            LoginUser(
                              emailController.text.trim(),
                              passwordController.text.trim(),
                            ),
                          );
                          String method1 =
                              "Email + Password${emailController.text.trim()}";
                          service.logLogin(method1);
                          debugPrint(emailController.text.trim());
                          debugPrint(passwordController.text.trim());
                        }
                      },
                      child: AppText(
                        text: 'Login',
                        color: AppColor.backgroundColor,
                        size: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 35),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider.value(
                            value: context.read<AuthenticationBloc>(),
                            child: const SignUpScreen(),
                          ),
                        ),
                      );
                    },
                    child: RichText(
                      text: TextSpan(
                        text: "Don't  have an account? ",
                        style:
                            const TextStyle(color: Colors.black, fontSize: 13),
                        children: <TextSpan>[
                          TextSpan(
                            text: " Sign Up",
                            style: TextStyle(
                                color: AppColor.mainColor, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
