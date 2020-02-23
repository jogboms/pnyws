import 'package:flutter/material.dart';
import 'package:pnyws/constants/mk_colors.dart';
import 'package:pnyws/constants/mk_style.dart';
import 'package:pnyws/models/primitives/expense_data.dart';
import 'package:pnyws/widgets/scaled_box.dart';
import 'package:pnyws/widgets/theme_provider.dart';

class ExpenseListItem extends StatelessWidget {
  const ExpenseListItem({
    Key key,
    @required this.item,
  }) : super(key: key);

  final ExpenseData item;

  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider.of(context);
    final createdAt = item.createdAt;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      margin: EdgeInsets.symmetric(vertical: .125),
      color: MkColors.primaryAccent.shade500.withOpacity(.025),
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
            "\$${item.value.toStringAsFixed(2)}",
            style: theme.subhead1Bold.copyWith(letterSpacing: 1.05),
          ),
        ],
      ),
    );
  }
}
