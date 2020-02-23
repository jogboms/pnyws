import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pnyws/constants/mk_colors.dart';
import 'package:pnyws/constants/mk_style.dart';
import 'package:pnyws/models/primitives/trip_data.dart';
import 'package:pnyws/registry.dart';
import 'package:pnyws/widgets/scaled_box.dart';
import 'package:pnyws/widgets/theme_provider.dart';

class TripListItem extends StatelessWidget {
  const TripListItem({
    Key key,
    @required this.item,
  }) : super(key: key);

  final TripData item;

  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider.of(context);
    final createdAt = item.createdAt;
    final totalAmount = item.items.fold<double>(0.0, (a, b) => a + b.value);

    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: InkWell(
        onTap: () {
          Registry.di().repository.trip.setActiveTrip(item);
          Navigator.pop(context);
        },
        child: Ink(
          padding: EdgeInsets.symmetric(vertical: .125),
          decoration: BoxDecoration(color: MkColors.primaryAccent.shade500.withOpacity(.025)),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        item.title,
                        style: theme.subhead3Semi.copyWith(letterSpacing: 0.125),
                      ),
                      const ScaledBox.vertical(4),
                      Text(
                        '${createdAt.day}.${createdAt.month}.${createdAt.year.toString().substring(2)}',
                        style: theme.body1.copyWith(
                          letterSpacing: 0.125,
                          color: kTextBaseColor.withOpacity(.75),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  "\$${totalAmount.toStringAsFixed(2)}",
                  style: theme.subhead1Bold.copyWith(letterSpacing: 1.05),
                ),
              ],
            ),
          ),
        ),
      ),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => Registry.di().repository.trip.removeTrip(item),
        ),
      ],
    );
  }
}
