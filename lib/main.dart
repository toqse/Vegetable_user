import 'package:ecom_app2/dummy/dummyprovider.dart';
import 'package:ecom_app2/firebase_options.dart';
import 'package:ecom_app2/providers/carousal_image_provider/carousal_provider.dart';
import 'package:ecom_app2/providers/category_provider/category_provider.dart';
import 'package:ecom_app2/providers/feature_brand_provider/feature_brand_provider.dart';
import 'package:ecom_app2/providers/featured_brand_slider_provider/featured_brand_slider_provider.dart';
import 'package:ecom_app2/view/splashscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  ).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CarouselProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CategoryProvider(),
        ),
        ChangeNotifierProvider(
            create: (context) => FeaturedBrandSliderProvider2()),
        ChangeNotifierProvider(
            create: (context) => FeaturedBrandSliderProvider()),
        ChangeNotifierProvider(
          create: (context) => ProductProvider(),
        )
      ],
      child: MaterialApp(
        title: 'EasyKart',

        theme: ThemeData(
          primarySwatch: Colors.green,
          primaryColor: const Color.fromARGB(255, 19, 163, 31),
          primaryColorLight: const Color(0xFFFDE400),
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor:
                Colors.white, // Setting the cursor color for text input
          ),
        ),
        home: SplashScreen(), // Main page that shows the splash screen
        debugShowCheckedModeBanner: false, // Hides the debug banner
      ),
    );
  }
}
