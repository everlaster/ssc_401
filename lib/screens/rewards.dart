import 'package:ssc_401/shared/mylib.dart';

double _radiusDim = 10.0;
final _scaffoldKey = GlobalKey<ScaffoldState>();

class RewardPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RewardPageState();
  }
}

class _RewardPageState extends State<RewardPage> {
  @override
  Widget build(BuildContext context) {
    String uid = Provider.of<User>(context).uid;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          title: Text('Rewards'),
          backgroundColor: Theme.of(context).primaryColor,
          leading: Padding(
              padding: EdgeInsets.only(left: 12),
              child: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  }))),
      body: StreamBuilder<dynamic>(
        stream: DatabaseService(uid:uid).userTotalPoints,
        builder: (context, snapshot) {
          if(snapshot.data==null){
            return Center(child: CircularProgressIndicator());
          }
          var totalPoints = snapshot.data.totalPoints;
          return Column(
            children: <Widget>[
              SizedBox(height: 8.0),
              Container(
                width: 316,
                height: 60,
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'My Points: ',
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                    Text(totalPoints.toString(), style: TextStyle(fontSize: 20.0)),
                  ],
                ),
              ),
              Divider(height: 2, color: Colors.grey),
              SizedBox(height: 8),
              Expanded(
                child: Scrollbar(child: _buildRewardList(context,totalPoints)),
              ),
            ],
          );
        }
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => VoucherPage()),
          );
        },
        label: Text('Go to Redeemed Vouchers'),
      ),
    );
  }
}

Widget _buildRewardList(context,totalPoints) {
  List<RewardDetails> rewardList = Provider.of<List<RewardDetails>>(context);
  return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: rewardList.length,
      itemBuilder: (BuildContext context, int index) {
        var company = rewardList[index].company;
        var description = rewardList[index].description;
        var points = rewardList[index].points;
        return GestureDetector(
            onTap: () {
              _showDialog(context, rewardList[index],totalPoints);
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FittedBox(
                  child: Material(
                      color: Colors.white,
                      elevation: 14.0,
                      borderRadius: BorderRadius.circular(_radiusDim),
                      shadowColor: Color(0x802196F3),
                      child: Row(
                        children: <Widget>[
                          Container(
                              width: 160,
                              height: 100,
                              child: ClipRRect(
                                  borderRadius:
                                      new BorderRadius.circular(_radiusDim),
                                  child: rewardList[index].url == null
                                      ? Center(
                                          child: CircularProgressIndicator())
                                      : Image.network(
                                          rewardList[index].url,
                                          fit: BoxFit.fill,
                                          alignment: Alignment.topRight,
                                        ))),
                          Container(
                              width: 156,
                              height: 100,
                              padding: const EdgeInsets.all(24.0),
                              child: Column(children: <Widget>[
                                Text(company, textAlign: TextAlign.left),
                                Text(description, textAlign: TextAlign.left),
                                Text(points.toString(),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor,fontWeight: FontWeight.bold )),
                              ]))
                        ],
                      ))),
            ));
      });
}

void _showDialog(context, reward, totalPoints) {
  String uid = Provider.of<User>(context).uid;
  var company = reward.company;
  var description = reward.description;
  var points = reward.points;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      if (totalPoints >= reward.points) {
        // return object of type Dialog
        return AlertDialog(
          title: Text("Confirm Redeem"),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          content: Text('$company\n$description'),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text("No"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
                child: Text('Yes'),
                onPressed: () {
                  int newPoints = totalPoints - points;
                  DatabaseService(uid:uid).updateUserTotalPoints(newPoints);
                  DatabaseService(uid:uid).addUserVoucherInfo(reward);
                  Fluttertoast.showToast(
                    msg: "$description redeemed",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                  );
                  Navigator.pop(context);
                }),
          ],
        );
      } else {
        return AlertDialog(
          title: Text("Insufficient Points"),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          actions: <Widget>[
            FlatButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      }
    },
  );
}
