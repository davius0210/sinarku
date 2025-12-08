import 'package:get/get.dart';

import '../modules/forgotpassword/bindings/forgotpassword_binding.dart';
import '../modules/forgotpassword/views/forgotpassword_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/mapscreen/bindings/mapscreen_binding.dart';
import '../modules/home/mapscreen/views/mapscreen_view.dart';
import '../modules/home/profile/bindings/profile_binding.dart';
import '../modules/home/profile/profile_kontributor/bindings/profile_kontributor_binding.dart';
import '../modules/home/profile/profile_kontributor/views/profile_kontributor_view.dart';
import '../modules/home/profile/profile_surveyor/bindings/profile_surveyor_binding.dart';
import '../modules/home/profile/profile_surveyor/views/profile_surveyor_view.dart';
import '../modules/home/profile/views/profile_view.dart';
import '../modules/home/rekamjejak/bindings/rekamjejak_binding.dart';
import '../modules/home/rekamjejak/views/rekamjejak_view.dart';
import '../modules/home/setting/bindings/setting_binding.dart';
import '../modules/home/setting/views/setting_view.dart';
import '../modules/home/syncdata/bindings/syncdata_binding.dart';
import '../modules/home/syncdata/views/syncdata_view.dart';
import '../modules/home/toponim/bindings/toponim_binding.dart';
import '../modules/home/toponim/views/toponim_view.dart';
import '../modules/home/unduh_basemap/bindings/unduh_basemap_binding.dart';
import '../modules/home/unduh_basemap/views/unduh_basemap_view.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/signup/bindings/signup_binding.dart';
import '../modules/signup/views/signup_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
      children: [
        GetPage(
          name: _Paths.TOPONIM,
          page: () => const ToponimView(),
          binding: ToponimBinding(),
        ),
        GetPage(
          name: _Paths.SYNCDATA,
          page: () => const SyncdataView(),
          binding: SyncdataBinding(),
        ),
        GetPage(
          name: _Paths.SETTING,
          page: () => const SettingView(),
          binding: SettingBinding(),
        ),
        GetPage(
          name: _Paths.REKAMJEJAK,
          page: () => const RekamjejakView(),
          binding: RekamjejakBinding(),
        ),
        GetPage(
          name: _Paths.PROFILE,
          page: () => const ProfileView(),
          binding: ProfileBinding(),
          children: [
            GetPage(
              name: _Paths.PROFILE_SURVEYOR,
              page: () => const ProfileSurveyorView(),
              binding: ProfileSurveyorBinding(),
            ),
            GetPage(
              name: _Paths.PROFILE_KONTRIBUTOR,
              page: () => const ProfileKontributorView(),
              binding: ProfileKontributorBinding(),
            ),
          ],
        ),
        GetPage(
          name: _Paths.MAPSCREEN,
          page: () => const MapscreenView(),
          binding: MapscreenBinding(),
        ),
        GetPage(
          name: _Paths.UNDUH_BASEMAP,
          page: () => const UnduhBasemapView(),
          binding: UnduhBasemapBinding(),
        ),
      ],
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.FORGOTPASSWORD,
      page: () => const ForgotpasswordView(),
      binding: ForgotpasswordBinding(),
    ),
    GetPage(
      name: _Paths.SIGNUP,
      page: () => const SignupView(),
      binding: SignupBinding(),
    ),
  ];
}
