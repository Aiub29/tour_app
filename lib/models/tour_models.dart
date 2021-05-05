class TourModel {
  String id;
  String tourName;
  String destination;
  double budget;
  int startDate;
  bool isCompleted;

  TourModel(
      {this.id,
      this.tourName,
      this.destination,
      this.budget,
      this.startDate,
      this.isCompleted=false});

  Map<String,dynamic> toMap(){
    var map = <String,dynamic>{
      'id' : id,
      'name' : tourName,
      'destination' : destination,
      'budget' : budget,
      'startDate' : startDate,
      'completed' : isCompleted,
    };
    return map;
  }


  TourModel.fromMap(Map<String,dynamic> map){
    id =map['id'];
    tourName =map['name'];
    destination =map['destination'];
    budget =map['budget'];
    startDate =map['startDate'];
    isCompleted =map['completed'];
  }

  @override
  String toString() {
    return 'TourModel{id: $id, tourName: $tourName, destination: $destination, budget: $budget, startDate: $startDate, isCompleted: $isCompleted}';
  }
}

