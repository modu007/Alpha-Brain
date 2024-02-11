import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neuralcode/Bloc/home_bloc.dart';

import 'Utils/Routes/route_name.dart';
import 'Utils/Routes/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(
            create: (BuildContext context) =>HomeBloc()),
      ],
      child: MaterialApp(
        initialRoute: RouteName.home,
        onGenerateRoute: Routes.generateRoute,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
      ),
    );
  }
}
