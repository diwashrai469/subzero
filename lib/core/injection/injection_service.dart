import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:subzero/core/injection/injection_service.config.dart';

final locator = GetIt.instance;
@InjectableInit()
void setupLocator() => locator.init();
