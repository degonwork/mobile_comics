import 'package:flutter/material.dart';
import '../../../../config/app_router.dart';
import '../../../../config/size_config.dart';
import '../signup/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const String routeName = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  bool passToggle = true;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: [
              Colors.yellow,
              Colors.cyan,
              Colors.indigo,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )),
          padding: EdgeInsets.only(
            top: SizeConfig.screenHeight / 75.6,
            left: SizeConfig.screenWidth / 24,
            right: SizeConfig.screenWidth / 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              verticalDirection: VerticalDirection.down,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // navigatorKey.currentState!.popAndPushNamed('$RootApp');
                      },
                      child: const Text(
                        'Quay lại',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      )),
                ),
                Center(
                  child: Column(
                    children: [
                      const Text(
                        'Đăng nhập ',
                        style: TextStyle(
                            fontSize: 40, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: SizeConfig.screenHeight / 75.6,
                      ),
                      SizedBox(
                        width: SizeConfig.screenHeight * 0.132,
                        height: SizeConfig.screenWidth / 3.6,
                        child: Image.asset(
                            'assets/vo_luyen_dinh_phong/unnamed.png'),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: SizeConfig.screenHeight / 75.6,
                ),
                Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.screenWidth / 36,
                            vertical: SizeConfig.screenHeight / 75.6,
                          ),
                          child: TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Vui lòng điền email của bạn";
                              }
                              return null;
                            },
                            // onChanged:
                            // context.read<LoginCubit>().onEmailChanged,
                            controller: email,
                            decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.email,
                                  color: Colors.black,
                                ),
                                hintText: 'Tên đăng nhập/Email',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20))),
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.screenHeight / 75.6,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.screenWidth / 36),
                          child: TextFormField(
                            // onChanged:
                            //     context.read<LoginCubit>().onPasswordChanged,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Mật khẩu không được để trống";
                              }
                              return null;
                            },
                            obscureText: passToggle,
                            controller: password,
                            decoration: InputDecoration(
                                suffix: InkWell(
                                  onTap: () {
                                    setState(() {
                                      passToggle = !passToggle;
                                    });
                                  },
                                  child: Icon(passToggle
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                ),
                                prefixIcon: const Icon(
                                  Icons.lock,
                                  color: Colors.black,
                                ),
                                hintText: 'Mật khẩu',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                )),
                          ),
                        ),
                        TextButton(
                            onPressed: () {},
                            child: const Text(
                              'Quên mật khẩu ?',
                              style: TextStyle(color: Colors.yellow),
                            )),
                        SizedBox(
                          height: SizeConfig.screenHeight / 75.6,
                        ),
                        // CustomButton(
                        //   onPressed: () {
                        //     if(_formKey.currentState!.validate()){
                        //     context.read<LoginCubit>().state.status ==
                        //             LoginStatus.loading
                        //         ? const CircularProgressIndicator()
                        //         : context
                        //             .read<LoginCubit>()
                        //             .onLoginWithEmailAndPasswordPressed();
                        //     _authBloc!.add(LoginEvent(
                        //         password: password.text, email: email.text));

                        //     }
                        //   },

                        //   text: 'Đăng nhập',
                        // ),
                        SizedBox(
                          height: SizeConfig.screenHeight / 37.8,
                        ),
                        const Center(child: Text('Bạn có thể đăng nhập với')),
                        SizedBox(
                          height: SizeConfig.screenHeight / 75.6,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: SizeConfig.screenWidth / 4.5,
                              height: SizeConfig.screenHeight / 9.45,
                              child: IconButton(
                                icon: Image.asset(
                                    'assets/vo_luyen_dinh_phong/google_PNG19635.png',
                                    fit: BoxFit.cover),
                                onPressed: () async {
                                  //  context.read<LoginCubit>().onLoginWithGoogle();
                                },
                              ),
                            ),
                            SizedBox(
                              width: SizeConfig.screenWidth / 36,
                            ),
                            IconButton(
                              iconSize: 50,
                              icon: const Icon(Icons.facebook_rounded),
                              onPressed: () async {
                                //  context.read<LoginCubit>().onLoginWithFacebook();
                              },
                            ),
                          ],
                        ),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Bạn chưa có tài khoản ?'),
                              SizedBox(
                                width: SizeConfig.screenWidth / 36,
                              ),
                              TextButton(
                                  onPressed: () {
                                    AppRouter.navigator(
                                        context, SignUpScreen.routeName);
                                  },
                                  child: const Text(
                                    'Đăng ký ngay',
                                    style: TextStyle(
                                      color: Colors.yellow,
                                    ),
                                  ))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
