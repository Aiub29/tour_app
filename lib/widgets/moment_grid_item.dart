import 'package:flutter/material.dart';
import 'package:tour_app/models/moment_models.dart';
class MomentGridItem extends StatefulWidget {

  final MomentModel momentModel;

  MomentGridItem(this.momentModel);

  @override
  _MomentGridItemState createState() => _MomentGridItemState();
}

class _MomentGridItemState extends State<MomentGridItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(2),
      elevation: 1,
      child: FadeInImage.assetNetwork(
        fadeInDuration: const Duration(milliseconds: 1000),
        fadeInCurve: Curves.bounceIn,
        placeholder: 'images/placeholder.png',
        image: widget.momentModel.imageDownloadUrl,
      ),
    );









  }
}
