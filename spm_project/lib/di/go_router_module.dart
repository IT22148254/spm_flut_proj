import 'package:injectable/injectable.dart';
import 'package:go_router/go_router.dart';
import 'package:spm_project/core/services/route_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

@module
abstract class GoRouterModule {
  @lazySingleton
  GoRouter get goRouter => GoRouter(
        redirect: (context, state) {
          final User? user = FirebaseAuth.instance.currentUser;
          final isLoggingIn = state.fullPath == '/login';

          if (user == null && !isLoggingIn) {
            // Redirect to login if user is not authenticated and not on login page
            return '/login';
          }
          if (user != null && isLoggingIn) {
            // this is for debugging purposes
            //todo : /rooms should be / for the home page
            return '/rooms';
          }

          return null;
        },
        routes: [
          ...appRoutes,
        ],
      );
}
