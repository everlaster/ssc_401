class User {
  final String uid;
  User({ this.uid });
}

class MyPoints{
  final int totalPoints;
  MyPoints(this.totalPoints);
}

class UserHistory{
  final double binCapacity;
  final String location;
  final int points;
  final bool   recyclable;
  final String time;
  final String type;
  final String userID;
  final int weight;
  UserHistory({this.binCapacity, this.location, this.points, this.recyclable,
    this.time, this.type, this.userID, this.weight});
}

class RewardDetails{
  final String url;
  final String description;
  final String company;
  final int points;
  final int staffCode;

  RewardDetails({
    this.url,
    this.description,
    this.company,
    this.points,
    this.staffCode
  });
}

class VoucherDetails{
  final String url;
  final String description;
  final String company;
  final int staffCode;
  final String id;
  final bool isUsed;

  VoucherDetails({
    this.url,
    this.description,
    this.company,
    this.staffCode,
    this.id,
    this.isUsed
  });
}