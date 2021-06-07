import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rec/Api/Services/AccountsService.dart';
import 'package:rec/Components/Inputs/DropDown.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/Entities/Schedule/Schedule.ent.dart';
import 'package:rec/Entities/Schedule/ScheduleType.dart';
import 'package:rec/Helpers/DateHelper.dart';
import 'package:rec/Helpers/Loading.dart';
import 'package:rec/Helpers/RecToast.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Providers/UserState.dart';
import 'package:rec/Styles/Paddings.dart';
import 'package:rec/brand.dart';

class AccountSchedulePage extends StatefulWidget {
  AccountSchedulePage({Key key}) : super(key: key);

  @override
  _AccountSchedulePageState createState() => _AccountSchedulePageState();
}

class _AccountSchedulePageState extends State<AccountSchedulePage> {
  final AccountsService _accountsService = AccountsService();

  Schedule schedule;

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

    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: LocalizedText(
              DateHelper.getWeekdayName(index + 1),
            ),
          ),
          Expanded(
            flex: 4,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _customInput(
                        day.firstOpen,
                        (val) {
                          setState(() => day.firstOpen = val);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Icon(Icons.remove),
                    ),
                    Expanded(
                      child: _customInput(
                        day.firstClose,
                        (val) {
                          setState(() => day.firstClose = val);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: _customInput(
                        day.secondOpen,
                        (val) {
                          setState(() => day.secondOpen = val);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Icon(Icons.remove),
                    ),
                    Expanded(
                      child: _customInput(
                        day.secondClose,
                        (val) {
                          setState(() => day.secondClose = val);
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _customInput(
    String value,
    ValueChanged<String> onChanged, {
    String helpText,
  }) {
    var localizations = AppLocalizations.of(context);

    return InkWell(
      onTap: () async {
        var result = await showTimePicker(
          initialTime: TimeOfDay.now(),
          context: context,
          helpText: helpText,
        );

        if (result != null) {
          onChanged(result.format(context));
          schedule.type = ScheduleType.TIMETABLE;
        }
      },
      child: Opacity(
        opacity: (schedule.type == ScheduleType.TIMETABLE && value != null)
            ? 1
            : 0.6,
        child: Container(
          decoration: BoxDecoration(
            color: Brand.defaultAvatarBackground,
            borderRadius: BorderRadius.all(
              Radius.circular(6),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 8.0,
            ),
            child: Text(
              (schedule.type == ScheduleType.CLOSED || value == null)
                  ? localizations.translate('CLOSED')
                  : value,
            ),
          ),
        ),
      ),
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

  void _updatedSchedule(c) {
    var userState = UserState.of(context, listen: false);
    userState.getUser();

    Loading.dismiss();
    RecToast.showSuccess(context, 'SCHEDULE_UPDATED_OK');
    Navigator.pop(context);
  }

  void _onError(e) {
    Loading.dismiss();
    RecToast.showError(context, e.message);
  }
}
