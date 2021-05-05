import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tour_app/db/db_firestore_helper.dart';
import 'package:tour_app/models/expense_model.dart';
import 'package:tour_app/models/moment_models.dart';
import 'package:tour_app/models/tour_models.dart';

class TourProvider with ChangeNotifier{
  List<ExpenseModel> _expense = [];
  List<MomentModel> _moments = [];
  TourModel tourModel;
  double totalExpense =0.0;

  List<ExpenseModel> get expenseList => _expense;
  List<MomentModel> get momentList => _moments;

  Future<void> saveExpense(ExpenseModel expenseModel) async {
    await DBFirestoreHelper.addExpense(expenseModel);
   }

   Future<void> saveMoment(MomentModel momentModel) async {
    await DBFirestoreHelper.addMoment(momentModel);
   }

   Future<TourModel>fetchTourById(String tourId) async {
   tourModel = await DBFirestoreHelper.getTourById(tourId);
    notifyListeners();
    return tourModel;
   }

   void fetchExpense(String tourId){
    DBFirestoreHelper.getExpenseListFromDB(tourId).then((value) {
     _expense=value;
     _calculateTotalExpense();
     notifyListeners();
    });
   }

   void fetchMoments(String tourId){
    DBFirestoreHelper.getMomentListFromDB(tourId).then((moments) {

      _moments=moments;
      notifyListeners();
    });
   }
   Stream <QuerySnapshot> getExpenses(String tourId){
     return DBFirestoreHelper.getAllExpenses(tourId);
   }
  void _calculateTotalExpense() {
      var total = 0.0;
      _expense.forEach((element) {
        total +=element.expenseAmount;
        });
      totalExpense = total;
      notifyListeners();
  }

double getExpensePercent() => (totalExpense * 100) /tourModel.budget;

}