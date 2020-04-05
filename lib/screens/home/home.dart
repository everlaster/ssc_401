import 'package:ssc_401/shared/mylib.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }

}

class _HomePageState extends State<HomePage> {
  final AuthService _authService = AuthService();
  final FirebaseMessaging _fcm = FirebaseMessaging();

    @override
  void initState() {
    super.initState();
    _saveDeviceToken();
  }

@override
  Widget build(BuildContext context) {
  _saveDeviceToken();
    return Scaffold(
      appBar: AppBar(
        title: Text('BinPoint'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              accountName: Text("SSC-401"),
              accountEmail: Text("wsh.app.18@gmail.com"),
              currentAccountPicture: CircleAvatar(
                backgroundColor:
                    Theme.of(context).platform == TargetPlatform.iOS
                        ? Colors.blue
                        : Colors.white,
                child: Text(
                  "B",
                  style: TextStyle(fontSize: 40.0),
                ),
              ),
            ),
            ListTile(
                title: Text("Rewards/My Vouchers"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context)
                    => RewardPage()),
                  );
                }),
            ListTile(
                title: Text("History"),
//              trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HistoryPage()),
                  );
                }),
            ListTile(
                title: Text("Locate Bins"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LocationPage()),
                  );
                }
//              trailing: Icon(Icons.arrow_forward),
                ),
            ListTile(
                title: Text("Quiz"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => QuizPage()),
                  );
                }),ListTile(
                title: Text("Bin Point News @Telegram"),
                onTap: () async {
                  const url = 'https://t.me/joinchat/AAAAAFfoZ1pHeW9LEGgaDg';
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                }),
            ListTile(
                title: Text("Sign Out"),
                onTap: () async {
                  Navigator.pop(context);
                  _authService.signOut();
                  _authService.googleSignOut();
                }
                )
          ],
        ),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final uid = Provider.of<User>(context).uid;
    return Column(
      children: <Widget>[
        StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection('users')
                .document('$uid')
                .collection('history').orderBy('time', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              //just add this line
              if (snapshot.data == null) return CircularProgressIndicator();
              List<UserHistory> historyList =
                  snapshot.data.documents.map((doc) {
                return UserHistory(
                  binCapacity: doc.data['binCapacity'],
                  location: doc.data['location'],
                  points: doc.data['points'],
                  recyclable: doc.data['recyclable'],
                  time: doc.data['time'],
                  type: doc.data['type'],
                  userID: doc.data['userID'],
                  weight: doc.data['weight'],
                );
              }).toList();
              return Expanded(
                child: ListView(scrollDirection: Axis.vertical, children: <Widget>[
                createWhatsNewCard(context),
                  createQrCard(context),
                  createMyPointCard(context),
                  createHistoryCard(context, historyList),
                ]),
              );
            }),
      ],
    );
  }

  /// Get the token, save it to the database for current user
  _saveDeviceToken() async {
    // Get the current user
    final uid = Provider.of<User>(context).uid;
    // Get the token for this device
    String fcmToken = await _fcm.getToken();
    print('Token is $fcmToken');
    // Save it to Firestore
    if (fcmToken != null) {
      var tokens = Firestore.instance
          .collection('users')
          .document(uid)
          .collection('tokens')
          .document(fcmToken);
      await tokens.setData({
        'token': fcmToken,
        'createdAt': FieldValue.serverTimestamp(), // optional
      });
    }
  }
}

