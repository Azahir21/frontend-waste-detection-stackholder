import 'package:flutter/material.dart';
import 'package:frontend_waste_management_stackholder/core/theme/theme_data.dart';

class CustomForm extends StatefulWidget {
  const CustomForm({
    Key? key,
    required this.labelText,
    required this.isPassword,
    required this.obscureText,
    required this.onChanged,
    required this.keyboardType,
    required this.width,
    required this.height,
    this.autofillHints,
    this.onFieldSubmitted,
  }) : super(key: key);

  final String labelText;
  final bool isPassword;
  final bool obscureText;
  final ValueSetter<String> onChanged;
  final TextInputType keyboardType;
  final double width;
  final double height;
  final List<String>? autofillHints;
  final ValueChanged<String>? onFieldSubmitted;

  factory CustomForm.text({
    Key? key,
    required String labelText,
    required ValueSetter<String> onChanged,
    TextInputType keyboardType = TextInputType.text,
    double width = 350,
    double height = 70,
  }) {
    return CustomForm(
      key: key,
      labelText: labelText,
      isPassword: false,
      obscureText: false,
      onChanged: onChanged,
      keyboardType: keyboardType,
      width: width,
      height: height,
    );
  }

  factory CustomForm.phone({
    Key? key,
    required String labelText,
    required ValueSetter<String> onChanged,
    TextInputType keyboardType = TextInputType.phone,
    double width = 350,
    double height = 70,
  }) {
    return CustomForm(
      key: key,
      labelText: labelText,
      isPassword: false,
      obscureText: false,
      onChanged: onChanged,
      keyboardType: keyboardType,
      width: width,
      height: height,
    );
  }

  factory CustomForm.number({
    Key? key,
    required String labelText,
    required ValueSetter<String> onChanged,
    TextInputType keyboardType = TextInputType.number,
    double width = 350,
    double height = 70,
  }) {
    return CustomForm(
      key: key,
      labelText: labelText,
      isPassword: false,
      obscureText: false,
      onChanged: onChanged,
      keyboardType: keyboardType,
      width: width,
      height: height,
    );
  }

  factory CustomForm.email({
    Key? key,
    required String labelText,
    required ValueSetter<String> onChanged,
    double width = 350,
    double height = 70,
  }) {
    return CustomForm(
      key: key,
      labelText: labelText,
      isPassword: false,
      obscureText: false,
      onChanged: onChanged,
      keyboardType: TextInputType.emailAddress,
      width: width,
      height: height,
      autofillHints: const [AutofillHints.email],
    );
  }

  factory CustomForm.password({
    Key? key,
    required String labelText,
    required ValueSetter<String> onChanged,
    bool obscureText = true,
    double width = 350,
    double height = 70,
    ValueChanged<String>? onFieldSubmitted,
  }) {
    return CustomForm(
      key: key,
      labelText: labelText,
      isPassword: true,
      obscureText: obscureText,
      onChanged: onChanged,
      keyboardType: TextInputType.text,
      width: width,
      height: height,
      autofillHints: const [AutofillHints.password],
      onFieldSubmitted: onFieldSubmitted,
    );
  }

  @override
  _CustomFormState createState() => _CustomFormState();
}

class _CustomFormState extends State<CustomForm> {
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).appColors;

    return Form(
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: TextFormField(
          focusNode: _focusNode,
          obscureText: widget.isPassword && widget.obscureText,
          cursorColor: Colors.blue,
          style: TextStyle(
            color: color.textSecondary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          autofillHints: widget.autofillHints,
          onFieldSubmitted: widget.onFieldSubmitted,
          decoration: InputDecoration(
            fillColor: color.formFieldBorder,
            labelText: widget.labelText,
            labelStyle: TextStyle(
              color: color.textSecondary,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: color.formFieldBorder,
                width: 3, // Thicker border
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: color.formFieldBorder,
                width: 3, // Thicker border when focused
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                width: 3,
                color: Colors.red,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: color.formFieldBorder,
                width: 3, // Thicker border when enabled
              ),
            ),
          ),
          keyboardType: widget.keyboardType,
          onChanged: widget.onChanged,
        ),
      ),
    );
  }
}
