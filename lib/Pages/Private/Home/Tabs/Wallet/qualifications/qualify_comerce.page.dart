import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Components/Inputs/buttons/close_page_button.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/Components/Text/styled_text.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/qualifications/counter_box_widget.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/qualifications/qualification_badge.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/qualifications/qualification_badge_list.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/qualifications/qualification_comerce_header.dart';
import 'package:rec/config/brand.dart';
import 'package:rec/config/rec_handled_error.dart';
import 'package:rec/helpers/RecToast.dart';
import 'package:rec/helpers/loading.dart';
import 'package:rec/providers/qualifications_provider.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class QualifyComercePage extends StatefulWidget {
  final Account accountToQualify;
  final List<Qualification> qualifications;

  const QualifyComercePage({
    Key? key,
    required this.accountToQualify,
    required this.qualifications,
  }) : super(key: key);

  @override
  _QualifyComercePageState createState() => _QualifyComercePageState();

  static Route getRoute({
    required Account accountToQualify,
    required List<Qualification> qualifications,
  }) {
    return MaterialPageRoute(
      builder: (ctx) => QualifyComercePage(
        accountToQualify: accountToQualify,
        qualifications: qualifications,
      ),
    );
  }
}

class _QualifyComercePageState extends State<QualifyComercePage> {
  List<QualificationVote> _allQualifications = [];
  final Set<QualificationVote> _votedQualifications = {};

  int _counterYes = 0;
  int _counterNo = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        titleTextStyle: TextStyle(color: Brand.grayDark),
        title: LocalizedText('QUALIFY_COMERCE', style: TextStyle(fontSize: 16)),
        automaticallyImplyLeading: false,
        actions: [
          ClosePageButton(),
        ],
      ),
      backgroundColor: Colors.white,
      body: _body(),
    );
  }

  @override
  void initState() {
    _allQualifications = widget.qualifications
        .map(
          (qualification) => QualificationVote(qualification: qualification),
        )
        .toList();
    super.initState();
  }

  Widget _body() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          QualificationComerceHeader(
            account: widget.accountToQualify,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24, bottom: 12),
            child: _questionTitle(),
          ),
          _helpMessage(),
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 24),
            child: QualificationBadgeList(
              qualifications: _allQualifications,
              qualificationChanged: _qualificationChanged,
            ),
          ),
          _counters(),
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 12),
            child: _footer(),
          ),
          Spacer(),
          RecActionButton(
            label: 'QUALIFY_CTA',
            onPressed: _submitVotes,
          ),
        ],
      ),
    );
  }

  Widget _counters() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ActionlessQualificationBadge(
          label: LocalizedText('YES', uppercase: true),
          icon: CounterBoxWidget(count: _counterYes),
          state: QualificationState.yes,
        ),
        const SizedBox(width: 8),
        ActionlessQualificationBadge(
          label: LocalizedText('NO', uppercase: true),
          icon: CounterBoxWidget(count: _counterNo),
          state: QualificationState.no,
        ),
      ],
    );
  }

  Widget _footer() {
    return Container(
      alignment: Alignment.center,
      child: LocalizedStyledText(
        'QUALIFY_WILL_BE_USEFUL',
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _helpMessage() {
    final style = TextStyle(fontSize: 14);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LocalizedStyledText('QUALIFY_INFO_LINE_1', style: style),
        const SizedBox(height: 6),
        LocalizedStyledText('QUALIFY_INFO_LINE_2', style: style),
      ],
    );
  }

  Widget _questionTitle() {
    return LocalizedText(
      'DOES_IT_HAVE_CHARACTERISTICS',
      style: TextStyle(
        fontSize: 16,
      ),
    );
  }

  void _qualificationChanged(QualificationVote qualification) {
    switch (qualification.state) {
      case QualificationState.yes:
      case QualificationState.no:
        _votedQualifications.add(qualification);
        break;
      default:
        _votedQualifications.remove(qualification);
        break;
    }

    _updateCounters();
  }

  void _submitVotes() async {
    if (_votedQualifications.isEmpty) {
      return Navigator.pop(context);
    }

    try {
      Loading.show();
      final qualificationsProvider = QualificationsProvider.deaf(context);
      for (final votedQualification in _votedQualifications) {
        await qualificationsProvider.updateQualification(
          votedQualification.qualification.id as String,
          UpdateQualificationData(votedQualification.state.value),
        );
      }

      Loading.dismiss();
      RecToast.showSuccess(context, 'VOTED_OK');
      Navigator.pop(context, true);
    } catch (e) {
      Loading.dismiss();
      e.toString() == RecHandledErrors.qualificatonExpired
          ? RecToast.showError(context, 'QUALIFICATIONS_EXPIRED')
          : RecToast.showError(context, e.toString());
      Navigator.pop(context, true);
    }
  }

  void _updateCounters() {
    _counterYes = 0;
    _counterNo = 0;

    for (final element in _votedQualifications) {
      if (element.state == QualificationState.yes) {
        _counterYes += 1;
      }

      if (element.state == QualificationState.no) {
        _counterNo += 1;
      }
    }

    setState(() {});
  }
}
