import 'package:flutter/material.dart';
import 'package:pnyws/data/data.dart';
import 'package:pnyws/widgets/form/date_form_field.dart';
import 'package:pnyws/widgets/scaled_box.dart';
import 'package:pnyws/widgets/secondary_button.dart';
import 'package:pnyws/widgets/theme_provider.dart';

const kHeroTag = 'detailsHeroTag';

class CreateExpenseModal extends StatefulWidget {
  const CreateExpenseModal({super.key});

  @override
  State<CreateExpenseModal> createState() => _CreateExpenseModalState();
}

class _CreateExpenseModalState extends State<CreateExpenseModal> {
  late final FocusNode _moneyTextNode;
  late final TextEditingController _titleTextController;
  late final TextEditingController _moneyTextController;
  late final DateEditingController _createAtTextController;

  @override
  void initState() {
    super.initState();

    _moneyTextNode = FocusNode();
    _titleTextController = TextEditingController();
    _moneyTextController = TextEditingController();
    _createAtTextController = DateEditingController(DateTime.now());
  }

  @override
  void dispose() {
    _moneyTextNode.dispose();
    _titleTextController.dispose();
    _moneyTextController.dispose();
    _createAtTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Center(
    child: Material(
      child: Padding(
        padding: const .symmetric(horizontal: 48.0),
        child: Column(
          mainAxisSize: .min,
          children: [
            const ScaledBox.vertical(24),
            TextField(
              controller: _titleTextController,
              decoration: const InputDecoration(hintText: 'e.g Red Suya'),
              autocorrect: true,
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              onEditingComplete: () => FocusScope.of(context).requestFocus(_moneyTextNode),
              textAlign: .center,
              style: ThemeProvider.of(context).textfield,
            ),
            const ScaledBox.vertical(16),
            TextField(
              focusNode: _moneyTextNode,
              controller: _moneyTextController,
              decoration: const InputDecoration(hintText: 'e.g 1000'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              textAlign: .center,
              style: ThemeProvider.of(context).textfield,
            ),
            const ScaledBox.vertical(16),
            DateFormField(
              controller: _createAtTextController,
              initialValue: DateTime.now(),
              decoration: const InputDecoration(hintText: 'Entry date'),
              textAlign: .center,
            ),
            const ScaledBox.vertical(16),
            Hero(
              tag: kHeroTag,
              child: SecondaryButton(
                child: const Text('DONE'),
                onPressed: () {
                  final expense = ExpenseData(
                    title: _titleTextController.text,
                    value: double.tryParse(_moneyTextController.text) ?? 0.0,
                    createdAt: _createAtTextController.value,
                  );

                  if (expense.isValid) {
                    Navigator.pop(context, expense);
                  }
                },
              ),
            ),
            const ScaledBox.vertical(24),
          ],
        ),
      ),
    ),
  );
}
