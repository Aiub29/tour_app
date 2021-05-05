class ExpenseModel{
  String expenseId;
  String tourId;
  String expenseName;
  int expenseDate;
  double expenseAmount;

  ExpenseModel(
      {this.expenseId,
      this.tourId,
      this.expenseName,
      this.expenseDate,
      this.expenseAmount});
  Map<String,dynamic> toMap(){
    var map= <String,dynamic>{
      'expenseId' :expenseId,
      'tourId' :tourId,
      'expenseName' :expenseName,
      'expenseDate' :expenseDate,
      'expenseAmount' :expenseAmount,
    };
    return map;
    }

    ExpenseModel.fromMap(Map<String,dynamic> map){
    tourId=map['tourId'];
    expenseId=map['expenseId'];
    expenseName=map['expenseName'];
    expenseDate=map['expenseDate'];
    expenseAmount=map['expenseAmount'];

    }

  @override
  String toString() {
    return 'ExpenseModel{expenseId: $expenseId, tourId: $tourId, expenseName: $expenseName, expenseDate: $expenseDate, expenseAmount: $expenseAmount}';
  }
}




