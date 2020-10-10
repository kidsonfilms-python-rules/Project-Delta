import 'package:get_it/get_it.dart';
import 'package:project_delta/services/push_notification.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => PushNotificationService());
}