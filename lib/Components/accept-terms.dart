import 'package:flutter/material.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/config/brand.dart';

class AcceptTerms extends StatelessWidget {
  final bool termsAccepted;
  final ValueChanged<bool?>? termsAcceptedChanged;
  final void Function()? openTermsOfService;
  final Color accentColor;

  const AcceptTerms({
    Key? key,
    this.termsAccepted = false,
    this.termsAcceptedChanged,
    this.openTermsOfService,
    this.accentColor = Brand.accentColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Row(
      children: [
        Checkbox(
          value: termsAccepted,
          onChanged: termsAcceptedChanged,
          checkColor: Colors.white,
          activeColor: accentColor,
        ),
        LocalizedText(
          'I_ACCEPT_THE',
          style: theme.textTheme.bodyText1,
        ),
        GestureDetector(
          onTap: openTermsOfService,
          child: LocalizedText(
            'TERMS_OF_SERVICE',
            style: theme.textTheme.bodyText1!.copyWith(
              decoration: TextDecoration.underline,
              color: accentColor,
            ),
          ),
        )
      ],
    );
  }
}
