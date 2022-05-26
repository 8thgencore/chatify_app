import 'package:chatify_app/providers/authentication_provider.dart';
import 'package:chatify_app/services/cloud_storage_service.dart';
import 'package:chatify_app/services/database_service.dart';
import 'package:chatify_app/services/media_service.dart';
import 'package:chatify_app/services/navigation_service.dart';
import 'package:chatify_app/widgets/custom_input_fileds.dart';
import 'package:chatify_app/widgets/rounded_button.dart';
import 'package:chatify_app/widgets/rounded_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late double _deviceHeight;
  late double _deviceWidth;

  PlatformFile? profileImage;

  final _registerFormKey = GlobalKey<FormState>();

  late AuthenticationProvider _auth;
  late DatabaseService _db;
  late CloudStorageService _cloudStorage;
  late NavigationService _navigation;

  String? _name;
  String? _email;
  String? _password;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthenticationProvider>(context);
    _db = GetIt.instance.get<DatabaseService>();
    _cloudStorage = GetIt.instance.get<CloudStorageService>();
    _navigation = GetIt.instance.get<NavigationService>();
    return _buildUI();
  }

  Widget _buildUI() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: _deviceWidth * 0.03,
          vertical: _deviceHeight * 0.02,
        ),
        height: _deviceHeight * 0.98,
        width: _deviceWidth * 0.97,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _profileImageField(),
            SizedBox(height: _deviceHeight * 0.04),
            _registerForm(),
            SizedBox(height: _deviceHeight * 0.04),
            _registerButton(),
            SizedBox(height: _deviceHeight * 0.02),
            _loginAccountLink(),
          ],
        ),
      ),
    );
  }

  Widget _profileImageField() {
    return GestureDetector(
      onTap: () {
        GetIt.instance.get<MediaService>().pickImageFromLibrary().then((file) {
          setState(() => profileImage = file);
        });
      },
      child: () {
        if (profileImage != null) {
          return RoundedImageFile(
            image: profileImage!,
            size: _deviceHeight * 0.15,
          );
        } else {
          return RoundedImage(
            imagePath: "https://i.pravatar.cc/150?img=12",
            size: _deviceHeight * 0.15,
          );
        }
      }(),
    );
  }

  Widget _registerForm() {
    return Container(
      height: _deviceHeight * 0.35,
      child: Form(
        key: _registerFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomTextFormField(
              onSaved: (value) {
                setState(() => _name = value);
              },
              regEx: r".{8,}",
              hintText: "Name",
              obscureText: false,
            ),
            CustomTextFormField(
              onSaved: (value) {
                setState(() => _email = value);
              },
              regEx: r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
              hintText: "Email",
              obscureText: false,
            ),
            CustomTextFormField(
              onSaved: (value) {
                setState(() => _password = value);
              },
              regEx: r".{8,}",
              hintText: "Password",
              obscureText: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _registerButton() {
    return RoundedButton(
      name: "Register",
      height: _deviceHeight * 0.065,
      width: _deviceWidth * 0.65,
      onPressed: () async {
        if (_registerFormKey.currentState!.validate() && profileImage != null) {
          _registerFormKey.currentState!.save();
          String? uid = await _auth.registerUserUsingEmailAndPassword(_email!, _password!);
          String? imageURL = await _cloudStorage.saveUserImageToStorage(uid!, profileImage!);
          await _db.createUser(uid, _email!, _name!, imageURL!);
          // _navigation.goBack();
          await _auth.logout();
          await _auth.loginUsingEmailAndPassword(_email!, _password!);
        }
      },
    );
  }

  Widget _loginAccountLink() {
    return GestureDetector(
      onTap: () => _navigation.navigateToRoute('/login'),
      child: const Text(
        'Your already have an account?',
        style: TextStyle(color: Colors.blueAccent),
      ),
    );
  }
}
