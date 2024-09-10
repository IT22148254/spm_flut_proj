import 'package:injectable/injectable.dart';
import 'package:go_router/go_router.dart';
import 'package:spm_project/core/services/route_service.dart';

@module 
abstract class GoRouterModule {
  @lazySingleton
  GoRouter get goRouter => GoRouter(
  routes: [
    ...appRoutes,
  ],
); 
}