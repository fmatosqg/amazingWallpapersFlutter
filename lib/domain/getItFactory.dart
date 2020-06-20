import 'package:get_it/get_it.dart';

import 'api/AlbumApi.dart';

GetIt locator = GetIt();

setupGetItFactory() {
  locator.registerFactory(() => AlbumApi());
}
