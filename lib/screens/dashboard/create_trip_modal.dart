import 'package:flutter/material.dart';
import 'package:pnyws/data/data.dart';
import 'package:pnyws/widgets/form/date_form_field.dart';
import 'package:pnyws/widgets/scaled_box.dart';
import 'package:pnyws/widgets/secondary_button.dart';
import 'package:pnyws/widgets/theme_provider.dart';

const kHeroTag = 'detailsHeroTag';

class CreateTripModal extends StatefulWidget {
  const CreateTripModal({super.key});

  @override
  State<CreateTripModal> createState() => _CreateTripModalState();
}

class _CreateTripModalState extends State<CreateTripModal> {
  late final TextEditingController _titleTextController;
  late final DateEditingController _createAtTextController;

  @override
  void initState() {
    super.initState();

    _titleTextController = TextEditingController();
    _createAtTextController = DateEditingController(DateTime.now());
  }

  @override
  void dispose() {
    _titleTextController.dispose();
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
              decoration: const InputDecoration(hintText: 'e.g Lagos Get Away'),
              textInputAction: TextInputAction.done,
              autocorrect: true,
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              textAlign: .center,
              style: ThemeProvider.of(context).textfield,
            ),
            const ScaledBox.vertical(16),
            DateFormField(
              controller: _createAtTextController,
              decoration: const InputDecoration(hintText: 'Entry date'),
              textAlign: .center,
            ),
            const ScaledBox.vertical(16),
            Hero(
              tag: kHeroTag,
              child: SecondaryButton(
                child: const Text('DONE'),
                onPressed: () {
                  final trip = TripData(title: _titleTextController.text, createdAt: _createAtTextController.value);

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
