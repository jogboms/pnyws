import 'package:flutter/material.dart';
import 'package:pnyws/constants/mk_colors.dart';
import 'package:pnyws/models/primitives/trip_data.dart';
import 'package:pnyws/widgets/form/date_form_field.dart';
import 'package:pnyws/widgets/scaled_box.dart';
import 'package:pnyws/widgets/secondary_button.dart';

const kHeroTag = "detailsHeroTag";

class CreateTripModal extends StatefulWidget {
  @override
  _CreateTripModalState createState() => _CreateTripModalState();
}

class _CreateTripModalState extends State<CreateTripModal> {
  TextEditingController titleTextController;
  DateEditingController createAtTextController;

  @override
  void initState() {
    super.initState();

    titleTextController = TextEditingController();
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
                decoration: InputDecoration(hintText: "e.g Lagos Get Away"),
                textInputAction: TextInputAction.done,
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
                child: SecondaryButton(
                  child: Text("DONE"),
                  onPressed: () {
                    Navigator.pop(
                      context,
                      TripData(
                        title: titleTextController.text,
                        items: [],
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
