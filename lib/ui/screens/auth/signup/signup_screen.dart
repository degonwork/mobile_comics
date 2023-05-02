import 'package:flutter/material.dart';
import '../../../../config/size_config.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});
  static const String routeName = '/signup';

  static MaterialPage page() {
    return const MaterialPage(
      child: SignUpForm(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const SignUpForm();
  }
}

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  bool passToggle = true;
  // final ValidationBloc _validationBloc = ValidationBloc();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.yellow,
                Colors.cyan,
                Colors.indigo,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          padding: EdgeInsets.only(
            top: SizeConfig.screenHeight / 37.8,
            left: SizeConfig.screenWidth / 24,
            right: SizeConfig.screenWidth / 24,
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                SizedBox(
                  // margin: const EdgeInsets.only(top: 20),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                        onPressed: () {
                          // navigatorKey.currentState!.pop(context);
                        },
                        child: const Text(
                          'Quay lại',
                          style: TextStyle(fontSize: 20),
                        )),
                  ),
                ),
                const Center(
                  child: Text(
                    'Đăng ký',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: SizeConfig.screenHeight / 37.8,
                ),
                SizedBox(
                  width: SizeConfig.screenWidth / 3.6,
                  height: SizeConfig.screenHeight / 7.56,
                  child: Image.asset('assets/vo_luyen_dinh_phong/unnamed.png'),
                ),
                SizedBox(
                  height: SizeConfig.screenHeight / 30.24,
                ),
                Form(
                  key: _formKey2,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(
                        //       horizontal: 10, vertical: 15),
                        //   child: TextFormField(
                        //     autovalidateMode:
                        //         AutovalidateMode.onUserInteraction,
                        //     textInputAction: TextInputAction.next,
                        //     validator: (value) {
                        //       if (value!.isEmpty) {
                        //         return "Tên đăng nhập phải có ít nhất 6 ký tự";
                        //       }
                        //       return null;
                        //     },
                        //     controller: userName,
                        //     decoration: InputDecoration(
                        //         prefixIcon: const Icon(
                        //           Icons.person,
                        //           color: Colors.black,
                        //         ),
                        //         hintText: 'Tên đăng nhập',
                        //         border: OutlineInputBorder(
                        //             borderRadius: BorderRadius.circular(20))),
                        //   ),
                        // ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.screenWidth / 36,
                            vertical: SizeConfig.screenHeight / 50.4,
                          ),
                          child: TextFormField(
                            // onChanged:
                            // context.read<SignUpCubit>().onEmailChanged,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Vui lòng điền email của bạn";
                              }
                              return null;
                            },
                            controller: email,
                            decoration: InputDecoration(
                                // errorText: snapshot.hasError
                                //     ? snapshot.error.toString()
                                //     : null,
                                prefixIcon: const Icon(
                                  Icons.email,
                                  color: Colors.black,
                                ),
                                hintText: 'Email',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20))),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.screenWidth / 36,
                            vertical: SizeConfig.screenHeight / 50.4,
                          ),
                          child: TextFormField(
                            // onChanged:
                            //     context.read<SignUpCubit>().onPasswordChanged,
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
                              // errorText: snapshot.hasError
                              //     ? snapshot.error.toString()
                              //     : null,
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
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.screenWidth / 36,
                            vertical: SizeConfig.screenHeight / 50.4,
                          ),
                          child: TextFormField(
                            // onChanged: context.read<SignUpCubit>().onPasswordChanged,
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
                            controller: confirmPassword,
                            decoration: InputDecoration(
                                // errorText: snapshot.hasError
                                //     ? snapshot.error.toString()
                                //     : null,
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
                                hintText: 'Nhập lại mật khẩu',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                )),
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.screenHeight / 25.2,
                        ),
                        // CustomButton(
                        //   onPressed: () {
                        //     if (_formKey2.currentState!.validate()) {
                        //     context
                        //         .read<SignUpCubit>()
                        //         .onSignUpEmailAndPassword();
                        //     }
                        //   },
                        //   text: "Đăng ký",
                        // ),
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
