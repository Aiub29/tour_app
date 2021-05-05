import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:tour_app/colors/colors.dart';
import 'package:tour_app/db/db_firestore_helper.dart';
import 'package:tour_app/models/expense_model.dart';
import 'package:tour_app/models/moment_models.dart';
import 'package:tour_app/models/tour_models.dart';
import 'package:tour_app/providers/tour_provider.dart';
import 'package:tour_app/styles/text_styles.dart';
import 'package:tour_app/utils/tour_utils.dart';
import 'package:tour_app/widgets/moment_grid_item.dart';
class TourDetailsPage extends StatefulWidget {
  static final routName= '/tour_details';
  final String tourId;
  TourDetailsPage({this.tourId});

  @override
  _TourDetailsPageState createState() => _TourDetailsPageState();
}
class _TourDetailsPageState extends State<TourDetailsPage> {
  TourProvider tourProvider;
  final _formKey=GlobalKey<FormState>();
  @override
  void didChangeDependencies() {
 tourProvider = Provider.of<TourProvider>(context);
 tourProvider.fetchExpense(widget.tourId);
 tourProvider.fetchMoments(widget.tourId);
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Details'),
      ),
      body: Stack(
        children: [
        Opacity(
          opacity: 0.3,
          child: Image.asset(
            'images/tourbackground2.jpg',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
          Positioned.fill(
            top: 70,
            child: FutureBuilder(
              future: tourProvider.fetchTourById(widget.tourId),
              builder: (context,AsyncSnapshot<TourModel> snapshot) {
                if(snapshot.hasData){
                  return CustomScrollView(
                    slivers: [
                     _buildSliverList(snapshot.data),
                      SliverPadding(
                        padding: const EdgeInsets.all(8.0),
                        sliver: SliverGrid.count(
                          crossAxisCount: 4,
                          childAspectRatio: 1,
                          children: tourProvider.momentList.map((momentModel) => MomentGridItem(momentModel)).toList(),
                        ),
                      )
                    ],
                  );

                }
                if(snapshot.hasError){
                  return Center(child: Text('Failed to fetch Data'),);
                }
                return Center(child: CircularProgressIndicator(),);
              }
            ),
          )
        ],
      ),
    );
  }
  Widget _buildSliverList(TourModel tourModel) {
    return SliverList(
      delegate: SliverChildListDelegate([
        _tourDetailsSection(tourModel),
        _tourExpenseSection(tourModel),
        _tourMomentHeaderSection(),
      ]),
    );
  }
 Widget _tourDetailsSection(TourModel tourModel) {
    return SizedBox(
      height: 100,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(10),
        color: rowItemColor,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tourModel.tourName,style: txtWhite16,),
                  Text('Starting on ${getFormattedDate(tourModel.startDate, 'MMM dd')}',style: txtWhite16, ),
                  Text('Going to ${tourModel.destination}',style: txtWhite14,)
                ],
              ),
            ),
            Positioned(
              right: 10,
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width / 3,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(12),bottomRight: Radius.circular(10)),
                  ),
                child: RaisedButton(
                  color: backgroundColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  child: Text('Complete Tour',style: txtWhite16,),
                  onPressed: (){},
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
 Widget _tourExpenseSection( TourModel tourModel) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Row(
      children: [
        CircularPercentIndicator(
            animation: true,
            lineWidth: 10,
            radius: 100,
            percent: tourProvider.getExpensePercent() / 100,
            progressColor: Colors.red,
            backgroundColor: Colors.white,
            center: Text('${tourProvider.getExpensePercent().round()}%',style: txtWhite30,),

        ),
        SizedBox(width: 20,),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Expense',style: txtWhite22,),
              Divider(
                color: Colors.white,
                thickness: 2,
              ),
              Text('Budget : ${tourModel.budget} tk',style: txtWhite16,),
              Text('Expense: ${tourProvider.totalExpense} tk',style: txtWhite16,),
              Text('Remaining: ${tourModel.budget - tourProvider.totalExpense} tk',style: txtWhite16,),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(icon: Icon(Icons.add,color: Colors.white,), onPressed:
                    _showAddExpenseDialog
                  ),
                  IconButton(icon: Icon(Icons.list,color: Colors.white,), onPressed: _viewExpenseDialog
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    ),
  );
  }
 Widget _tourMomentHeaderSection() {
    return Container(
     padding: const EdgeInsets.all(8),
     alignment: Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('My Moments ',style: txtWhite22,),
              Text('11 Images Found ',style: txtWhite16,),
            ],
          ),
          IconButton(icon: Icon(Icons.camera_enhance,color: Colors.white,), onPressed: _captureImage)
        ],
      ),
    );
  }
  void _showAddExpenseDialog(){
    ExpenseModel expenseModel=ExpenseModel(tourId: widget.tourId);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: backgroundColor,
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text('Add New Expense'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelStyle: txtWhite14,
                  filled: true,
                  fillColor: rowItemColor,
                  labelText: 'Expense Name',
                  border: OutlineInputBorder(),

                ),
                validator: (value){
                  if(value.isEmpty){
                    return 'Name should not be Empty';
                  }
                  return null;
                },
                onSaved: (value){
                  expenseModel.expenseName=value;
                },
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelStyle: txtWhite14,
                  filled: true,
                  fillColor: rowItemColor,
                  labelText: 'Expense Amount',
                  border: OutlineInputBorder(),

                ),
                validator: (value){
                  if(value.isEmpty){
                    return 'Amount should not be Empty';
                  }
                  if(double.parse(value) <= 0.0){
                    return 'Amount should be greater than 0';
                  }
                  return null;
                },
                onSaved: (value){
                  expenseModel.expenseAmount=double.parse(value);
                },
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
        actions: [
          FlatButton(
            onPressed: () => Navigator.pop(context,false),
            child: Text('CANCEL',style: txtWhite16,),
          ),
          RaisedButton(
            textColor: Colors.white,
            color: rowItemColor,
            onPressed: () {
              _saveExpense(expenseModel).then((value) => Navigator.pop(context));

            },
            child: Text('ADD'),
          ),
        ],
      )
    );
  }
  void _viewExpenseDialog(){
    showDialog(
      context: context,
      builder: (context) =>AlertDialog(
       backgroundColor: backgroundColor,
       elevation: 10,
       shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text('View Expenses',style: TextStyle(color:Colors.white),),
        content: Container(
          width: MediaQuery.of(context).size.width * 0.70,
          height: MediaQuery.of(context).size.height *0.50,
          child: StreamBuilder(
            stream: tourProvider.getExpenses(widget.tourId),
            builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){
              if(snapshot.hasData){
                return ListView.builder(
                  itemBuilder: (context,index) =>
                  ListTile(
                    title: Text(ExpenseModel.fromMap(snapshot.data.docs[index].data()).expenseName,style: txtWhite16,),
                    subtitle: Text(getFormattedDate(ExpenseModel.fromMap(snapshot.data.docs[index].data()).expenseDate, 'dd/MM/yyy hh:mm:ss'),style: txtWhite16,),
                  trailing: Chip(
                    backgroundColor: rowItemColor,
                    label: Text('${ExpenseModel.fromMap(snapshot.data.docs[index].data()).expenseAmount}',style: txtWhite16,),
                  ),
                  ),
                  itemCount: snapshot.data.docs.length,
                );
              }
              if(snapshot.hasError){
                return Center(child: Text('Failed to fetch Data !'),);
              }
              return Center(child: CircularProgressIndicator(),);
            }
          ),
        ),
        actions: [
          FlatButton(onPressed: () => Navigator.pop(context),child: Text('CANCEL',style: txtWhite16,),)
        ],
      )
    );
  }
  Future _saveExpense(ExpenseModel expenseModel) async {
      if(_formKey.currentState.validate()){
        _formKey.currentState.save();
        expenseModel.expenseDate =DateTime.now().millisecondsSinceEpoch;
       await tourProvider.saveExpense(expenseModel);
      }
  }
  void _captureImage() async {
   PickedFile pickedFile= await ImagePicker().getImage(source: ImageSource.camera,);
   //print(pickedFile.path);
    final imageName='TourMate_${DateTime.now().millisecondsSinceEpoch}';
    StorageReference rootRef=FirebaseStorage.instance.ref();
    StorageReference photoRef=rootRef.child('TourMate/$imageName');
    final uploadTask=photoRef.putFile(File(pickedFile.path));
    final snapShot =await uploadTask.onComplete;
    snapShot.ref.getDownloadURL().then((url) {
      print(url.toString());
      final moment =MomentModel(tourId: widget.tourId,momentName: imageName,
          localImagePath: pickedFile.path,imageDownloadUrl: url.toString());
      tourProvider.saveMoment(moment).then((value) => print('moment save'));
    });
  }
}
