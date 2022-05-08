import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oktava/data/repository/audio_player_provider.dart';
import 'package:oktava/firebase_options.dart';
import 'package:oktava/helpers/loading/loading_screen.dart';
import 'package:oktava/services/audio-player/bloc/audio_player_bloc.dart';
import 'package:oktava/services/auth/auth_service.dart';
import 'package:oktava/services/auth/bloc/auth_bloc.dart';
import 'package:oktava/services/auth/bloc/auth_event.dart';
import 'package:oktava/services/auth/bloc/auth_state.dart';
import 'package:oktava/services/auth/firebase_auth_provider.dart';
import 'package:oktava/services/storage/firebase_storage_audio_player_service.dart';
import 'package:oktava/utilities/constants/color_constants.dart';
import 'package:oktava/utilities/widgets/custom_progress_indicator.dart';
import 'package:oktava/utilities/widgets/navigation_drawer_widget.dart';
import 'package:oktava/views/audio_player_view.dart';
import 'package:oktava/views/forgot_password_view.dart';
import 'package:oktava/views/login_view.dart';
import 'package:oktava/views/register_view.dart';
import 'package:oktava/views/verify_email_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AssetsAudioPlayer.setupNotificationsOpenAction((notification) {
    print(notification.audioId);
    return true;
  });
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiRepositoryProvider(
      providers: [
        // RepositoryProvider<AudioPlayerProvider>(
        //   create: (context) => LocalAudioPlayerService(
        //       audioPlayerModels: AudioPlayerModelFactory.getAudioModels()),
        // ),
        RepositoryProvider<AudioPlayerProvider>(
          create: (context) => FirebaseStorageAudioPlayerService(),
        )
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(create: (context) {
            return AuthBloc(FirebaseAuthProvider());
          }),
          BlocProvider<AudioPlayerBloc>(
            create: (context) => AudioPlayerBloc(
                assetsAudioPlayer: AssetsAudioPlayer.newPlayer(),
                audioPlayerProvider:
                    RepositoryProvider.of<AudioPlayerProvider>(context)),
          )
        ],
        child: MaterialApp(
          home: const HomePage(),
          theme: ThemeData(
            textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme),
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        } else if (state is AuthStateGetUser) {
          return const MainScreen();
        } else {
          return Scaffold(
              backgroundColor: additionalColor,
              body: customCircularIndicator());
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
  String get userId => AuthService.firebase().currentUser!.id;

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(AuthEventGetUser(userId));

    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      if (state is AuthStateGetUser) {
        return Scaffold(
          drawer: NavigationDrawerWidget(
            user: state.user,
          ),
          appBar: AppBar(
            elevation: 0,
            leading: Builder(builder: (context) {
              return IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: secondaryColor,
                ),
              );
            }),
            centerTitle: true,
            title: const Text(
              "OKTAVA",
              style: TextStyle(
                color: secondaryColor,
              ),
            ),
            backgroundColor: mainColor,
          ),
          body: const AudioPlayerView(),
        );
      }
      if (state is AuthStateLoggedOut) {
        return const HomePage();
      } else {
        return Scaffold(
          backgroundColor: additionalColor,
          body: customCircularIndicator(),
        );
      }
    });
  }
}
