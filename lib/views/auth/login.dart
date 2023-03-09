import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:online_news_app/utils/color.dart';
import 'package:online_news_app/utils/image_path.dart';
import 'package:online_news_app/views/home/home.dart';
import '../../utils/constant_widget.dart';
import '../../utils/spacer.dart';
import '../../utils/typography.dart';
import '../widgets/component/buttons/onboard_button.dart';
import '../widgets/component/inputField/email_input_field.dart';
import '../widgets/component/inputField/password_field.dart';
import '../widgets/custom_snack.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {

  final _formKey = GlobalKey<FormBuilderState>();
  late bool _isLoading = false;
  late String accessKey = '';
  late int onBoardCardIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Image.asset(appLogo, height: 140,width: 160,),
              SizedBox(height: MediaQuery.of(context).size.height / 20,),
              onBoardCardIndex == 0
                  ? _loginCard(context)
                  : onBoardCardIndex == 1
                  ? _forgotPassCard(context)
                  : _createAccountCard(context),
            ],),
          ),
        ),
      ),
    );
  }

  Widget _loginCard(BuildContext context) {
    return _onBoardCard(context, [
      const EmailInputField(
        name: 'login_mail',
        title: 'Email',
        hintText: 'sophia@gmail.com',
      ),
      primaryVerticalSpacer,
      const PasswordInputField(
        name: 'login_pass',
        title: 'Password',
        hintText: 'Password',
      ),
      primaryVerticalSpacer,
      _buildForgotPassword(context),
      primaryVerticalSpacer,
      OnBoardTextButton(
        title: 'LogIn',
        onPressed: () async {
          try {
            if (_formKey.currentState?.saveAndValidate() ?? false) {
              if (!_isLoading) {
                setState(() {
                  _isLoading = true;
                });
                final authResult = await FirebaseAuth.instance
                    .signInWithEmailAndPassword(
                    email: _formKey.currentState?.value['login_mail'],
                    password: _formKey.currentState?.value['login_pass']);
                await secureStorage.write(
                    key: 'user_id', value: authResult.user?.uid);

                Get.off(()=> const Home());
              }
            }
          } catch (e) {
            _formKey.currentState?.reset();
            CustomSnack.warningSnack(e.toString());
          } finally {
            setState(() {
              _isLoading = false;
            });
          }
        },
        isLoading: _isLoading,
      ),
    ]);
  }

  Widget _forgotPassCard(BuildContext context) {
    return _onBoardCard(context, [
      const Text(
        'Enter your email below to receive password reset instruction',
        style: onBoardFourteenStyle,
      ),
      primaryVerticalSpacer,
      const EmailInputField(
        name: 'reset_pass_email',
        title: 'Email',
        hintText: 'sophia@gmail.com',
      ),
      primaryVerticalSpacer,
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
              onPressed: () {
                setState(() {
                  onBoardCardIndex = 0;
                });
                // Get.to(() => const ForgotPassword());
              },
              child: const Text(
                'Back to Login',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  fontFamily: 'Bangla',
                  color: Colors.white70,
                  letterSpacing: 1,
                  decoration: TextDecoration.underline,
                ),
              )),
          Container(
            height: 5,
            width: 5,
          ),
        ],
      ),
      OnBoardTextButton(
        title: 'Submit',
        onPressed: () async {
          await FirebaseAuth.instance
              .sendPasswordResetEmail(
              email: _formKey.currentState?.value['reset_pass_email'])
              .then((value) {
            CustomSnack.successSnack(
                'Check your mail"${_formKey.currentState?.value['reset_pass_email']}" and reset your password.');
            setState(() {
              onBoardCardIndex = 0;
            });
          }).onError((error, stackTrace) {
            CustomSnack.warningSnack(error.toString());
          });
        },
        isLoading: _isLoading,
      ),
    ]);
  }

  Widget _createAccountCard(BuildContext context) {
    return _onBoardCard(context, [
      const EmailInputField(
        name: 'signup_mail',
        title: 'Email',
        hintText: 'sophia@gmail.com',
      ),
      primaryVerticalSpacer,
      const PasswordInputField(
        name: 'signup_pass',
        title: 'Password',
        hintText: 'Password',
      ),
      primaryVerticalSpacer,
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
              onPressed: () {
                setState(() {
                  onBoardCardIndex = 0;
                });
                // Get.to(() => const ForgotPassword());
              },
              child: const Text(
                'Back to Login',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.white70,
                  letterSpacing: 1,
                  decoration: TextDecoration.underline,
                ),
              )),
          Container(
            height: 5,
            width: 5,
          ),
        ],
      ),
      OnBoardTextButton(
        title: 'Sign Up',
        onPressed: () async {

          var userId = await secureStorage.read(key: 'user_id');
          if (userId == null) {
            try {
              setState(() {
                _isLoading = true;
              });
              final authResult = await FirebaseAuth.instance
                  .createUserWithEmailAndPassword(
                  email: _formKey.currentState?.value['signup_mail'],
                  password: _formKey.currentState?.value['signup_pass']);
              await secureStorage.write(
                  key: 'user_id', value: authResult.user?.uid);
              var userId = await secureStorage.read(key: 'user_id');

              Get.off(()=> const Home());

            } catch (e) {
              CustomSnack.warningSnack(e.toString());
            } finally {
              setState(() {
                _isLoading = false;
              });
            }
          } else {
            CustomSnack.warningSnack(
                "Warning!','You are logged in, to create new account log out first.");
          }
        },
        isLoading: _isLoading,
      )
    ]);
  }

  Widget _buildForgotPassword(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
            onPressed: () {
              setState(() {
                onBoardCardIndex = 1;
              });
            },
            child: const Text(
              'Forgot Password?',
              style: onBoardFourteenStyle,
            )),
        TextButton(
            onPressed: () {
              setState(() {
                onBoardCardIndex = 2;
              });
            },
            child: const Text(
              'Create Account',
              style: onBoardSixteenStyle,
            )),
      ],
    );
  }

  Widget _onBoardCard(BuildContext context, List<Widget> children) {
    return FormBuilder(
      key: _formKey,
      enabled: !_isLoading,
      autovalidateMode: AutovalidateMode.disabled,
      onChanged: () {
        _formKey.currentState!.save();
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 1.1,
        height: 360,
        child: Card( shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),color: black, child:  Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: children,
            ),
          ),
         ),),
      )
      // GlassmorphicContainer(
      //   width: MediaQuery.of(context).size.width / 1.1,
      //   height: 360,
      //   borderRadius: 20,
      //   blur: 50,
      //   alignment: Alignment.bottomCenter,
      //   border: 2,
      //   linearGradient: LinearGradient(
      //       begin: Alignment.topCenter,
      //       end: Alignment.bottomCenter,
      //       colors: [
      //         const Color(0xFFffffff).withOpacity(0.15),
      //         const Color(0xFFFFFFFF).withOpacity(0.1),
      //       ],
      //       stops: const [
      //         0.1,
      //         1,
      //       ]),
      //   borderGradient: LinearGradient(
      //     begin: Alignment.topCenter,
      //     end: Alignment.bottomCenter,
      //     colors: [
      //       trans,
      //       Colors.white.withOpacity(0.2),
      //     ],
      //   ),
      //   child: Padding(
      //     padding: const EdgeInsets.all(16.0),
      //     child: SingleChildScrollView(
      //       child: Column(
      //         children: children,
      //       ),
      //     ),
      //   ),
      // ),
    );
  }

}
