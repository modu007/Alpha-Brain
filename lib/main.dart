import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neuralcode/Bloc/AuthBloc/OtpVerficationBloc/otp_cubit.dart';
import 'package:neuralcode/Bloc/AuthBloc/RegisterBloc/register_bloc.dart';
import 'package:neuralcode/Bloc/AuthBloc/SignInBloc/sign_in_bloc.dart';
import 'Bloc/HomeBloc/home_bloc.dart';
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
        BlocProvider<RegisterBloc>(
            create: (BuildContext context) =>RegisterBloc()),
        BlocProvider<SignInBloc>(
            create: (BuildContext context) =>SignInBloc()),
        BlocProvider<OtpCubit>(
            create: (BuildContext context) =>OtpCubit()),
      ],
      child: MaterialApp(
        initialRoute: RouteName.signIn,
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
