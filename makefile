xcode:
	open ios/Runner.xcworkspace

built_value_build:
	flutter packages pub run build_runner build --delete-conflicting-outputs

built_value_watch:
	flutter packages pub run build_runner watch --delete-conflicting-outputs

# iOS
mock_ios:
	flutter build ios -t lib/main_mock.dart

prod_ios:
	flutter build ios -t lib/main_prod.dart

install_ios_dev:
	flutter build ios -t lib/main_dev.dart && flutter install -d 00008020-001454EC14D2002E

install_ios_mock:
	make mock_ios && flutter install -d 00008020-001454EC14D2002E

install_ios_prod:
	make prod_ios && flutter install -d 00008020-001454EC14D2002E

# Android
mock_android:
	flutter build apk -t lib/main_mock.dart

prod_android:
	flutter build apk -t lib/main_prod.dart

install_android_dev:
	flutter build apk -t lib/main_dev.dart && flutter install -d 2a71eab236027ece

install_android_mock:
	make mock_android && flutter install -d 2a71eab236027ece

install_android_prod:
	make prod_android && flutter install -d 2a71eab236027ece
