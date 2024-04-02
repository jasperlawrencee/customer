import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer/components/assets_strings.dart';
import 'package:customer/components/constants.dart';
import 'package:customer/components/widgets.dart';
import 'package:customer/screens/Homescreen/Homescreen.dart';
import 'package:customer/screens/Homescreen/MainScreen.dart';
import 'package:customer/screens/WelcomeScreen/CustWelcomeScreen.dart';
import 'package:customer/screens/customerProfile/custprofile.dart';
import 'package:customer/screens/customerProfile/editProfile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  User? _user;
  String currUserEmail = '';
  String currUserID = '';

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        _user = user;
        currUserEmail = _user!.email!;
        currUserID = _user!.uid;
      });
    });
  }

  Future<String> getUsername() async {
    DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(currUserID)
        .get();

    return userDoc.data()!['Username'];
  }

  void signUserOut() {
    FirebaseAuth.instance.signOut();
    Navigator.push(context,
        MaterialPageRoute(builder: ((context) => const CustWelcome())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: kPrimaryColor,
          leading: IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => const CustHome())));
              },
              icon: const Icon(LineIcons.angleLeft)),
          title: const Text(
            'My Profile',
          ),
        ),
        body: SingleChildScrollView(
            child: Container(
          padding: EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(150),
                  child: const Image(image: AssetImage(DefaultProfilePic)),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              StreamBuilder(
                  stream: Stream.fromFuture(getUsername()),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Text(
                        'No username',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.red,
                            fontWeight: FontWeight.w700),
                      );
                    } else {
                      String username = snapshot.data!;
                      return Text(
                        username,
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black87,
                            fontWeight: FontWeight.w700),
                      );
                    }
                  }),

              Text(
                _user != null ? currUserEmail : 'No user found',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                  width: 200,
                  child: elevButton(
                      title: 'Edit Profile',
                      onClicked: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => EditProfile())));
                        //separate page na dapat na naga fetch ug data from db
                      })),
              SizedBox(
                height: 30,
              ),
              Divider(),
              SizedBox(
                height: 10,
              ),
              //Menu
              ProfileMenuWidget(
                title: 'My Addresses',
                icon: LineIcons.locationArrow,
                onPress: () {},
              ),
              ProfileMenuWidget(
                title: 'Settings',
                icon: LineIcons.cog,
                onPress: () {},
              ),
              ProfileMenuWidget(
                title: 'Billing Details',
                icon: LineIcons.wallet,
                onPress: () {},
              ),
              ProfileMenuWidget(
                title: 'Booking Transactions',
                icon: LineIcons.calendar,
                onPress: () {},
              ),
              Divider(),
              SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: kPrimaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20)),
                child: ProfileMenuWidget(
                  title: 'Logout',
                  icon: LineIcons.alternateSignOut,
                  endIcon: false,
                  onPress: signUserOut,
                ),
              ),
            ],
          ),
        )));
  }
}

class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
  });

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
      leading: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: kPrimaryColor.withOpacity(0.1),
        ),
        child: Icon(
          icon,
          color: kPrimaryColor,
        ),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyMedium?.apply(color: textColor),
      ),
      trailing: endIcon
          ? Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: kPrimaryColor.withOpacity(0.1)),
              child: const Icon(LineIcons.angleRight,
                  size: 18, color: kPrimaryColor),
            )
          : null,
    );
  }
}
