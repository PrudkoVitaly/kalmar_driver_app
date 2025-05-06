import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kalmar_driver_app/presentation/bloc/auth/auth_bloc.dart';
import 'package:kalmar_driver_app/presentation/bloc/auth/auth_state.dart';
import 'package:kalmar_driver_app/data/repositories/auth_repository_impl.dart';
import 'presentation/pages/auth/login_page.dart';
import 'package:kalmar_driver_app/core/init/app_init.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppInit.init();
  
  final firebaseMessaging = FirebaseMessaging.instance;
  await firebaseMessaging.requestPermission();
  

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(authRepository: AuthRepositoryImpl()),
        ),
        // Другие BLoC-и при необходимости
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kalmar Driver App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // !!! Оборачиваем builder — теперь context "видит" BlocProvider выше
      builder: (context, child) {
        return BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            // здесь можно слушать изменения (если нужно)
          },
          child: LoginPage(),
        );
      },
    );
  }
}
