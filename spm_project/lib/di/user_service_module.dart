import 'package:spm_project/core/services/user_service.dart';
import 'package:injectable/injectable.dart';

@module 
abstract class UserServiceModule {
  @lazySingleton
  UserService get userService => UserService();
}