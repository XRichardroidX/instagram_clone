import 'dart:typed_data';

import 'package:instagram/utilities/colors.dart';
import 'package:instagram/widget/text_field_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../resources/auth_method.dart';
import 'package:image_picker/image_picker.dart';
import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/web_screen_layout.dart';
import '../utilities/utils.dart';
import 'login.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose(){
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  void selectImageWithCamera() async {
    Uint8List im = await pickImage(ImageSource.camera);
    setState((){
      _image = im;
    });
  }
  void selectImageWithGallery() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState((){
      _image = im;
    });
  }

  void signUpUser() async {
    setState((){
      _isLoading = true;
    });
      String res = await AuthMethods().signupUser(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
        bio: _bioController.text,
        file: _image!,
      );
         setState((){
             _isLoading = false;
         });
      if(res != 'success'){
        showSnackBar(res ,context);
      }
      else{
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => ResponsiveLayout(
              mobileScreenLayout: MobileScreenLayout(),
              webScreenLayout: WebScreenLayout(),
            ),
          ),
        );
      }
  }

  void navigateToLogin(){
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const LoginScreen(),),);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Flexible(
                  child: Container(), flex: 2
              ),
              //   SVG image
              SvgPicture.asset(
                'assets/ic_instagram.svg',
                color: primaryColor,
                height: 64,
              ),
              Flexible(
                  child: Container(), flex: 1
              ),

                  Stack(
                    children: <Widget>[
                      _image != null ?
                      CircleAvatar(
                            radius: 58,
                            backgroundImage: MemoryImage(_image!),
                          )
                    : const CircleAvatar(
                      radius: 58,
                      backgroundImage: NetworkImage(
                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR5x4WvEaZ3xMfEabrEaxND9kL0jYbKEU-BJw&usqp=CAU"
                      ),
                    ),
                      Positioned(
                        bottom: -15,
                        right: -5,
                        child: IconButton(
                          onPressed: (){
                            showModalBottomSheet(
                                context: context,
                                builder: ((builder) => bottonSheet()),
                            );
                          },
                          icon: Icon(Icons.add_a_photo,
                            //  color: Colors.white
                          ),
                        ),
                      ),
              ],
    ),
              Flexible(
                  child: Container(), flex: 2
              ),
              // TextField for user name
              TextFieldInput(
                hintText: 'Enter your username',
                textInputType: TextInputType.text,
                textEditingController: _usernameController,
              ),
              Flexible(
                  child: Container(), flex: 2
              ),
              TextFieldInput(
                hintText: 'Enter your bio',
                textInputType: TextInputType.text,
                textEditingController: _bioController,
              ),
              Flexible(
                  child: Container(), flex: 2
              ),
              // textfield input your E-mail
              TextFieldInput(
                hintText: 'Enter your email',
                textInputType: TextInputType.emailAddress,
                textEditingController: _emailController,
              ),
              Flexible(
                  child: Container(), flex: 2
              ),
              // textfield input your password
              TextFieldInput(
                hintText: 'Enter your password',
                textInputType: TextInputType.text,
                textEditingController: _passwordController,
                isPass: true,
              ),
              Flexible(
                  child: Container(), flex: 2
              ),
              // Button login
              InkWell(
                onTap: signUpUser,
                child: Container(
                  child: _isLoading ? Center(
                    child: const CircularProgressIndicator(
                      color: primaryColor,
                    ),
                  ): const Text('Signup'),
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(50),
                      ),
                    ),
                    color: Colors.blue,
                  ),
                ),
              ),
              Flexible(
                  child: Container(), flex: 2
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {

                    },
                    child: Container(
                      child: const Text("have an account?"),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: navigateToLogin,
                    child: Container(
                      child: const Text(
                        "Log in",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget bottonSheet() {
    SignupScreen signupScreen = SignupScreen();
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            "Choose Profile photo",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                OutlinedButton.icon(
                    onPressed: (){
                    selectImageWithCamera();
                    },
                    icon: Icon(Icons.camera),
                    label: Text("Camera"),
                ),
                OutlinedButton.icon(
                  onPressed: (){
                    selectImageWithGallery();
                  },
                  icon: Icon(Icons.image),
                  label: Text("Gallery"),
                ),
                ]
          )
        ],
      ),
    );
  }
}
