import 'package:flutter/material.dart';
import 'package:pnyws/models/primitives/expense_data.dart';
import 'package:pnyws/widgets/form/date_form_field.dart';
import 'package:pnyws/widgets/scaled_box.dart';
import 'package:pnyws/widgets/secondary_button.dart';
import 'package:pnyws/widgets/theme_provider.dart';

const kHeroTag = "detailsHeroTag";

class CreateExpenseModal extends StatefulWidget {
  @override
  _CreateExpenseModalState createState() => _CreateExpenseModalState();
}

class _CreateExpenseModalState extends State<CreateExpenseModal> {
  TextEditingController titleTextController;
  FocusNode moneyTextNode;
  TextEditingController moneyTextController;
  DateEditingController createAtTextController;

  @override
  void initState() {
    super.initState();

    moneyTextNode = FocusNode();
    titleTextController = TextEditingController();
    moneyTextController = TextEditingController();
    createAtTextController = DateEditingController(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const ScaledBox.vertical(24),
              TextField(
                controller: titleTextController,
                decoration: InputDecoration(hintText: "e.g Red Suya"),
                autocorrect: true,
                autofocus: true,
                enableSuggestions: true,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                onEditingComplete: () => FocusScope.of(context).requestFocus(moneyTextNode),
                textAlign: TextAlign.center,
                style: ThemeProvider.of(context).textfield,
              ),
              const ScaledBox.vertical(16),
              TextField(
                focusNode: moneyTextNode,
                controller: moneyTextController,
                decoration: InputDecoration(hintText: "e.g 1000"),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                textAlign: TextAlign.center,
                style: ThemeProvider.of(context).textfield,
              ),
              const ScaledBox.vertical(16),
              DateFormField(
                controller: createAtTextController,
                decoration: InputDecoration(hintText: "Entry date"),
                textAlign: TextAlign.center,
              ),
              const ScaledBox.vertical(16),
              Hero(
                tag: kHeroTag,
                child: SecondaryButton(
                  child: Text("DONE"),
                  onPressed: () {
                    final expense = ExpenseData(
                      title: titleTextController.text,
                      value: double.tryParse(moneyTextController.text) ?? 0.0,
                      createdAt: createAtTextController.value,
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
}
