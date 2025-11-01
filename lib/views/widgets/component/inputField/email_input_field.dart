import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:form_validator/form_validator.dart';
import '../../../../utils/constant_widget.dart';
import '../../../../utils/typography.dart';


class EmailInputField extends StatelessWidget {
  final String name;
  final String? title;
  final String? hintText;
  final StringValidationCallback? validator;

  const EmailInputField({
    Key? key,
    required this.name,
    this.title,
    this.hintText,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title!,
          style: onBoardSixteenStyle,
        ),
        const SizedBox(
          height: 12,
        ),
        FormBuilderTextField(
          name: name,
          autofocus: false,
          style: onBoardSixteenStyle,
          keyboardType: TextInputType.emailAddress,
          cursorColor: Colors.white70,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.transparent,
            contentPadding: const EdgeInsets.all(16),
            hintText: 'globalnews@gmail.com',
            hintStyle: onBoardFourteenStyle,
            errorStyle: onBoardFourteenStyle,
            prefixIcon: const Icon(Icons.email_outlined,color: Colors.black,),
            focusedBorder: inputFieldBorder,
            enabledBorder: inputFieldBorder,
            focusColor: Colors.white,
          ),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(),
            FormBuilderValidators.email(),
          ]),
        ),
      ],
    );
  }
}
