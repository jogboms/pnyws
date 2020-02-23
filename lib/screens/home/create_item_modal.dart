import 'package:flutter/material.dart';
import 'package:pnyws/constants/mk_colors.dart';
import 'package:pnyws/models/primitives/expense_data.dart';
import 'package:pnyws/screens/home/date_form_field.dart';
import 'package:pnyws/widgets/scaled_box.dart';
import 'package:pnyws/widgets/theme_provider.dart';

const kHeroTag = "detailsHeroTag";

class CreateItemModal extends StatefulWidget {
  @override
  _CreateItemModalState createState() => _CreateItemModalState();
}

class _CreateItemModalState extends State<CreateItemModal> {
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
        color: MkColors.primaryAccent,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const ScaledBox.vertical(16),
              TextField(
                controller: titleTextController,
                decoration: InputDecoration(hintText: "e.g Red Suya"),
                textInputAction: TextInputAction.next,
                onEditingComplete: () => FocusScope.of(context).requestFocus(moneyTextNode),
                textAlign: TextAlign.center,
              ),
              const ScaledBox.vertical(8),
              TextField(
                focusNode: moneyTextNode,
                controller: moneyTextController,
                decoration: InputDecoration(hintText: "e.g 1000"),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                textAlign: TextAlign.center,
              ),
              const ScaledBox.vertical(8),
              DateFormField(
                controller: createAtTextController,
                decoration: InputDecoration(hintText: "Entry date"),
                textAlign: TextAlign.center,
              ),
              const ScaledBox.vertical(8),
              Hero(
                tag: kHeroTag,
                child: RawMaterialButton(
                  constraints: BoxConstraints(minHeight: 0),
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 18),
                  shape: StadiumBorder(),
                  fillColor: MkColors.secondaryAccent,
                  child: Text("DONE", style: ThemeProvider.of(context).button),
                  onPressed: () {
                    Navigator.pop(
                      context,
                      ExpenseData(
                        title: titleTextController.text,
                        value: double.tryParse(moneyTextController.text),
                        createdAt: createAtTextController.value,
                      ),
                    );
                  },
                ),
              ),
              const ScaledBox.vertical(16),
            ],
          ),
        ),
      ),
    );
  }
}
