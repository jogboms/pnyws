import 'package:flutter/material.dart';
import 'package:pnyws/models/primitives/trip_data.dart';
import 'package:pnyws/widgets/form/date_form_field.dart';
import 'package:pnyws/widgets/scaled_box.dart';
import 'package:pnyws/widgets/secondary_button.dart';
import 'package:pnyws/widgets/theme_provider.dart';

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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const ScaledBox.vertical(24),
              TextField(
                controller: titleTextController,
                decoration: InputDecoration(hintText: "e.g Lagos Get Away"),
                textInputAction: TextInputAction.done,
                autocorrect: true,
                autofocus: true,
                enableSuggestions: true,
                textCapitalization: TextCapitalization.words,
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
                    final trip = TripData(title: titleTextController.text, createdAt: createAtTextController.value);

                    if (trip.isValid) {
                      Navigator.pop(context, trip);
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
