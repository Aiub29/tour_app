import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tour_app/models/expense_model.dart';
import 'package:tour_app/models/moment_models.dart';
import 'package:tour_app/models/tour_models.dart';
class DBFirestoreHelper{

  static final COLLECTION_TOUR='Tours';
  static final COLLECTION_EXPENSE='Expense';
  static final COLLECTION_MOMENT='Moment';
  static final FirebaseFirestore  _db=FirebaseFirestore.instance;

  static Future<void> addTour(TourModel tourModel) async{
    final doc=_db.collection(COLLECTION_TOUR).doc();
    tourModel.id=doc.id;
    return doc.set(tourModel.toMap());
  }

  static Future<void> addExpense(ExpenseModel expenseModel) async{
    final doc=_db.collection(COLLECTION_EXPENSE).doc();
    expenseModel.expenseId=doc.id;
    return doc.set(expenseModel.toMap());
  }

  static Future<void> addMoment(MomentModel momentModel) async{
    final doc=_db.collection(COLLECTION_MOMENT).doc();
    momentModel.momentId=doc.id;
    return doc.set(momentModel.toMap());
  }

  static Stream <QuerySnapshot> getAllTours(){
  return  _db.collection(COLLECTION_TOUR).snapshots();
  }

  static Stream <QuerySnapshot> getAllExpenses(String tourId){
  return  _db.collection(COLLECTION_EXPENSE).where('tourId',isEqualTo: tourId).snapshots();
  }
  static Future<List<MomentModel>> getMomentListFromDB(String tourId) async {
    List<MomentModel> moments=[];
    final querySnapshot= await _db.collection(COLLECTION_MOMENT).where('tourId', isEqualTo: tourId)
        .get();
    if(querySnapshot != null){
      moments=querySnapshot.docs.map((document) => MomentModel.fromMap(document.data())).toList();
      return moments;
    }
  }
static Future<List<ExpenseModel>> getExpenseListFromDB(String tourId) async {
    List<ExpenseModel> expenses=[];
    final querySnapshot= await _db.collection(COLLECTION_EXPENSE).where('tourId', isEqualTo: tourId)
    .get();
    if(querySnapshot != null){
      expenses=querySnapshot.docs.map((document) => ExpenseModel.fromMap(document.data())).toList();
      return expenses;
    }
}

  static Future<TourModel> getTourById(String id) async{
    final snapshot=await _db.collection(COLLECTION_TOUR).doc(id).get();
    return TourModel.fromMap(snapshot.data());
  }
  static Future deleteTour(String id) async{
    await _db.collection(COLLECTION_TOUR).doc(id).delete();
  }
}