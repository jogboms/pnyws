import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pnyws/constants/mk_colors.dart';
import 'package:pnyws/constants/mk_style.dart';
import 'package:pnyws/data/data.dart';
import 'package:pnyws/registry.dart';
import 'package:pnyws/utils/money.dart';
import 'package:pnyws/widgets/scaled_box.dart';
import 'package:pnyws/widgets/theme_provider.dart';

class TripListItem extends StatelessWidget {
  const TripListItem({
    Key key,
    @required this.item,
    @required this.isActive,
  }) : super(key: key);

  final TripData item;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider.of(context);
    final createdAt = item.createdAt;
    final totalAmount = item.items.fold<double>(0.0, (a, b) => a + b.value);

    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: InkWell(
        onTap: isActive
            ? null
            : () {
                Registry.di().repository.trip.setActiveTrip(item);
                Navigator.pop(context);
              },
        child: Ink(
          padding: EdgeInsets.symmetric(vertical: .125),
          decoration: BoxDecoration(color: MkColors.primaryAccent.shade500.withOpacity(.025)),
          child: Padding(
            padding: EdgeInsets.fromLTRB(8, 16, 24, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: isActive ? MkColors.secondaryAccent : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  width: 8,
                  height: 8,
                ),
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
                  Money(totalAmount).formatted,
                  style: theme.subhead1Bold.copyWith(letterSpacing: 1.05),
                ),
              ],
            ),
          ),
        ),
      ),
      secondaryActions: <Widget>[
        if (!isActive)
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
