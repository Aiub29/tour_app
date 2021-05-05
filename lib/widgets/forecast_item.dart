import 'package:flutter/material.dart';
import 'package:tour_app/models/ForecastModel.dart';
import 'package:tour_app/styles/text_styles.dart';
import 'package:tour_app/utils/tour_utils.dart';
class ForecastItem extends StatelessWidget {
  final ListElement forecastItem;

  ForecastItem(this.forecastItem);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(getFormattedDate(forecastItem.dt, 'EEE'),style: txtWhite16,),
          Text(getFormattedDate(forecastItem.dt, 'hh:mm a'),style: txtWhite16,),
          Image.network('${icon_prefix}${forecastItem.weather[0].icon}${icon_suffix}',
          width: 50,
          height: 50,
            fit: BoxFit.cover,
          ),
          Text('${forecastItem.main.tempMax.round()}/${forecastItem.main.tempMin.round()}\u00B0',
          style: txtWhite16,),
        ],
      ),
    );
  }
}
