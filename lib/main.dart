import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oktava/data/repository/audio_player_model_factory.dart';
import 'package:oktava/data/repository/audio_player_provider.dart';
import 'package:oktava/data/repository/local_audio_player_service.dart';
import 'package:oktava/helpers/loading/loading_screen.dart';
import 'package:oktava/services/audio-player/bloc/audio_player_bloc.dart';
import 'package:oktava/services/auth/bloc/auth_bloc.dart';
import 'package:oktava/services/auth/bloc/auth_event.dart';
import 'package:oktava/services/auth/bloc/auth_state.dart';
import 'package:oktava/services/auth/firebase_auth_provider.dart';
import 'package:oktava/utilities/widgets/navigation_drawer_widget.dart';
import 'package:oktava/views/audio_player_view.dart';
import 'package:oktava/views/forgot_password_view.dart';
import 'package:oktava/views/login_view.dart';
import 'package:oktava/views/register_view.dart';
import 'package:oktava/views/verify_email_view.dart';

void main() {
  AssetsAudioPlayer.setupNotificationsOpenAction((notification) {
    print(notification.audioId);
    return true;
  });

  runApp(
    MaterialApp(
      home: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<AudioPlayerProvider>(
            create: (context) => LocalAudioPlayerService(
                audioPlayerModels: AudioPlayerModelFactory.getAudioModels()),
          ),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider<AuthBloc>(
              create: (context) => AuthBloc(FirebaseAuthProvider()),
            ),
            BlocProvider<AudioPlayerBloc>(
              create: (context) => AudioPlayerBloc(
                  assetsAudioPlayer: AssetsAudioPlayer.newPlayer(),
                  audioPlayerProvider:
                      RepositoryProvider.of<AudioPlayerProvider>(context)),
            )
          ],
          child: const HomePage(),
        ),
      ),
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(
              context: context,
              text: state.loadingText ?? 'Please wait a moment');
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const MainScreen();
        } else if (state is AuthStateNeedsVerification) {
          return const VerifyEmailView();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else if (state is AuthStateForgotPassword) {
          return const ForgotPasswordView();
        } else if (state is AuthStateRegistering) {
          return const RegisterView();
        }
        {
          return const Scaffold(
            body: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const NavigationDrawerWidget(),
        appBar: AppBar(
          elevation: 0,
          leading: Builder(builder: (context) {
            return IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Color.fromARGB(255, 73, 73, 73),
              ),
            );
          }),
          centerTitle: true,
          title: const Text(
            "OKTAVA",
            style: TextStyle(
              color: Color.fromARGB(255, 73, 73, 73),
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 145, 245, 230),
        ),
        body: const AudioPlayerView());
  }
}
