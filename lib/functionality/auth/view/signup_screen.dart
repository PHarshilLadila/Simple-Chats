// // ignore_for_file: use_build_context_synchronously

// import 'dart:convert';
// import 'dart:typed_data';

// import 'package:chat_app_bloc/App%20Functionality/Auth/bloc/authentication_bloc.dart';
// import 'package:chat_app_bloc/App%20Functionality/Auth/bloc/authentication_event.dart';
// import 'package:chat_app_bloc/App%20Functionality/Auth/bloc/authentication_state.dart';
// import 'package:chat_app_bloc/App%20Functionality/Auth/view/signin_screen.dart';
// import 'package:chat_app_bloc/App%20Functionality/Landing%20Page/view/landing_page.dart';
// import 'package:chat_app_bloc/App%20Widget/custome_textformfield.dart';
// import 'package:chat_app_bloc/Constent/app_color.dart';
// import 'package:chat_app_bloc/Constent/app_font_style.dart';
// import 'package:chat_app_bloc/Constent/app_string.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:image_picker/image_picker.dart';

// class SignUpScreen extends StatefulWidget {
//   const SignUpScreen({super.key});

//   @override
//   State<SignUpScreen> createState() => _SignUpScreenState();
// }

// class _SignUpScreenState extends State<SignUpScreen> {
//   final TextEditingController emailController = TextEditingController();

//   final TextEditingController passwordController = TextEditingController();

//   final TextEditingController nameController = TextEditingController();

//   final TextEditingController mobileNumberController = TextEditingController();

//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   final textFieldFocusNode = FocusNode();

//   FocusNode nameFocusNode = FocusNode();
//   FocusNode mobileFocusNode = FocusNode();
//   FocusNode emailFocusNode = FocusNode();
//   FocusNode passwordFocusNode = FocusNode();
//   String? profileImage;

//   bool showPasswords = true;

//   void toggleShowPassword() {
//     setState(() {
//       showPasswords = !showPasswords;
//       if (textFieldFocusNode.hasPrimaryFocus) return;
//       textFieldFocusNode.canRequestFocus = false;
//     });
//   }

//   void showModal(BuildContext context) {
//     showModalBottomSheet<void>(
//       isDismissible: true,
//       elevation: 50,
//       context: context,
//       builder: (_) {
//         return Container(
//           height: 120,
//           width: double.infinity,
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(50),
//               topRight: Radius.circular(50),
//             ),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Column(
//                   children: [
//                     Container(
//                       margin: const EdgeInsets.all(8),
//                       padding: const EdgeInsets.all(2),
//                       decoration: BoxDecoration(
//                           shape: BoxShape.rectangle,
//                           color: Theme.of(context).primaryColor,
//                           borderRadius: BorderRadius.circular(12)),
//                       child: IconButton(
//                         icon: const FaIcon(
//                           FontAwesomeIcons.image,
//                           color: Colors.white,
//                           size: 22,
//                         ),
//                         onPressed: () async {
//                           final image = await ImagePicker().pickImage(
//                             imageQuality: 20,
//                             source: ImageSource.gallery,
//                           );
//                           if (image != null) {
//                             final imageTemp = XFile(image.path);
//                             Uint8List imageBytes =
//                                 await imageTemp.readAsBytes();
//                             String base64image = base64Encode(imageBytes);
//                             setState(() {
//                               profileImage = base64image;
//                             });
//                             context.read<AuthenticationBloc>().add(
//                                   SelectProfileUrl(profileImage!),
//                                 );
//                           }
//                           Navigator.pop(context);
//                         },
//                       ),
//                     ),
//                     const Text(
//                       "Image",
//                     ),
//                   ],
//                 ),
//                 Column(
//                   children: [
//                     Container(
//                       margin: const EdgeInsets.all(8),
//                       padding: const EdgeInsets.all(2),
//                       decoration: BoxDecoration(
//                           shape: BoxShape.rectangle,
//                           color: Theme.of(context).primaryColor,
//                           borderRadius: BorderRadius.circular(12)),
//                       child: IconButton(
//                         icon: const FaIcon(
//                           FontAwesomeIcons.camera,
//                           color: Colors.white,
//                           size: 22,
//                         ),
//                         onPressed: () async {
//                           final image = await ImagePicker().pickImage(
//                             imageQuality: 20,
//                             source: ImageSource.camera,
//                           );
//                           if (image != null) {
//                             final imageTemp = XFile(image.path);
//                             Uint8List imageBytes =
//                                 await imageTemp.readAsBytes();
//                             String base64image = base64Encode(imageBytes);
//                             setState(() {
//                               profileImage = base64image;
//                             });
//                             context.read<AuthenticationBloc>().add(
//                                   SelectProfileUrl(profileImage!),
//                                 );
//                           }
//                           Navigator.pop(context);
//                         },
//                       ),
//                     ),
//                     const Text(
//                       "Camera",
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColor.backgroundColor,
//       body: BlocConsumer<AuthenticationBloc, AuthenticationState>(
//         listener: (context, state) {
//           if (state is AuthenticationSuccessState) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text('Sign Up Successful')),
//             );
//           } else if (state is AuthenticationFailureState) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text(state.errorMessage)),
//             );
//           }
//         },
//         builder: (context, state) {
//           return SingleChildScrollView(
//             scrollDirection: Axis.vertical,
//             physics: const BouncingScrollPhysics(),
//             keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
//             child: Padding(
//               padding: const EdgeInsets.all(10.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   const Padding(
//                     padding: EdgeInsets.only(top: 50.0),
//                     child: AppText(
//                       text: 'Register With Simple Chats',
//                       color: Colors.black87,
//                       fontWeight: FontWeight.bold,
//                       size: 22,
//                     ),
//                   ),
//                   const SizedBox(height: 15),
//                   Image.asset(
//                     "assets/images/signup.png",
//                     width: 250,
//                   ),
//                   const SizedBox(height: 25),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       profileImage != null
//                           ? ClipRRect(
//                               borderRadius: BorderRadius.circular(50),
//                               child: Image.memory(
//                                 base64Decode(profileImage!),
//                                 fit: BoxFit.cover,
//                                 height: 100,
//                                 width: 100,
//                               ),
//                             )
//                           : ClipRRect(
//                               borderRadius: BorderRadius.circular(50),
//                               child: Image.memory(
//                                 base64Decode(AppString.demoImgurl),
//                                 fit: BoxFit.cover,
//                                 height: 100,
//                                 width: 100,
//                               ),
//                             ),
//                       const SizedBox(width: 15),
//                       Expanded(
//                         child: SizedBox(
//                           height: 50,
//                           width: double.infinity,
//                           child: ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Theme.of(context).primaryColor,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(15),
//                               ),
//                             ),
//                             onPressed: () {
//                               showModal(context);
//                             },
//                             child: const Text(
//                               "Select Profile",
//                               style: TextStyle(color: Colors.white),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 15),
//                   Form(
//                     autovalidateMode: AutovalidateMode.always,
//                     key: _formKey,
//                     child: Column(
//                       children: [
//                         CustomTextformfield(
//                           keybordType: TextInputType.name,
//                           controller: nameController,
//                           obscureText: false,
//                           autofocus: true,
//                           focusNode: nameFocusNode,
//                           onFieldSubmitted: (value) {
//                             FocusScope.of(context)
//                                 .requestFocus(mobileFocusNode);
//                           },
//                           prefixIcon: const Padding(
//                             padding: EdgeInsets.all(15.0),
//                             child: FaIcon(
//                               FontAwesomeIcons.user,
//                               size: 20,
//                               semanticLabel: "Enter Name",
//                             ),
//                           ),
//                           labelText: "Enter Name",
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Please enter your name';
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 15),
//                         CustomTextformfield(
//                           keybordType: TextInputType.phone,
//                           controller: mobileNumberController,
//                           obscureText: false,
//                           autofocus: true,
//                           focusNode: mobileFocusNode,
//                           onFieldSubmitted: (value) {
//                             FocusScope.of(context).requestFocus(emailFocusNode);
//                           },
//                           prefixIcon: const Padding(
//                             padding: EdgeInsets.all(15.0),
//                             child: FaIcon(
//                               FontAwesomeIcons.mobileScreen,
//                               size: 20,
//                               semanticLabel: "Mobile Number",
//                             ),
//                           ),
//                           labelText: "Mobile Number",
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Please enter your Mobile Number';
//                             }
//                             if (value.length != 10) {
//                               return 'Mobile Number must be of 10 digit';
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 15),
//                         CustomTextformfield(
//                           keybordType: TextInputType.emailAddress,
//                           controller: emailController,
//                           obscureText: false,
//                           autofocus: true,
//                           onFieldSubmitted: (value) {
//                             FocusScope.of(context)
//                                 .requestFocus(passwordFocusNode);
//                           },
//                           focusNode: emailFocusNode,
//                           prefixIcon: const Padding(
//                             padding: EdgeInsets.all(15.0),
//                             child: FaIcon(
//                               FontAwesomeIcons.envelope,
//                               size: 20,
//                               semanticLabel: "Email",
//                             ),
//                           ),
//                           labelText: "Email (john@gmail.com)",
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Please enter your email';
//                             }
//                             if (value.isEmpty ||
//                                 !value.contains('@') ||
//                                 !value.contains('.')) {
//                               return 'Please enter valid email';
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 15),
//                         CustomTextformfield(
//                           keybordType: TextInputType.visiblePassword,
//                           controller: passwordController,
//                           obscureText: showPasswords,
//                           autofocus: true,
//                           focusNode: passwordFocusNode,
//                           prefixIcon: const Padding(
//                             padding: EdgeInsets.all(15.0),
//                             child: FaIcon(
//                               FontAwesomeIcons.key,
//                               size: 20,
//                               semanticLabel: "Password",
//                             ),
//                           ),
//                           suffixIcon: IconButton(
//                             onPressed: toggleShowPassword,
//                             icon: showPasswords
//                                 ? const FaIcon(
//                                     FontAwesomeIcons.eyeSlash,
//                                     size: 20,
//                                     color: Colors.black,
//                                     semanticLabel: "Password",
//                                   )
//                                 : const FaIcon(
//                                     FontAwesomeIcons.eye,
//                                     size: 20,
//                                     color: Colors.black,
//                                     semanticLabel: "Password",
//                                   ),
//                           ),
//                           labelText: "Password",
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Please enter your password';
//                             }
//                             if (value.length < 8) {
//                               return 'Password should have atleast 8 characters';
//                             }
//                             if (!value.contains(RegExp(r'[A-Z]'))) {
//                               return "Password must contain at least one uppercase letter";
//                             }
//                             if (!value.contains(RegExp(r'[a-z]'))) {
//                               return "Password must contain at least one lowercase  letter";
//                             }
//                             if (!value.contains(RegExp(r'[0-9]'))) {
//                               return "Password must contain at least one numeric character";
//                             }
//                             if (!value
//                                 .contains(RegExp(r'[!@#\$%^&*()<>?/|}{~:]'))) {
//                               return "Password must contain at least one special character";
//                             }
//                             return null;
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 25),
//                   SizedBox(
//                     height: 50,
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Theme.of(context).primaryColor,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                       ),
//                       onPressed: () {
//                         if (_formKey.currentState?.validate() ?? false) {
//                           BlocProvider.of<AuthenticationBloc>(context).add(
//                             SignUpUser(
//                                 emailController.text.trim(),
//                                 passwordController.text.trim(),
//                                 nameController.text.trim(),
//                                 mobileNumberController.text.trim(),
//                                 profileImage ?? AppString.demoImgurl),
//                           );
//                           Navigator.pushAndRemoveUntil(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => const LandingPage(
//                                 startingIndex: 0,
//                               ),
//                             ),
//                             (route) => false,
//                           );
//                         }
//                       },
//                       child: AppText(
//                         text: 'Sign Up',
//                         color: AppColor.backgroundColor,
//                         size: 18,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 30),
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => BlocProvider.value(
//                             value: context.read<AuthenticationBloc>(),
//                             child: const SigninScreen(),
//                           ),
//                         ),
//                       );
//                     },
//                     child: RichText(
//                       text: TextSpan(
//                         text: 'Already have an account? ',
//                         style:
//                             const TextStyle(color: Colors.black, fontSize: 13),
//                         children: <TextSpan>[
//                           TextSpan(
//                             text: " Login",
//                             style: TextStyle(
//                                 color: Theme.of(context).primaryColor, fontSize: 14),
//                           ),
//                         ],
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:convert';

import 'package:chat_app_bloc/app_widget/app_custom_textformfield.dart';
import 'package:chat_app_bloc/app_widget/app_snackbar.dart';
import 'package:chat_app_bloc/functionality/Auth/bloc/authentication_bloc.dart';
import 'package:chat_app_bloc/functionality/Auth/bloc/authentication_event.dart';
import 'package:chat_app_bloc/functionality/Auth/bloc/authentication_state.dart';
import 'package:chat_app_bloc/functionality/Auth/view/signin_screen.dart';
import 'package:chat_app_bloc/functionality/landing_page/view/landing_page.dart';
import 'package:chat_app_bloc/utils/constent/app_color.dart';
import 'package:chat_app_bloc/utils/constent/app_font_style.dart';
import 'package:chat_app_bloc/utils/constent/app_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController nameController = TextEditingController();

  final TextEditingController mobileNumberController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final textFieldFocusNode = FocusNode();

  FocusNode nameFocusNode = FocusNode();
  FocusNode mobileFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  String? profileImage;

  bool showPasswords = true;
  bool _isLoading = false;

  void toggleShowPassword() {
    setState(() {
      showPasswords = !showPasswords;
      if (textFieldFocusNode.hasPrimaryFocus) return;
      textFieldFocusNode.canRequestFocus = false;
    });
  }

  void showModal(BuildContext context) {
    showModalBottomSheet<void>(
      isDismissible: true,
      elevation: 50,
      context: context,
      builder: (_) {
        return Container(
          height: 120,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(12)),
                      child: IconButton(
                        icon: const FaIcon(
                          FontAwesomeIcons.image,
                          color: Colors.white,
                          size: 22,
                        ),
                        onPressed: () async {
                          final image = await ImagePicker().pickImage(
                            imageQuality: 20,
                            source: ImageSource.gallery,
                          );
                          if (image != null) {
                            final imageTemp = XFile(image.path);
                            Uint8List imageBytes =
                                await imageTemp.readAsBytes();
                            String base64image = base64Encode(imageBytes);
                            setState(() {
                              profileImage = base64image;
                            });
                            context.read<AuthenticationBloc>().add(
                                  SelectProfileUrl(profileImage!),
                                );
                          }
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    const Text(
                      "Image",
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(12)),
                      child: IconButton(
                        icon: const FaIcon(
                          FontAwesomeIcons.camera,
                          color: Colors.white,
                          size: 22,
                        ),
                        onPressed: () async {
                          final image = await ImagePicker().pickImage(
                            imageQuality: 20,
                            source: ImageSource.camera,
                          );
                          if (image != null) {
                            final imageTemp = XFile(image.path);
                            Uint8List imageBytes =
                                await imageTemp.readAsBytes();
                            String base64image = base64Encode(imageBytes);
                            setState(() {
                              profileImage = base64image;
                            });
                            context.read<AuthenticationBloc>().add(
                                  SelectProfileUrl(profileImage!),
                                );
                          }
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    const Text(
                      "Camera",
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: BlocConsumer<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is AuthenticationSuccessState) {
            setState(() {
              _isLoading = false;
            });
            AppSnackbar.success(context, 'Sign Up Successful');
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const LandingPage(
                  startingIndex: 0,
                ),
              ),
              (route) => false,
            );
          } else if (state is AuthenticationFailureState) {
            setState(() {
              _isLoading = false;
            });
            AppSnackbar.error(context, state.errorMessage);
          } else if (state is AuthenticationLoadingState) {
            setState(() {
              _isLoading = true;
            });
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 50.0),
                        child: AppText(
                          text: 'Register With Simple Chats',
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          size: 22,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Image.asset(
                        "assets/images/register.jpg",
                        width: 250,
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                width: 0.6,
                                color: AppColor.blackColor.withOpacity(0.6))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            profileImage != null
                                ? Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 0.5,
                                            color: AppColor.blackColor
                                                .withOpacity(0.5)),
                                        shape: BoxShape.circle),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Image.memory(
                                        base64Decode(profileImage!),
                                        fit: BoxFit.cover,
                                        height: 80,
                                        width: 80,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(),
                                                shape: BoxShape.circle),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              child: Image.memory(
                                                base64Decode(
                                                    AppString.demoImgurl),
                                                fit: BoxFit.cover,
                                                height: 80,
                                                width: 80,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(width: 0.6),
                                        shape: BoxShape.circle),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image.memory(
                                        base64Decode(AppString.demoImgurl),
                                        fit: BoxFit.cover,
                                        height: 80,
                                        width: 80,
                                      ),
                                    ),
                                  ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: SizedBox(
                                height: 50,
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  onPressed: () {
                                    showModal(context);
                                  },
                                  child: Text(
                                    "Select Profile",
                                    style: TextStyle(
                                        color: isColorValidation(context)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      Form(
                        autovalidateMode: AutovalidateMode.always,
                        key: _formKey,
                        child: Column(
                          children: [
                            CustomTextformfield(
                              keybordType: TextInputType.name,
                              controller: nameController,
                              obscureText: false,
                              autofocus: true,
                              focusNode: nameFocusNode,
                              onFieldSubmitted: (value) {
                                FocusScope.of(context)
                                    .requestFocus(mobileFocusNode);
                              },
                              prefixIcon: const Padding(
                                padding: EdgeInsets.all(15.0),
                                child: FaIcon(
                                  FontAwesomeIcons.user,
                                  size: 20,
                                  semanticLabel: "Enter Name",
                                ),
                              ),
                              labelText: "Enter Name",
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 15),
                            CustomTextformfield(
                              keybordType: TextInputType.phone,
                              controller: mobileNumberController,
                              obscureText: false,
                              autofocus: true,
                              focusNode: mobileFocusNode,
                              onFieldSubmitted: (value) {
                                FocusScope.of(context)
                                    .requestFocus(emailFocusNode);
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(10),
                              ],
                              prefixIcon: const Padding(
                                padding: EdgeInsets.all(15.0),
                                child: FaIcon(
                                  FontAwesomeIcons.mobileScreen,
                                  size: 20,
                                  semanticLabel: "Mobile Number",
                                ),
                              ),
                              labelText: "Mobile Number",
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your Mobile Number';
                                }
                                if (value.length != 10) {
                                  return 'Mobile Number must be of 10 digit';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 15),
                            CustomTextformfield(
                              keybordType: TextInputType.emailAddress,
                              controller: emailController,
                              obscureText: false,
                              autofocus: true,
                              onFieldSubmitted: (value) {
                                FocusScope.of(context)
                                    .requestFocus(passwordFocusNode);
                              },
                              focusNode: emailFocusNode,
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
                            CustomTextformfield(
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
                                if (!value.contains(
                                    RegExp(r'[!@#\$%^&*()<>?/|}{~:]'))) {
                                  return "Password must contain at least one special character";
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),
                      SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          onPressed: _isLoading
                              ? null
                              : () {
                                  if (_formKey.currentState?.validate() ??
                                      false) {
                                    BlocProvider.of<AuthenticationBloc>(context)
                                        .add(
                                      SignUpUser(
                                          emailController.text.trim(),
                                          passwordController.text.trim(),
                                          nameController.text.trim(),
                                          mobileNumberController.text.trim(),
                                          profileImage ?? AppString.demoImgurl),
                                    );
                                  }
                                },
                          child: _isLoading
                              ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: isColorValidation(context),
                                    strokeWidth: 2,
                                  ),
                                )
                              : AppText(
                                  text: 'Sign Up',
                                  color: isColorValidation(context),
                                  size: 18,
                                ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider.value(
                                value: context.read<AuthenticationBloc>(),
                                child: const SigninScreen(),
                              ),
                            ),
                          );
                        },
                        child: RichText(
                          text: TextSpan(
                            text: 'Already have an account? ',
                            style: const TextStyle(
                                color: Colors.black, fontSize: 13),
                            children: <TextSpan>[
                              TextSpan(
                                text: "Login",
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    decoration: TextDecoration.underline,
                                    fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
              if (_isLoading)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
