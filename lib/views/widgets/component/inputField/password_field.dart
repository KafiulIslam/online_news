import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:form_validator/form_validator.dart';
import '../../../../utils/color.dart';
import '../../../../utils/constant_widget.dart';
import '../../../../utils/typography.dart';


class PasswordInputField extends StatefulWidget {
  final String name;
  final String? title;
  final String? hintText;
  final StringValidationCallback? validator;
  final bool isSignUpForm;

  const PasswordInputField(
      {Key? key, required this.name, this.title,  this.hintText, this.validator, this.isSignUpForm = false})
      : super(key: key);

  @override
  State<PasswordInputField> createState() => _PasswordInputFieldState();
}

class _PasswordInputFieldState extends State<PasswordInputField> {

  late bool _isPassObscure = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title!,
          style: widget.isSignUpForm == true ? sixteenBlackStyle : onBoardSixteenStyle,
        ),
        const SizedBox(
          height: 12,
        ),
        FormBuilderTextField(
          name: widget.name ,
          obscureText: _isPassObscure,
          style: widget.isSignUpForm == true ? sixteenBlackStyle : onBoardSixteenStyle,
          autocorrect: false,
          cursorColor: widget.isSignUpForm == true ? red :Colors.white70,
          decoration: InputDecoration(
            filled: true,
            fillColor: widget.isSignUpForm == true ? white : trans,
            contentPadding: const EdgeInsets.all(16),
            hintText: widget.hintText,
            hintStyle: widget.isSignUpForm == true ? fourteenDeepAssStyle : onBoardFourteenStyle,
            errorStyle: widget.isSignUpForm == true ? fourteenRedStyle : onBoardFourteenStyle,
            prefixIcon: Icon(Icons.lock,color: widget.isSignUpForm == true ? iconColor : Colors.white54),
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  _isPassObscure = !_isPassObscure;
                  var index = 0;
                  if (!_isPassObscure) {
                    index = 1;
                  }
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                    child: _isPassObscure
                        ? Icon(Icons.visibility_off,color: widget.isSignUpForm == true ? iconColor : Colors.white54,)
                        : Icon(Icons.visibility,color: widget.isSignUpForm == true ? iconColor :Colors.white54,)),
              ),
            ),
            focusedBorder: widget.isSignUpForm == true ? OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const  BorderSide(color: borderColor,),
            ) : inputFieldBorder,
            enabledBorder:  widget.isSignUpForm == true ? OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const  BorderSide(color: borderColor,),
            ) : inputFieldBorder,
            focusColor: Theme.of(context).primaryColor,
          ),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(),
          ]),
        ),
      ],
    );
  }
}
