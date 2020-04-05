import 'package:ssc_401/shared/mylib.dart';

double _radiusDim = 10.0;

class VoucherPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _VoucherPageState();
  }
}

class _VoucherPageState extends State<VoucherPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('My Vouchers'),
            backgroundColor: Theme.of(context).primaryColor,
            leading: Padding(
                padding: EdgeInsets.only(left: 12),
                child: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    }))),
        body: DefaultTabController(
          length: 2,
          child: Column(
            children: <Widget>[
              SizedBox(height: 8.0),
              Container(
                constraints: BoxConstraints.expand(height: 50),
                child: TabBar(
                  labelColor: Colors.black,
                  tabs: [
                    Tab(text: ('Avaliable Vouchers')),
                    Tab(text: ('Used vouchers'))
                  ],
                ),
              ),
              SizedBox(height: 8.0),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildVoucherList(context, false),
                    _buildVoucherList(context, true),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

Widget _buildVoucherList(context, isUsed) {
  final uid = Provider.of<User>(context).uid;
//  List<VoucherDetails> voucherList = Provider.of<List<VoucherDetails>>(context);
  return StreamBuilder<List<VoucherDetails>>(
      stream: DatabaseService(uid: uid).voucherDetails,
      builder: (context, snapshot) {
        List<VoucherDetails> voucherList = snapshot.data;
        if (voucherList == null) {
          return Center(child: CircularProgressIndicator());
        }
        if (isUsed == false) {
          voucherList = voucherList.where((item) => item.isUsed == false).toList();
          return ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: voucherList.length,
              itemBuilder: (BuildContext context, int index) {
                var company = voucherList[index].company;
                var description = voucherList[index].description;
                return GestureDetector(
                    onTap: () {
                      print("Tap detected");
                      _showDialog(context, voucherList[index]);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: FittedBox(
                          child: Material(
                              color: Colors.white,
                              elevation: 14.0,
                              borderRadius: BorderRadius.circular(_radiusDim),
                              shadowColor: Color(0x802196F3),
                              child: Stack(children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Container(
                                        width: 160,
                                        height: 100,
                                        child: ClipRRect(
                                            borderRadius:
                                                new BorderRadius.circular(
                                                    _radiusDim),
                                            child: voucherList[index].url ==
                                                    null
                                                ? Center(
                                                    child:
                                                        CircularProgressIndicator())
                                                : Image.network(
                                                    voucherList[index].url,
                                                    fit: BoxFit.fill,
                                                    alignment:
                                                        Alignment.topRight,
                                                  ))),
                                    Container(
                                        width: 156,
                                        height: 100,
                                        padding: const EdgeInsets.all(24.0),
                                        alignment: Alignment.center,
                                        child: Column(children: <Widget>[
                                          Text(company),
                                          Text(description),
                                        ]))
                                  ],
                                ),
                                Positioned(
                                    right: 10,
                                    bottom: 10,
                                    child: Text(
                                      'Use Now',
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontWeight: FontWeight.bold),
                                    ))
                              ]))),
                    ));
              });
        } else {
          voucherList = voucherList.where((item) => item.isUsed == true).toList();
          return ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: voucherList.length,
              itemBuilder: (BuildContext context, int index) {
                var company = voucherList[index].company;
                var description = voucherList[index].description;
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: FittedBox(
                      child: Material(
                          color: Colors.white,
                          elevation: 14.0,
                          borderRadius: BorderRadius.circular(_radiusDim),
                          shadowColor: Color(0x802196F3),
                          child: ColorFiltered(
                            colorFilter: ColorFilter.mode(
                                Colors.grey, BlendMode.saturation),
                            child: Row(
                              children: <Widget>[
                                Container(
                                    width: 160,
                                    height: 100,
                                    child: ClipRRect(
                                        borderRadius: new BorderRadius.only(topLeft:Radius.circular(_radiusDim),
                                            bottomLeft: Radius.circular(_radiusDim)),
                                        child: voucherList[index].url == null
                                            ? Center(
                                                child:
                                                    CircularProgressIndicator())
                                            : Image.network(
                                                voucherList[index].url,
                                                fit: BoxFit.fill,
                                                alignment: Alignment.topRight,
                                              ))),
                                Container(
                                    width: 156,
                                    height: 100,
                                    padding: const EdgeInsets.all(24.0),
                                    alignment: Alignment.center,
                                    child: Column(children: <Widget>[
                                      Text(company),
                                      Text(description),
                                    ]))
                              ],
                            ),
                          ))),
                );
              });
        }
      });
}

void _showDialog(context, voucher) {
  var uid = Provider.of<User>(context).uid;
  var stuffCode = voucher.staffCode;
  print('code is: $stuffCode');
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
          title: Text("Enter Cashier Code"),
          content: TextField(
              keyboardType: TextInputType.number,
              maxLength: 4,
              onSubmitted: (value) {
                print(value);
                if (stuffCode == int.parse(value)) {
                  Fluttertoast.showToast(
                    msg: "Voucher Successfully redeemed",
                    toastLength: Toast.LENGTH_LONG,
                  );
                  DatabaseService(uid: uid).updateUserVoucherInfo(voucher);
//            DatabaseService(uid:uid).deleteUserVoucherInfo(voucher);
                  Navigator.pop(context);
                } else {
                  Fluttertoast.showToast(
                    msg: "Invalid code",
                    toastLength: Toast.LENGTH_LONG,
                  );
                }
              }));
    },
  );
}
