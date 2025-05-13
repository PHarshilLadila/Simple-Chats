import 'package:chat_app_bloc/App%20Functionality/Auth/bloc/authentication_bloc.dart';
import 'package:chat_app_bloc/App%20Functionality/Auth/bloc/authentication_event.dart';
import 'package:chat_app_bloc/App%20Functionality/Auth/bloc/authentication_state.dart';
import 'package:chat_app_bloc/App%20Widget/custome_textformfield.dart';
import 'package:chat_app_bloc/Constent/app_appbar.dart';
import 'package:chat_app_bloc/Constent/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPassword extends StatefulWidget {
  static String id = 'forgot-password';

  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword>
    with TickerProviderStateMixin {
  late AnimationController animationController;

  double containerLeftPedding = 20.0;
  double? animationValue;
  double translateX = 0;
  double translateY = 0;
  double roated = 0;
  double scale = 1;
  bool? show;
  bool send = false;
  Color color = AppColor.mainColor;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(microseconds: 3000),
    );
    show = true;
    animationController.addListener(() {
      setState(() {
        show = false;
        animationValue = animationController.value;
        if (animationValue! >= 0.2 && animationValue! < 0.4) {
          containerLeftPedding = 100.0;
          color = const Color.fromARGB(255, 88, 202, 172);
        } else if (animationValue! >= 0.4 && animationValue! <= 0.5) {
          translateX = 80.0;
          roated = -20.0;
          scale = 0.1;
          color = const Color.fromARGB(255, 88, 202, 172);
        } else if (animationValue! >= 0.5 && animationValue! <= 0.8) {
          translateY = -20.0;
          color = const Color.fromARGB(255, 88, 202, 172);
        } else if (animationValue! >= 0.81) {
          containerLeftPedding = 20.0;
          color = const Color.fromARGB(255, 88, 202, 172);
          send = true;
        }
      });
    });
  }

  final TextEditingController emailController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomeAppBar(
        automaticallyImplyLeadings: false,
        titleWidget: Text(
          "Reset Password",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      backgroundColor: AppColor.backgroundColor,
      body: BlocConsumer<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is AuthenticationLoadingState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Loading...')),
            );
          } else if (state is AuthenticationSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Email sent successfully.')),
            );
          } else if (state is AuthenticationFailureState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage)),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/forgotpass.png",
                    height: 250,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text(
                      "Enter the email address associated with your Google Account.",
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 8),
                    child: Text(
                      "We will email you a link to reset your Password",
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomeTextformfield(
                          keybordType: TextInputType.emailAddress,
                          controller: emailController,
                          obscureText: false,
                          autofocus: true,
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
                        const SizedBox(height: 20),
                        // SizedBox(
                        //   height: 50,
                        //   child: ElevatedButton(
                        //     style: ElevatedButton.styleFrom(
                        //       backgroundColor: AppColor.mainColor,
                        //       shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(15),
                        //       ),
                        //     ),
                        //     onPressed: () {
                        //       if (_formKey.currentState?.validate() ?? false) {
                        //         BlocProvider.of<AuthenticationBloc>(context)
                        //             .add(
                        //           ForgotPasswordEvent(
                        //             emailController.text.trim(),
                        //           ),
                        //         );
                        //         ScaffoldMessenger.of(context).showSnackBar(
                        //           const SnackBar(
                        //             content: Text(
                        //               'Email Send Successfully Check Your Email & Change You Password and Login Again..!',
                        //             ),
                        //           ),
                        //         );
                        //       }
                        //     },
                        //     child: Text(
                        //       "Send Email",
                        //       style: GoogleFonts.poppins(
                        //         color: Colors.white,
                        //         fontSize: 15,
                        //         fontWeight: FontWeight.w500,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                BlocProvider.of<AuthenticationBloc>(context)
                                    .add(
                                  ForgotPasswordEvent(
                                    emailController.text.trim(),
                                  ),
                                );
                                animationController.forward();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: AppColor.mainColor,
                                    content: const Text(
                                      'Email Send Successfully Check Your Email & Change You Password and Login Again..!',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                );
                              }
                            },
                            child: AnimatedContainer(
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(100),
                                boxShadow: [
                                  BoxShadow(
                                    color: color,
                                    blurRadius: 21,
                                    spreadRadius: -15,
                                    offset: const Offset(0.0, 20.0),
                                  ),
                                ],
                              ),
                              padding: EdgeInsets.only(
                                left: containerLeftPedding,
                                right: 20.0,
                                top: 10.0,
                                bottom: 10.0,
                              ),
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeOutCubic,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  (!send)
                                      ? AnimatedContainer(
                                          duration: const Duration(
                                            milliseconds: 800,
                                          ),
                                          curve: Curves.fastOutSlowIn,
                                          transform: Matrix4.translationValues(
                                              translateX, translateY, 0)
                                            ..rotateZ(roated)
                                            ..scale(scale),
                                          child: const Icon(
                                            Icons.send,
                                            color: Colors.white,
                                          ),
                                        )
                                      : Container(),
                                  AnimatedSize(
                                    duration: const Duration(milliseconds: 600),
                                    child: show!
                                        ? const SizedBox(width: 10.0)
                                        : Container(),
                                  ),
                                  AnimatedSize(
                                    duration: const Duration(milliseconds: 200),
                                    child: show!
                                        ? const Text(
                                            "Send",
                                            style:
                                                TextStyle(color: Colors.white),
                                          )
                                        : Container(),
                                  ),
                                  AnimatedSize(
                                    duration: const Duration(milliseconds: 200),
                                    child: send
                                        ? const Icon(
                                            Icons.done,
                                            color: Colors.white,
                                          )
                                        : Container(),
                                  ),
                                  AnimatedSize(
                                    alignment: Alignment.topLeft,
                                    duration: const Duration(milliseconds: 600),
                                    child: send
                                        ? const SizedBox(width: 10.0)
                                        : Container(),
                                  ),
                                  AnimatedSize(
                                    duration: const Duration(milliseconds: 200),
                                    child: send
                                        ? const Text(
                                            "Done",
                                            style:
                                                TextStyle(color: Colors.white),
                                          )
                                        : Container(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
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
