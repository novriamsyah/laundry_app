import 'package:d_info/d_info.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundry_app/config/app_assets.dart';
import 'package:laundry_app/config/app_colors.dart';
import 'package:laundry_app/config/app_sessions.dart';
import 'package:laundry_app/config/navigation.dart';
import 'package:laundry_app/data/models/response/user_model.dart';
import 'package:laundry_app/pages/auth/login_page.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  executeLogout(BuildContext context) {
    DInfo.dialogConfirmation(
      context,
      'Logout',
      'You sure want to logout?',
      textNo: 'Cancel',
    ).then((yes) {
      if (yes ?? false) {
        AppSessions.removeUser();
        AppSessions.removeBearerToken();
        Nav.replace(context, const LoginPage());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AppSessions.getUser(),
      builder: (context, snapshot) {
        if (snapshot.data == null) return DView.loadingCircle();

        UserModel user = snapshot.data!;

        return ListView(
          padding: const EdgeInsets.all(0),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 60, 30, 30),
              child: Text(
                'Account',
                style: GoogleFonts.montserrat(
                  fontSize: 24,
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 70,
                    child: AspectRatio(
                      aspectRatio: 3 / 4,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          AppAssets.profile,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  DView.spaceWidth(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Username',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      DView.spaceHeight(4),
                      Text(
                        user.username,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                      DView.spaceHeight(12),
                      const Text(
                        'Email',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      DView.spaceHeight(4),
                      Text(
                        user.email,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            DView.spaceHeight(10),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 30.0),
              onTap: () {},
              dense: true,
              horizontalTitleGap: 0,
              leading: const Icon(Icons.image),
              title: const Text('Change Profile'),
              trailing: const Icon(Icons.navigate_next),
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 30.0),
              onTap: () {},
              dense: true,
              horizontalTitleGap: 0,
              leading: const Icon(Icons.edit),
              title: const Text('Edit Account'),
              trailing: const Icon(Icons.navigate_next),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: OutlinedButton(
                onPressed: () => executeLogout(context),
                child: const Text('Logout'),
              ),
            ),
            DView.spaceHeight(30),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                'Settings',
                style: TextStyle(
                  height: 1,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 30.0),
              onTap: () {},
              dense: true,
              horizontalTitleGap: 0,
              leading: const Icon(Icons.dark_mode),
              title: const Text('Dark Mode'),
              trailing: Switch(
                activeColor: AppColors.primaryColor,
                value: false,
                onChanged: (value) {},
              ),
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 30.0),
              onTap: () {},
              dense: true,
              horizontalTitleGap: 0,
              leading: const Icon(Icons.translate),
              title: const Text('Language'),
              trailing: const Icon(Icons.navigate_next),
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 30.0),
              onTap: () {},
              dense: true,
              horizontalTitleGap: 0,
              leading: const Icon(Icons.notifications),
              title: const Text('Notification'),
              trailing: const Icon(Icons.navigate_next),
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 30.0),
              onTap: () {},
              dense: true,
              horizontalTitleGap: 0,
              leading: const Icon(Icons.feedback),
              title: const Text('Feedback'),
              trailing: const Icon(Icons.navigate_next),
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 30.0),
              onTap: () {},
              dense: true,
              horizontalTitleGap: 0,
              leading: const Icon(Icons.support_agent),
              title: const Text('Support'),
              trailing: const Icon(Icons.navigate_next),
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 30.0),
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationIcon: const Icon(
                    Icons.local_laundry_service,
                    size: 50,
                    color: AppColors.primaryColor,
                  ),
                  applicationName: 'Bob Laundry',
                  applicationVersion: 'v1.0.0',
                  children: [
                    const Text(
                      'Laundry Market App to monitor you laundry status',
                    ),
                  ],
                );
              },
              dense: true,
              horizontalTitleGap: 0,
              leading: const Icon(Icons.info),
              title: const Text('About'),
              trailing: const Icon(Icons.navigate_next),
            ),
          ],
        );
      },
    );
  }
}
