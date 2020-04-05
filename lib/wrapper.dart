import 'package:ssc_401/shared/mylib.dart';
import 'package:ssc_401/screens/home/home.dart';
import 'package:provider/provider.dart';
import 'package:ssc_401/screens/authetication/main_sign_in.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    // return either the Home or Authenticate widget
    if (user == null) {
      return SignIn();
    } else {
      return
        HomePage();
    }
  }
}

