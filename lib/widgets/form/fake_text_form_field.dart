import 'package:flutter/material.dart';
import 'package:pnyws/mixins/dismiss_keyboard_mixin.dart';
import 'package:pnyws/widgets/theme_provider.dart';

class FakeTextFormField<T> extends StatefulWidget {
  const FakeTextFormField({
    Key key,
    @required this.onTap,
    this.initialValue,
    this.child,
    this.decoration = const InputDecoration(),
    this.autovalidate = false,
    this.onSaved,
    this.textAlign,
    this.validator,
  }) : super(key: key);

  final FormFieldSetter<T> onSaved;
  final FormFieldValidator<T> validator;
  final ValueChanged<FormFieldState<T>> onTap;
  final T initialValue;
  final Widget child;
  final TextAlign textAlign;
  final InputDecoration decoration;
  final bool autovalidate;

  @override
  FakeTextFormFieldState<T> createState() => FakeTextFormFieldState<T>();
}

class FakeTextFormFieldState<T> extends State<FakeTextFormField<T>> with DismissKeyboardMixin {
  bool get isEnabled => widget.onTap != null;

  @override
  Widget build(BuildContext context) {
    final _theme = ThemeProvider.of(context);
    return FormField<T>(
      initialValue: widget.initialValue != null ? widget.initialValue : null,
      autovalidate: widget.autovalidate,
      builder: (FormFieldState<T> field) => InkWell(
        onTap: isEnabled ? _onTap(field) : null,
        child: InputDecorator(
          textAlign: widget.textAlign,
          decoration: widget.decoration,
          child: DefaultTextStyle(
            style: _buildTextStyle(field.value, _theme),
            child: widget.child ?? Text(_buildTextContent(field.value)),
            textAlign: widget.textAlign,
          ),
        ),
      ),
      validator: widget.validator,
      onSaved: widget.onSaved,
    );
  }

  VoidCallback _onTap(FormFieldState<T> field) {
    return () {
      closeKeyboard();
      widget.onTap(field);
    };
  }

  TextStyle _buildTextStyle(T value, ThemeProvider theme) {
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

  String _buildTextContent(T value) {
    if (value == null) {
      return widget.decoration.hintText;
    }
    if (value is List) {
      return value.isNotEmpty ? "Successfully Added!" : widget.decoration.hintText;
    }
    if (value is String) {
      return value.isNotEmpty ? value.toString() : widget.decoration.hintText;
    }
    return value.toString();
  }
}
