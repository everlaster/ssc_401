import 'package:ssc_401/shared/mylib.dart';

double _radiusDim = 10.0;

Widget createWhatsNewCard(context) {
  List<RewardDetails> rewardList = Provider.of<List<RewardDetails>>(context);
  return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FittedBox(
          child: Material(
              color: Colors.white,
              elevation: 14.0,
              borderRadius: BorderRadius.circular(_radiusDim),
              shadowColor: Color(0x802196F3),
              child: Column(
                children: <Widget>[
                  Container(
                    height: 32.0,
                    width: 316,
                    child: DecoratedBox(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'What\'s New',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Theme.of(context).primaryColor,
                          borderRadius: new BorderRadius.only(
                              topRight: Radius.circular(_radiusDim),
                              topLeft: Radius.circular(_radiusDim))),
                    ),
                  ),
                  Container(
                      height: 120,
                      width: 316,
                      child:
                          CarouselSlider(
                        initialPage: 0,
                        viewportFraction: 1.0,
                        autoPlay: true,
                        reverse: false,
                        enableInfiniteScroll: true,
                        autoPlayInterval: Duration(seconds: 6),
                        autoPlayAnimationDuration:
                            Duration(milliseconds: 6000),
                        pauseAutoPlayOnTouch: Duration(seconds: 2),
                        scrollDirection: Axis.horizontal,
                        items: rewardList.map((reward) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                height: double.infinity,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                ),
                                child: Image.network(
                                  reward.url,
                                  fit: BoxFit.fill,
                                ),
                              );
                            },
                          );
                        }).toList(),
                      )),
                ],
              ))));
}

Widget createQrCard(context) {
  final uid = Provider.of<User>(context).uid;
  return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FittedBox(
          child: Material(
              color: Colors.white,
              elevation: 14.0,
              borderRadius: BorderRadius.circular(_radiusDim),
              shadowColor: Color(0x802196F3),
              child: Column(
                children: <Widget>[
                  Container(
                    height: 32.0,
                    width: 316,
                    child: DecoratedBox(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'QR Code',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Theme.of(context).primaryColor,
                          borderRadius: new BorderRadius.only(
                              topRight: Radius.circular(_radiusDim),
                              topLeft: Radius.circular(_radiusDim))),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(50, 8.0, 50, 4.0),
                      child: QrImage(
                        data: "$uid",
                        version: QrVersions.auto,
                        size: 180.0,
                      )),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                    child: Text(
                      'Show QR code to smartbin scanner',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ))));
}

Widget createMyPointCard(context) {
  final uid = Provider.of<User>(context).uid;
  return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FittedBox(
          child: Material(
              color: Colors.white,
              elevation: 14.0,
              borderRadius: BorderRadius.circular(_radiusDim),
              shadowColor: Color(0x802196F3),
              child: Container(
                  width: 316,
                  height: 148,
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 32.0,
                        width: 316,
                        child: DecoratedBox(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'My Points',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Theme.of(context).primaryColor,
                              borderRadius: new BorderRadius.only(
                                  topRight: Radius.circular(_radiusDim),
                                  topLeft: Radius.circular(_radiusDim))),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      StreamBuilder<MyPoints>(
                          stream: DatabaseService(uid: uid).userTotalPoints,
                          builder: (context, snapshot) {
                            if (snapshot.data == null) {
                              return CircularProgressIndicator();
                            }
                            var totalPoints = snapshot.data.totalPoints;
                            return Text(
                              totalPoints.toString(),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 36),
                            );
                          }),
                      SizedBox(height: 8.0),
                      RaisedButton(
                        color: Theme.of(context).accentColor,
                        disabledColor: Theme.of(context).accentColor,
                        textColor: Colors.black,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RewardPage()));
                        },
                        child:
                            Text('Redeem Now', style: TextStyle(fontSize: 20)),
                      ),
                    ],
                  )))));
}

Widget createHistoryCard(context, historyList) {
  return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FittedBox(
          child: Material(
              color: Colors.white,
              elevation: 14.0,
              borderRadius: BorderRadius.circular(_radiusDim),
              shadowColor: Color(0x802196F3),
              child: Container(
                  height: 260,
                  width: 316,
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 32.0,
                        width: 316,
                        child: DecoratedBox(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Recent History',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Theme.of(context).primaryColor,
                              borderRadius: new BorderRadius.only(
                                  topRight: Radius.circular(_radiusDim),
                                  topLeft: Radius.circular(_radiusDim))),
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Container(
                          height: 128,
                          width: 316,
                          child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: historyList.length,
                            itemBuilder: (context, index) {
                              return tileForHistoryCard(
                                  context, historyList[index]);
                            },
                          )),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 16.0, 0, 0),
                        child: RaisedButton(
                          color: Theme.of(context).accentColor,
                          disabledColor: Theme.of(context).accentColor,
                          textColor: Colors.black,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HistoryPage()));
                          },
                          child:
                              Text('View More', style: TextStyle(fontSize: 20)),
                        ),
                      ),
                    ],
                  )))));
}

Widget tileForHistoryCard(context, item) {
  var localTime = DateTime.parse(item.time).toLocal().toString().substring(0,10);

  return Column(
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0),
        child: Row(
          children: <Widget>[
            Container(
              width: 200,
              height: 40,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Points Earned: ${item.points}',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 14.0),
                  ),
                  SizedBox(height: 2.0),
                  Text('Location: ${item.location}',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 12.0, color: Colors.grey))
                ],
              ),
            ),
            Container(
              width: 84,
              height: 40,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '$localTime',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14.0),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      Divider(color: Colors.black),
    ],
  );
}
