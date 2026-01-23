import 'package:flutter/material.dart';
import 'package:pnyws/mixins/dismiss_keyboard_mixin.dart';
import 'package:pnyws/widgets/theme_provider.dart';

class FakeTextFormField<T> extends StatefulWidget {
  const FakeTextFormField({
    super.key,
    required this.onTap,
    this.initialValue,
    this.child,
    this.decoration = const InputDecoration(),
    this.autovalidateMode = .disabled,
    this.onSaved,
    this.textAlign,
    this.validator,
  });

  final FormFieldSetter<T>? onSaved;
  final FormFieldValidator<T>? validator;
  final ValueChanged<FormFieldState<T>>? onTap;
  final T? initialValue;
  final Widget? child;
  final TextAlign? textAlign;
  final InputDecoration decoration;
  final AutovalidateMode autovalidateMode;

  @override
  FakeTextFormFieldState<T> createState() => FakeTextFormFieldState<T>();
}

class FakeTextFormFieldState<T> extends State<FakeTextFormField<T>> with DismissKeyboardMixin {
  bool get isEnabled => widget.onTap != null;

  @override
  Widget build(BuildContext context) => FormField<T>(
    initialValue: widget.initialValue,
    autovalidateMode: widget.autovalidateMode,
    builder: (FormFieldState<T> field) => InkWell(
      onTap: isEnabled ? _onTap(field) : null,
      child: InputDecorator(
        textAlign: widget.textAlign,
        decoration: widget.decoration,
        child: DefaultTextStyle(
          style: _buildTextStyle(field.value, context.theme),
          textAlign: widget.textAlign,
          child: widget.child ?? Text(_buildTextContent(field.value) ?? '<empty'),
        ),
      ),
    ),
    validator: widget.validator,
    onSaved: widget.onSaved,
  );

  VoidCallback _onTap(FormFieldState<T> field) => () {
    closeKeyboard();
    widget.onTap?.call(field);
  };

  TextStyle _buildTextStyle(T? value, ThemeProvider theme) {
    if (!isEnabled) {
      return theme.textfieldLabel.copyWith(height: 1.5);
    }

    if ((value != null && value is! List && value is! String) ||
        (value is List && value.isNotEmpty) ||
        (value is String && value.isNotEmpty)) {
      return theme.textfield.copyWith(height: 1.5);
    }

    return theme.textfieldLabel.copyWith(height: 1.5);
  }

  String? _buildTextContent(T? value) {
    if (value == null) {
      return widget.decoration.hintText;
    }
    if (value is List) {
      return value.isNotEmpty ? 'Successfully Added!' : widget.decoration.hintText;
    }
    if (value is String) {
      return value.isNotEmpty ? value.toString() : widget.decoration.hintText;
    }
    return value.toString();
  }
}
