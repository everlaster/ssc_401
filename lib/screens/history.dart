import 'package:ssc_401/shared/mylib.dart';

class HistoryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HistoryPageState();
  }
}

class _HistoryPageState extends State<HistoryPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('History'),
          backgroundColor: Theme.of(context).primaryColor,
          leading: Padding(
              padding: EdgeInsets.only(left: 12),
              child: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  })),
        ),
        body: _buildBody(context))
    ;
  }
}

Widget _buildBody(BuildContext context) {
  final uid = Provider.of<User>(context).uid;
  String _selectedTime;
  var filteredList;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          FlatButton.icon(
              icon: Icon(Icons.filter_list),
              onPressed: () {
                showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030))
                    .then((date) {
                  _selectedTime = date.toString().substring(0,10);
                  print(_selectedTime);
                });
              },
//          color: Theme.of(context).accentColor,
              label: Text('Filter by date')),
          FlatButton(
              onPressed: () {
                _selectedTime = null;
              },
              child: Text('Reset'))
        ],
      ),
      Divider(height: 2, color: Colors.grey),
      SizedBox(height: 8.0),
      Expanded(
        child: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection('users')
                .document('$uid')
                .collection('history')
                .orderBy('time', descending: true)
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
              filteredList=historyList.where((x)=>x.time.contains(_selectedTime));
              if(_selectedTime==null){
                print("full");
              return _createHistoryList(context, historyList);}
              else {
                print('filter');
                return _createHistoryList(context, filteredList);
              }
            }),
      ),
    ],
  );
}

Widget _createHistoryList(context, transactionHistory) {
  return ListView.builder(
    scrollDirection: Axis.vertical,
    itemCount: transactionHistory.length,
    itemBuilder: (context, index) {
      final item = transactionHistory[index];
      return _itemForHistoryList(context, item);
    },
  );
}

Widget _itemForHistoryList(context, item) {
  var detailedLocalTime =
      DateTime.parse(item.time).toLocal().toString().substring(0, 19);
  var localTime = detailedLocalTime.substring(0, 10);

  return Center(
    child: Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32.0))),
                    contentPadding: EdgeInsets.only(top: 10.0, left: 10),
                    title: const Text('Transaction Details'),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          ListTile(
                            title: Text('Points Earned: ${item.points}'),
                          ),
                          ListTile(
                            title: Text('Location: ${item.location}'),
                          ),
                          ListTile(
                            title: Text(('Time: $detailedLocalTime')),
                          ),
                          ListTile(
                            title: Text('Type: ${item.type}'),
                          ),
                        ],
                      ),
                    ),
                  );
                });
          },
          child: Row(
            children: <Widget>[
              Container(
                width: 220,
                height: 54,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Points Earned: ${item.points}',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 16.0),
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
                height: 54,
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
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
