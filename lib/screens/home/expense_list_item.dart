import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pnyws/constants/mk_colors.dart';
import 'package:pnyws/data/data.dart';
import 'package:pnyws/utils/utils.dart';
import 'package:pnyws/widgets/scaled_box.dart';
import 'package:pnyws/widgets/theme_provider.dart';

class ExpenseListItem extends StatelessWidget {
  const ExpenseListItem({super.key, required this.item, required this.onDeleteAction});

  final ExpenseData item;
  final ValueChanged<ExpenseData> onDeleteAction;

  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider.of(context);
    final createdAt = item.createdAt;

    return Slidable(
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.25,
        children: [
          SlidableAction(
            label: 'Delete',
            backgroundColor: Colors.red,
            icon: Icons.delete,
            onPressed: (_) => onDeleteAction(item),
          ),
        ],
      ),
      child: Container(
        padding: const .symmetric(vertical: 16, horizontal: 16),
        margin: const .symmetric(vertical: .125),
        color: MkColors.primaryAccent.shade500.withValues(alpha: .025),
        child: Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: .stretch,
                children: [
                  Text(item.title, style: theme.subhead3Semi.copyWith(letterSpacing: 0.125)),
                  const ScaledBox.vertical(4),
                  Text(
                    '${createdAt.day}.${createdAt.month}.${createdAt.year.toString().substring(2)}',
                    style: theme.body1.copyWith(letterSpacing: 0.125, color: kTextBaseColor.withValues(alpha: .75)),
                  ),
                ],
              ),
            ),
            Text(Money(item.value).formatted, style: theme.subhead1Bold.copyWith(letterSpacing: 1.05)),
          ],
        ),
      ),
    );
  }
}
