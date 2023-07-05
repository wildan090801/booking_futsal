import 'package:booking_futsal/cloud_firestore/user_ref.dart';
import 'package:booking_futsal/ui/screens/home_screen.dart';
import 'package:booking_futsal/utils/theme.dart';
import 'package:booking_futsal/widgets/scroll_behavior_without_glow.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class MainScreen extends ConsumerWidget {
  MainScreen({super.key});

  final _auth = FirebaseAuth.instance;
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  final Uri whatsApp = Uri.parse('https://wa.me/6281910003162');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        key: _globalKey,
        drawer: Drawer(
          child: FutureBuilder(
            future: getUserProfiles(ref, _auth.currentUser!.email),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasData) {
                var userModel = snapshot.data!;
                return Column(
                  children: [
                    UserAccountsDrawerHeader(
                      currentAccountPicture: const CircleAvatar(
                        backgroundImage:
                            AssetImage('assets/images/logo_haphap.png'),
                      ),
                      accountName: Text(userModel.name!),
                      accountEmail: Text(userModel.email!),
                    ),
                    ListTile(
                      leading: const Icon(Icons.info),
                      title: const Text('Informasi'),
                      onTap: () {
                        Navigator.pushNamed(context, '/information');
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.history),
                      title: const Text('Riwayat Booking'),
                      onTap: () {
                        Navigator.pushNamed(context, '/customer-history');
                      },
                    ),
                    ListTile(
                      onTap: (() async {
                        launchUrl(
                            Uri.parse(
                                'https://api.whatsapp.com/send/?phone=6287784768841'),
                            mode: LaunchMode.externalNonBrowserApplication);
                      }),
                      leading: const Icon(Icons.call),
                      title: const Text('WhatsApp'),
                    ),
                    ListTile(
                      onTap: () async {
                        final navigator = Navigator.of(context);
                        await _auth.signOut();
                        navigator.pushReplacementNamed('/sign-in');
                      },
                      leading: const Icon(Icons.logout),
                      title: const Text('Keluar'),
                      iconColor: Colors.red,
                      textColor: Colors.red,
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return const Text('Data tidak tersedia');
              }
            },
          ),
        ),
        body: Stack(
          children: [
            ScrollConfiguration(
              behavior: ScrollBehaviorWithoutGlow(),
              child: ListView(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          _globalKey.currentState!.openDrawer();
                        },
                        icon: const Icon(Icons.menu),
                      ),
                      Text(
                        'Hap Hap Sports',
                        style: blackTextStyle.copyWith(
                          fontSize: 20,
                          fontWeight: semiBold,
                        ),
                      ),
                      Hero(
                        tag: 'logo',
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          child: const CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/images/logo_haphap.png'),
                            radius: 25,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Divider(color: greyColor, thickness: 0.8),
                  const HomeScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
