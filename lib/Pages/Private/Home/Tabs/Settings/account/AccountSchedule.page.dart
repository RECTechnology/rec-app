import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rec/Api/Services/AccountsService.dart';
import 'package:rec/Components/Inputs/DropDown.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';
import 'package:rec/Components/ListTiles/ScheduleDayInput.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/Entities/Schedule/Schedule.ent.dart';
import 'package:rec/Entities/Schedule/ScheduleDay.ent.dart';
import 'package:rec/Entities/Schedule/ScheduleType.dart';
import 'package:rec/Helpers/Loading.dart';
import 'package:rec/Helpers/RecToast.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Providers/UserState.dart';
import 'package:rec/Styles/Paddings.dart';

class AccountSchedulePage extends StatefulWidget {
  AccountSchedulePage({Key key}) : super(key: key);

  @override
  _AccountSchedulePageState createState() => _AccountSchedulePageState();
}

class _AccountSchedulePageState extends State<AccountSchedulePage> {
  final AccountsService _accountsService = AccountsService();

  Schedule schedule;
  ScheduleDay copiedDay;

  @override
  void didChangeDependencies() {
    schedule ??= UserState.of(context).account.schedule ?? Schedule();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: EmptyAppBar(
        context,
        title: 'BUSSINESS_SCHEDULE',
      ),
      body: Padding(
        padding: Paddings.page,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LocalizedText('TYPE'),
            const SizedBox(height: 8),
            DropDown(
              title: localizations.translate('TYPE'),
              data: ScheduleType.values.map((e) => e.type).toList(),
              current: schedule.type.type,
              onSelect: (type) {
                setState(() => {schedule.type = ScheduleType.fromName(type)});
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              flex: 1,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: 7,
                itemBuilder: _scheduleDayBuilder,
              ),
            ),
            RecActionButton(
              label: 'UPDATE',
              onPressed: _saveSchedule,
            )
          ],
        ),
      ),
    );
  }

  Widget _scheduleDayBuilder(ctx, index) {
    var day = schedule.days[index];

    return ScheduleDayInput(
      day: day,
      closed: schedule.isClosed,
      opens24Hours: schedule.isOpen24h,
      weekday: index + 1,
      onChange: (ScheduleDay day) {
        setState(() {
          schedule.days[index] = day;
        });
      },
      onCompleteDay: () {
        setState(() {
          if (schedule.days[index - 1] != null) {
            schedule.days[index].copyFrom(schedule.days[index - 1]);
          } else {
            schedule.days[index].resetToDefaultTime();
          }
        });
      },
      onAction: (action) {
        switch (action) {
          case CopyPasteAction.copy:
            copiedDay = schedule.days[index];
            break;
          case CopyPasteAction.paste:
            if (copiedDay != null) {
              schedule.days[index].copyFrom(copiedDay);
            }
            break;
        }
        setState(() {});
      },
    );
  }

  void _saveSchedule() {
    Loading.show();

    var accountId = UserState.of(context, listen: false).account.id;

    _accountsService
        .updateAccount(accountId, {
          'schedule': json.encode(schedule.toJson()),
        })
        .then(_updatedSchedule)
        .catchError(_onError);
  }

  void _updatedSchedule(c) async {
    var userState = UserState.of(context, listen: false);
    await userState.getUser();
    await Loading.dismiss();

    RecToast.showSuccess(context, 'SCHEDULE_UPDATED_OK');
    Navigator.pop(context);
  }

  void _onError(e) {
    Loading.dismiss();
    RecToast.showError(context, e.message);
  }
}
