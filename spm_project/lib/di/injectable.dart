import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:spm_project/di/injectable.config.dart';

final getit = GetIt.instance;


@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true, 
)

void configureDependency() => getit.init();

