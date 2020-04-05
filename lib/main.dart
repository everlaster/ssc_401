import 'package:ssc_401/screens/authetication/main_sign_in.dart';
import 'package:ssc_401/shared/mylib.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MultiProvider(
      providers: [
        StreamProvider<User>.value(
          value: AuthService().user,
        ),
        StreamProvider<List<RewardDetails>>.value(
          value: DatabaseService().rewardDetails,
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryColor: const Color(0xff05620e),
            accentColor: const Color(0xffE2AC22)),
        home: Wrapper(),
      ),
    );
  }
}
