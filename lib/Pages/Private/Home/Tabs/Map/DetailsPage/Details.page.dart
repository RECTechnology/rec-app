import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:rec/Components/Info/CircleAvatar.dart';
import 'package:rec/Entities/Account.ent.dart';
import 'package:rec/Entities/Offers.ent.dart';

import 'package:rec/Components/RecFilterButton.dart';
import 'package:rec/Components/Info/OffersCard.dart';

import 'package:rec/Providers/AppLocalizations.dart';

import 'package:rec/Styles/Paddings.dart';
import 'package:rec/Styles/TextStyles.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsPage extends StatefulWidget {
  final Account bussinesData;

  DetailsPage(this.bussinesData);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  bool isResume = true;
  double lat;
  double lon;
  DateTime date = DateTime.now();
  List<String> days = [];
  String firstHalf;
  String secondHalf;
  bool flag = true;
  List<String> schedules;

  @override
  void initState() {
    super.initState();
    createDayList();
    if (widget.bussinesData.description.length > 50) {
      firstHalf = widget.bussinesData.description.substring(0, 50);
      secondHalf = widget.bussinesData.description
          .substring(50, widget.bussinesData.description.length);
    } else {
      firstHalf = widget.bussinesData.description;
      secondHalf = '';
    }

    schedules = widget.bussinesData.schedule.split('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(120),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      widget.bussinesData.companyImage ??
                          'https://picsum.photos/250?image=9',
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.white],
                )),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30, 9, 0, 11),
                child: Row(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: CircleAvatarRec(
                        imageUrl: widget.bussinesData.publicImage ??
                            'https://picsum.photos/250?image=9',
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(26, 9, 0, 11),
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              widget.bussinesData.name ?? 'Text not found',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.bussinesData.street ?? 'Text not found',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black38),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          )),
      body: isResume ? ResumePage() : SchedulePage(),
    );
  }

  Widget ResumePage() {
    var localizations = AppLocalizations.of(context);

    return SingleChildScrollView(
        child: Padding(
      padding: Paddings.textField,
      child: Column(
        children: [
          Container(
            height: 1,
            width: double.maxFinite,
            color: Colors.grey,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16, 9, 0, 11),
            child: Row(
              children: [
                RichText(
                  text: TextSpan(
                      text: localizations.translate('RESUME'),
                      style: TextStyle(color: Colors.blue, fontSize: 14)),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
                  child: RichText(
                    text: TextSpan(
                        text: localizations.translate('SCHEDULE'),
                        recognizer: TapGestureRecognizer()
                          ..onTap = changePageContent,
                        style: TextStyle(color: Colors.grey, fontSize: 14)),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 1,
            width: double.maxFinite,
            color: Colors.grey,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(6, 8, 0, 16),
            child: Row(
              children: [
                RecFilterButton(
                  icon: Icons.call_made,
                  label: localizations.translate('PAY'),
                  padding: Paddings.filterButton,
                  onPressed: () {},
                  disabled: false,
                  backgroundColor: Colors.blueAccent,
                  textColor: Colors.white,
                ),
                RecFilterButton(
                  icon: Icons.assistant_direction,
                  label: localizations.translate('HOW_TO_GO'),
                  padding: Paddings.filterButton,
                  onPressed: launchMapsUrl,
                  disabled: false,
                  backgroundColor: Colors.white,
                ),
                RecFilterButton(
                  icon: Icons.phone,
                  label: localizations.translate('CALL'),
                  padding: Paddings.filterButton,
                  onPressed: call,
                  disabled: false,
                  backgroundColor: Colors.white,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 0, 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Abierto . Cierra a las 21:00',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: secondHalf.isEmpty
                  ? Text(firstHalf)
                  : Text(
                      flag ? (firstHalf + '...') : (firstHalf + secondHalf),
                      style: TextStyle(fontSize: 14),
                      softWrap: true,
                    ),
            ),
          ),
          secondHalf.isEmpty
              ? SizedBox()
              : Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 0, 16),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        flag = !flag;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          flag ? 'show more' : 'show less',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
          Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                  style: TextStyles.link,
                  text: widget.bussinesData.webUrl ?? '',
                  recognizer: TapGestureRecognizer()..onTap = () async {},
                ),
              ),
            ),
          ),
          Container(
            width: 380,
            height: 130,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                  widget.bussinesData.companyImage ??
                      'https://picsum.photos/250?image=9',
                ),
              ),
            ),
          ),
          widget.bussinesData.offers.isNotEmpty ? offersList() : SizedBox()
        ],
      ),
    ));
  }

  Widget SchedulePage() {
    var localizations = AppLocalizations.of(context);

    return SingleChildScrollView(
        child: Padding(
      padding: Paddings.textField,
      child: Column(
        children: [
          Container(
            height: 1,
            width: double.maxFinite,
            color: Colors.grey,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16, 9, 0, 11),
            child: Row(
              children: [
                RichText(
                  text: TextSpan(
                      text: localizations.translate('RESUME'),
                      recognizer: TapGestureRecognizer()
                        ..onTap = changePageContent,
                      style: TextStyle(color: Colors.grey, fontSize: 14)),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
                  child: RichText(
                    text: TextSpan(
                        text: localizations.translate('SCHEDULE'),
                        style: TextStyle(color: Colors.blue, fontSize: 14)),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 1,
            width: double.maxFinite,
            color: Colors.grey,
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(91, 5, 33, 0),
              child: Container(
                height: 500,
                child: ListView.builder(
                    itemCount: days.length,
                    itemBuilder: (context, index) {
                      return Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 32),
                          child: Row(
                            children: [
                              Text(
                                days[index],
                                style: TextStyle(
                                  fontWeight: (index % 2) == 0
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(88, 0, 0, 0),
                                child: Column(
                                  children: [
                                    Text(schedules[index],
                                        style: TextStyle(
                                          fontWeight: (index % 2) == 0
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        )),
                                    Text(schedules[index],
                                        style: TextStyle(
                                          fontWeight: (index % 2) == 0
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        )),
                                  ],
                                ),
                              )
                            ],
                          ));
                    }),
              ))
        ],
      ),
    ));
  }

  Widget offersList() {
    var localizations = AppLocalizations.of(context);
    return Column(
      children: [
        Padding(
            padding: EdgeInsets.fromLTRB(16, 22, 292, 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                localizations.translate('OFFERS'),
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            )),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 26, 0),
          child: Container(
            width: 354,
            height: 68,
            alignment: Alignment.centerLeft,
            child: ListView.builder(
                itemCount: widget.bussinesData.offers.length,
                itemBuilder: (context, index) {
                  print('printing offert');
                  print(widget.bussinesData.offers[index]);
                  var offerData = OffersData(
                    widget.bussinesData.offers[index]['id'],
                    widget.bussinesData.offers[index]['description'],
                    widget.bussinesData.offers[index]['discount'],
                    widget.bussinesData.offers[index]['image'],
                  );
                  return OffersCard(offerData);
                }),
          ),
        )
      ],
    );
  }

  void changePageContent() {
    isResume ? isResume = false : isResume = true;
    setState(() {});
  }

  void launchMapsUrl() async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lon';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void call() async {
    var phone = widget.bussinesData.prefix + widget.bussinesData.phone;
    await launch('tel://$phone');
  }

  // ignore: missing_return
  String getDay(int dayInNumber) {
    if (dayInNumber == 1) {
      return 'Lunes';
    }
    if (dayInNumber == 2) {
      return 'Martes';
    }
    if (dayInNumber == 3) {
      return 'Miercoles';
    }
    if (dayInNumber == 4) {
      return 'Jueves';
    }
    if (dayInNumber == 5) {
      return 'Viernes';
    }
    if (dayInNumber == 6) {
      return 'Sabado';
    }
    if (dayInNumber == 7) {
      return 'Domingo';
    }
  }

  void createDayList() {
    var actualDayInNumber = date.weekday;
    var counter = 0;
    for (var element = actualDayInNumber;
        element <= 7 && days.length <= 7;
        element++) {
      counter++;
      days.add(getDay(element));

      if (element == 7 && days.length < 7) {
        for (var i = 1; (days.length - counter) < 7; i++) {
          days.add(getDay(i));
        }
        return;
      }
    }
  }
}
