import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/DateInput.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/config/brand.dart';
import 'package:rec/helpers/RecToast.dart';
import 'package:rec/helpers/loading.dart';
import 'package:rec/mixins/Loadable.mixin.dart';
import 'package:rec/providers/transactions_provider.dart';
import 'package:rec/styles/paddings.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class AccountDaySalesPage extends StatefulWidget {
  AccountDaySalesPage({
    Key? key,
  }) : super(key: key);

  @override
  _AccountDaySalesPageState createState() => _AccountDaySalesPageState();
}

class _AccountDaySalesPageState extends State<AccountDaySalesPage> with Loadable {
  DateTime selectedDay = DateTime.now();
  DaySalesSummary summary = DaySalesSummary();
  bool isLoading = true;
  late TransactionProvider transactionProvider;

  @override
  void initState() {
    super.initState();
    transactionProvider = TransactionProvider.of(context, listen: false);
    _fetchSummary();
  }

  _selectDay(String newSelectedDay) {
    setState(() {
      selectedDay = DateTime.parse(newSelectedDay);
    });
    _fetchSummary();
  }

  _fetchSummary() {
    setIsLoading(true);
    transactionProvider.txService.listForDate(date: selectedDay).then((value) {
      setState(() {
        summary = value;
      });
      setIsLoading(false);
    }).catchError(_onError);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: EmptyAppBar(
        context,
        title: 'SETTINGS_DAILY_BALANCE',
      ),
      body: Scrollbar(
        thickness: 8,
        trackVisibility: true,
        radius: Radius.circular(3),
        child: Padding(
          padding: Paddings.page,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LocalizedText('DAILY_SALES_DESC'),
              const SizedBox(height: 16),
              DateInput(
                onChange: _selectDay,
                value: selectedDay.toIso8601String(),
                firstDate: DateTime(1948),
                lastDate: DateTime.now(),
                label: 'SELECT_DAY',
              ),
              if (isLoading) Center(child: CircularProgressIndicator()),
              if (!isLoading)
                DaySalesSummaryWidget(
                  summary: summary,
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void setIsLoading(bool isLoading) {
    setState(() {
      this.isLoading = isLoading;
    });
  }

  _onError(e) {
    Loading.dismiss();
    RecToast.showError(context, e.toString());
  }
}

class DaySalesSummaryWidget extends StatelessWidget {
  final DaySalesSummary summary;

  const DaySalesSummaryWidget({
    Key? key,
    required this.summary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AmountAggregate(
          label: 'TX_IN',
          amount: summary.inAmount,
        ),
        AmountAggregate(
          label: 'TX_OUT',
          amount: summary.outAmount,
        ),
        AmountAggregate(
          label: 'TX_TOTAL',
          amount: summary.total,
        ),
      ],
    );
  }
}

class AmountAggregate extends StatelessWidget {
  final String label;
  final num amount;

  const AmountAggregate({
    Key? key,
    required this.label,
    required this.amount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var formatted = Currency.format(
      Currency.rec.scaleAmount(amount.abs()),
    );
    var prefix = amount.isNegative ? '-' : '+';
    var color = amount.isNegative ? Brand.amountNegative : Brand.primaryColor;

    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          LocalizedText(
            label,
            style: Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 14),
          ),
          LocalizedText(
            '$prefix$formatted',
            style: Theme.of(context).textTheme.headline4!.copyWith(
                  fontSize: 18,
                  color: color,
                ),
          ),
        ],
      ),
    );
  }
}
