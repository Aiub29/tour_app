import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:tour_app/colors/colors.dart';
import 'package:tour_app/db/db_firestore_helper.dart';
import 'package:tour_app/models/tour_models.dart';
import 'package:tour_app/pages/tour_details_page.dart';
import 'package:tour_app/styles/text_styles.dart';
class TourItem extends StatefulWidget {
  final TourModel tourModel;
  TourItem(this.tourModel);

  @override
  _TourItemState createState() => _TourItemState();
}

class _TourItemState extends State<TourItem> {

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(widget.tourModel.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 10),
        margin: const EdgeInsets.symmetric(vertical: 7,horizontal: 10),
        color: Colors.red,
        child: Icon(Icons.delete,color:Colors.white),
      ),
     onDismissed: (direction){
      DBFirestoreHelper.deleteTour(widget.tourModel.id);
     },
      confirmDismiss: (direction){
        return showDialog(
          context:  context,
          builder: (context) => AlertDialog(
            title: Text('Delete ${widget.tourModel.tourName}?'),
            content: Text('Are you sure to delete this item? You cannot undo this operation' ),
          actions: [
            FlatButton(onPressed: () => Navigator.pop(context,false), child: Text('CANCEL'),),
            RaisedButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
              color: rowItemColor,
              textColor: Colors.white,

              onPressed: () =>Navigator.pop(context,true),
              child: Text('DELETE'),
            ),
          ],
          )
        );
      },

      child: OpenContainer(
        closedColor: backgroundColor.withOpacity(0.3),
        closedElevation: 0,
        closedBuilder: (context,_) => Card(
          margin: const EdgeInsets.symmetric(vertical: 7,horizontal: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: rowItemColor,
          elevation: 5,
          child: ListTile(

            title: Text(widget.tourModel.tourName,style: txtHeadlineStyle,),
            subtitle: Text(widget.tourModel.destination,style: txtSubHeadlineStyle,),
          ),
        ),
        openBuilder: (context,_) => TourDetailsPage(tourId:widget.tourModel.id),
        transitionType: ContainerTransitionType.fade,
        transitionDuration: Duration(milliseconds: 700),
      )
    );
  }
}
