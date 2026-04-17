import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'ui/home_screen.dart';
import 'ui/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    final prefs = await SharedPreferences.getInstance();
    final bool onboardingComplete = prefs.getBool('onboarding_complete') ?? false;

    runApp(
          ProviderScope(
                  child: SolanaCopyWalletScout(onboardingComplete: onboardingComplete),
                ),
        );
}

class SolanaCopyWalletScout extends StatelessWidget {
    final bool onboardingComplete;

    const SolanaCopyWalletScout({super.key, required this.onboardingComplete});

    @override
    Widget build(BuildContext context) {
          return MaterialApp(
                  title: 'Solana CopyWallet Scout',
                  debugShowCheckedModeBanner: false,
                  theme: ThemeData(
                            useMaterial3: true,
                            brightness: Brightness.dark,
                            colorSchemeSeed: Colors.greenAccent,
                            textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
                            scaffoldBackgroundColor: const Color(0xFF0D1117),
                            cardTheme: CardTheme(
                                        color: const Color(0xFF161B22),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(12),
                                                      side: const BorderSide(color: Color(0xFF30363D), width: 1),
                                                    ),
                                      ),
                          ),
                  home: onboardingComplete ? const HomeScreen() : const OnboardingScreen(),
                );
    }
}
