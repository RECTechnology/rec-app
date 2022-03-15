import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/DropDown.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';
import 'package:rec/Components/ListTiles/ScheduleDayInput.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/environments/env.dart';
import 'package:rec/helpers/loading.dart';
import 'package:rec/helpers/RecToast.dart';
import 'package:rec/providers/AppLocalizations.dart';
import 'package:rec/providers/user_state.dart';
import 'package:rec/styles/paddings.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class AccountSchedulePage extends StatefulWidget {
  AccountSchedulePage({Key? key}) : super(key: key);

  @override
  _AccountSchedulePageState createState() => _AccountSchedulePageState();
}

class _AccountSchedulePageState extends State<AccountSchedulePage> {
  final AccountsService _accountsService = AccountsService(env: env);

  Schedule? schedule;
  ScheduleDay? copiedDay;

  @override
  void didChangeDependencies() {
    schedule ??= (UserState.of(context).account!.schedule ?? Schedule()).clone();
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
              title: localizations!.translate('TYPE'),
              data: ScheduleType.values.map((e) => e.type).toList(),
              current: schedule!.type!.type,
              onSelect: _scheduleTypeSelected,
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

  void _scheduleTypeSelected(type) {
    setState(() {
      schedule!.type = ScheduleType.fromName(type);

      // Make all days closed when a type changes to some types
      // So user can start editing schedule from 0
      if (schedule!.isDefined || schedule!.isOpen24h || schedule!.isClosed) {
        schedule!.updateEachDay((e) => e..opens = false);
      }
    });
  }

  Widget _scheduleDayBuilder(ctx, index) {
    var day = schedule!.days[index];

    return ScheduleDayInput(
      day: day,
      closed: schedule!.isClosed,
      opens24Hours: schedule!.isOpen24h,
      isNotAvailable: schedule!.isNotAvailable,
      weekday: index + 1,
      onChange: (ScheduleDay day) {
        setState(() {
          schedule!.days[index] = day;
        });
      },
      onCompleteDay: () {
        setState(() {
          // ignore: unnecessary_null_comparison
          if (index > 0 && schedule!.days[index - 1] != null) {
            schedule!.days[index].copyFrom(schedule!.days[index - 1]);
          } else {
            schedule!.days[index].resetToDefaultTime();
          }
        });
      },
      onAction: (action) {
        switch (action) {
          case CopyPasteAction.copy:
            copiedDay = schedule!.days[index];
            break;
          case CopyPasteAction.paste:
            if (copiedDay != null) {
              schedule!.days[index].copyFrom(copiedDay!);
            }
            break;
        }
        setState(() {});
      },
    );
  }

  void _saveSchedule() {
    Loading.show();

    var accountId = UserState.of(context, listen: false).account!.id;

    _accountsService
        .updateAccount(accountId, {
          'schedule': json.encode(schedule!.toJson()),
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
