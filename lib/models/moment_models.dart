class MomentModel{
  String momentId;
  String tourId;
  String momentName;
  String localImagePath;
  String imageDownloadUrl;
  MomentModel(
      {this.momentId,
        this.tourId,
      this.momentName,
      this.localImagePath,
      this.imageDownloadUrl});

  Map<String,dynamic> toMap(){
    var map=<String,dynamic>{
      'momentId' : momentId,
      'tourId' : tourId,
      'name' :momentName,
      'localPath' :localImagePath,
      'url' : imageDownloadUrl,
    };
    return map;
  }
  MomentModel.fromMap(Map<String,dynamic> map){
    momentId=map['momentId'];
    tourId=map['tourId'];
    momentName=map['name'];
    localImagePath=map['localPath'];
    imageDownloadUrl=map['url'];
   }

  @override
  String toString() {
    return 'MomentModel{momentId: $momentId, tourId: $tourId, momentName: $momentName, localImagePath: $localImagePath, imageDownloadUrl: $imageDownloadUrl}';
  }
}