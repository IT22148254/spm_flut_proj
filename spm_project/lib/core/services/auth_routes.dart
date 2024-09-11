import 'package:go_router/go_router.dart';
//import 'package:spm_project/core/pages/home_page.dart';
import 'package:spm_project/core/pages/login_page.dart';
import 'package:spm_project/features/videoConference/screens/start_page.dart';

final authRoutes = [
  GoRoute(path: '/login',
  name: 'Login_page',
  builder: (context,state) => LoginPage() ),

  GoRoute(path: '/',
  name:'Home_page',
  //debugging purposes only => todo : uncomment Homepage() and remove StartPage() [imports too]
  // builder: (context,state) => const Homepage()
  builder: (context, state) => const StartPage(),
   ),


];