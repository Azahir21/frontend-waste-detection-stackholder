import 'package:flutter/material.dart';
import 'package:frontend_waste_management_stackholder/core/theme/theme_data.dart';

class CustomDropdown extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final List<String> dropDownItems;
  final ValueSetter<String> onChanged;
  final double width;
  final double height;
  final String? initialValue;

  const CustomDropdown({
    Key? key,
    this.labelText,
    this.hintText,
    required this.dropDownItems,
    required this.onChanged,
    required this.width,
    required this.height,
    this.initialValue,
  }) : super(key: key);

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
    if (_selectedValue != null &&
        !widget.dropDownItems.contains(_selectedValue)) {
      _selectedValue =
          widget.dropDownItems.isNotEmpty ? widget.dropDownItems.first : null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).appColors;

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: DropdownButtonFormField<String>(
        value: _selectedValue,
        decoration: InputDecoration(
          fillColor: color.formFieldBorder,
          labelText: widget.labelText,
          hintText: widget.hintText,
          labelStyle: TextStyle(
            color: color.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: color.formFieldBorder,
              width: 3,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: color.formFieldBorder,
              width: 3,
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
              width: 3,
            ),
          ),
        ),
        items: widget.dropDownItems.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            setState(() {
              _selectedValue = value;
            });
            widget.onChanged(value);
          }
        },
      ),
    );
  }
}
