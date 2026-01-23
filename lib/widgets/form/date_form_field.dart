import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:pnyws/widgets/form/fake_text_form_field.dart';

class DateEditingController extends ValueNotifier<DateTime?> {
  DateEditingController([super.value]);
}

class DateFormField extends StatefulWidget {
  const DateFormField({
    super.key,
    this.controller,
    this.initialValue,
    this.onChanged,
    this.onSaved,
    this.autovalidateMode = false,
    this.decoration = const InputDecoration(),
    this.validator,
    this.textAlign,
  });

  final DateEditingController? controller;
  final DateTime? initialValue;
  final ValueChanged<DateTime?>? onChanged;
  final ValueChanged<DateTime?>? onSaved;
  final FormFieldValidator<DateTime?>? validator;
  final TextAlign? textAlign;
  final InputDecoration decoration;
  final bool autovalidateMode;

  @override
  DateFormFieldState createState() => DateFormFieldState();
}

class DateFormFieldState extends State<DateFormField> {
  DateTime? _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) => FakeTextFormField<DateTime?>(
    initialValue: _value,
    validator: widget.validator,
    decoration: widget.decoration,
    textAlign: widget.textAlign,
    onTap: showPicker(),
    onSaved: widget.onSaved,
    child: Builder(
      builder: (context) {
        final value = _value;
        if (value == null) {
          return Text(widget.decoration.hintText ?? 'Select a date');
        }

        return Text(DateFormat.yMMMd().format(value));
      },
    ),
  );

  ValueChanged<FormFieldState<DateTime?>> showPicker() => (FormFieldState<DateTime?> field) async {
    final value = await showDatePicker(
      context: context,
      initialDate: _value ?? DateTime.now(),
      firstDate: DateTime(1900, 8),
      lastDate: DateTime(2101),
    );

    if (value == null || value == _value) {
      return;
    }

    setState(() {
      _value = value;
      field.didChange(value);
      widget.controller?.value = value;
      widget.onChanged?.call(value);
    });
  };
}
