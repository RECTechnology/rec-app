import 'package:flutter/material.dart';
import 'package:rec/Components/Info/rec_rect_avatar.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class QualificationComerceHeader extends StatelessWidget {
  const QualificationComerceHeader({
    Key? key,
    required this.account,
  }) : super(key: key);

  final Account account;

  Widget _buildImage() {
    return RectAvatarRec(
      width: 64,
      height: 64,
      imageUrl: account.companyImage!,
      seed: account.name,
      name: account.name,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildImage(),
        const SizedBox(
          width: 12,
        ),
        Text(
          account.name ?? 'PARTICULAR',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}
