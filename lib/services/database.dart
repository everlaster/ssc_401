import 'package:ssc_401/shared/mylib.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  // collection reference
  final CollectionReference userCollection =
      Firestore.instance.collection('users');

  // reward_info reference
  final CollectionReference rewardCollection =
      Firestore.instance.collection('reward_info');


  Future<void> updateUserTotalPoints(int newPoints) async {
    return await userCollection.document('$uid').updateData({
      'totalPoints': newPoints,
    });
  }
  Future<void> createUserDataForNewUser(String name) async {
     var snapshots= userCollection.document('$uid').snapshots();
     if (snapshots.isEmpty !=null){
       return await userCollection.document('$uid').setData({'name': name,
    'totalPoints': 0});
     }
  }

  Future<void> addUserVoucherInfo(RewardDetails voucher) async {
    return await userCollection
        .document('$uid')
        .collection('voucher_info')
        .add({
      'url': voucher.url,
      'description': voucher.description,
      'company': voucher.company,
      'staff_code': voucher.staffCode,
      'isUsed': false,
    });
  }
  Future<void> updateUserVoucherInfo(VoucherDetails voucher) async {
    return await userCollection
        .document('$uid')
        .collection('voucher_info').document(voucher.id)
        .updateData({
      'isUsed': true,
    });
  }

  // get total points from snapshot
  MyPoints _totalPointsFromUser(DocumentSnapshot snapshot) {
      return MyPoints(snapshot.data['totalPoints']);
  }

  //
  Stream<MyPoints> get userTotalPoints {
    return userCollection
        .document('$uid')
        .snapshots()
        .map(_totalPointsFromUser);
  }

  Stream<List<RewardDetails>> get rewardDetails {
    return rewardCollection.snapshots().map(_rewardDetailsListFromSnapshot);
  }

  List<RewardDetails> _rewardDetailsListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return RewardDetails(
        url: doc.data['url'],
        description: doc.data['description'],
        company: doc.data['company'],
        points: doc.data['points'],
        staffCode: doc.data['staff_code'],
      );
    }).toList();
  }

  // voucher list
  List<VoucherDetails> _voucherDetailsListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return VoucherDetails(
        url: doc.data['url'],
        description: doc.data['description'],
        company: doc.data['company'],
        staffCode:doc.data['staff_code'],
        id : doc.documentID,
        isUsed: doc.data['isUsed']
      );
    }).toList();
  }

  Stream<List<VoucherDetails>> get voucherDetails {
    return userCollection.document('$uid')
        .collection('voucher_info').snapshots().map(_voucherDetailsListFromSnapshot);
  }
}
