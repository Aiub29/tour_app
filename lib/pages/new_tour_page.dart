import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tour_app/colors/colors.dart';
import 'package:tour_app/db/db_firestore_helper.dart';
import 'package:tour_app/models/tour_models.dart';
import 'package:tour_app/styles/text_styles.dart';
class NewTourPage extends StatefulWidget {
  static final routName= '/new_tour';
  @override
  _NewTourPageState createState() => _NewTourPageState();
}

class _NewTourPageState extends State<NewTourPage> {
  final _formKey=GlobalKey<FormState>();
  TourModel tourModel=TourModel();
  DateTime selectedDate;


  _openCalendar(){
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    ).then((dateTime){
      tourModel.startDate=dateTime.microsecondsSinceEpoch;
      setState(() {
        selectedDate=dateTime;
      });
    });
  }
  _save(){
if(_formKey.currentState.validate()){
  _formKey.currentState.save();
  if(tourModel.startDate == null ) return;
  DBFirestoreHelper.addTour(tourModel).then((_) => Navigator.pop(context));
}
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('New Tour'),
      ),
      body: Stack(
        children: [
          Opacity(
            opacity: 0.3,
            child: Image.asset(
              'images/tourbackground3.jpg',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    style: TextStyle(color:Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Tour Name',
                      labelStyle: txtWhite14,
                      filled: true,
                      fillColor: rowItemColor,
                      border: OutlineInputBorder(),
                    ),
                    validator: (value){
                      if(value.isEmpty){
                        return 'Name should not be Empty';
                      }
                      if(value.length <6){
                        return 'Name cannot be less than 6 characters';
                      }
                      return null;
                    },
                    onSaved: (value){
                      tourModel.tourName=value;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    style: TextStyle(color:Colors.white),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Enter Budget',
                      labelStyle: txtWhite14,
                      filled: true,
                      fillColor: rowItemColor,
                      border: OutlineInputBorder(),
                    ),
                    validator: (value){
                      if(value.isEmpty){
                        return 'Budget should not be Empty';
                      }
                      if(double.parse(value) <= 0.0){
                        return 'Budget should be greater than Zero';
                      }
                      return null;
                    },
                    onSaved: (value){
                      tourModel.budget=double.parse(value);
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    style: TextStyle(color:Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Enter Destination',
                      labelStyle: txtWhite14,
                      filled: true,
                      fillColor: rowItemColor,
                      border: OutlineInputBorder(),
                    ),
                    validator: (value){
                      if(value.isEmpty){
                        return 'Destination should not be Empty';
                      }

                      return null;
                    },
                    onSaved: (value){
                      tourModel.destination=value;
                    },
                  ),
                  SizedBox(
                    height: 10.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(selectedDate == null ? 'Select a Startring Date':
                       DateFormat('EEE MMM dd, yyyy').format(selectedDate),style: txtWhite16,),
                      FlatButton(
                        child: Text('Open Calendar',style: txtWhite14,),
                        onPressed: _openCalendar,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                 Center(
                    child: RaisedButton(
                      color: Colors.amber,
                      splashColor: backgroundColor,
                      elevation: 5,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: Text('Create New Tour'),
                      onPressed: _save,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),


    );
  }
}

