import 'package:flutter/material.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/config/theme.dart';

class AcceptTerms extends StatelessWidget {
  final bool termsAccepted;
  final ValueChanged<bool?>? termsAcceptedChanged;
  final void Function()? openTermsOfService;
  final Color? color;

  const AcceptTerms({
    Key? key,
    this.termsAccepted = false,
    this.termsAcceptedChanged,
    this.openTermsOfService,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final recTheme = RecTheme.of(context);

    return Row(
      children: [
        Checkbox(
          value: termsAccepted,
          onChanged: termsAcceptedChanged,
          checkColor: Colors.white,
          activeColor: color ?? recTheme!.accentColor,
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
              color: color ?? recTheme!.accentColor,
            ),
          ),
        )
      ],
    );
  }
}
