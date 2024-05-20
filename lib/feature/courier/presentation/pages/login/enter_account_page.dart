import 'package:courier_app/feature/courier/data/repositories/courier_repository_impl.dart';
import 'package:courier_app/feature/courier/presentation/pages/main/main_pages.dart';
import 'package:courier_app/feature/courier/presentation/pages/main/new_orders/new_orders_page.dart';
import 'package:courier_app/feature/courier/presentation/resources/values_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EnterAccountPage extends StatefulWidget {
  const EnterAccountPage({super.key});

  @override
  State<EnterAccountPage> createState() => _EnterAccountPageState();
}

class _EnterAccountPageState extends State<EnterAccountPage> {
  bool isFocus = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  courierLogin()async{
    CourierRepositoryImpl repository = CourierRepositoryImpl();
    var result  = await repository.loginWithEmailAndPassword(emailController.text, passwordController.text);
    result.fold((left) {
      return ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error occured $left")));
    }, (right) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Courier login successfully")));
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const MyPages()));
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(CupertinoIcons.left_chevron),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width(context) * .05),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: height(context) * .05,
              ),
              const Text(
                'Вход в аккаунт',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter',
                ),
              ),
              const Text(
                'Войдите в свой аккаунт чтобы работать',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter',
                    color: Colors.grey),
              ),
              SizedBox(
                height: height(context) * .05,
              ),
              const Text(
                'Почта',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter',
                  color: Colors.black,
                ),
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'Введите электронную почту',
                  fillColor: const Color(0xff0074EB).withOpacity(.05),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      width(context) * .02,
                    ),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(width(context) * .02),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(width(context) * .02),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(width(context) * .02),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                ),
              ),
              SizedBox(
                height: height(context) * .02,
              ),
              const Text(
                'Пароль',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter',
                  color: Colors.black,
                ),
              ),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  hintText: 'Введите  пароль',
                  fillColor: const Color(0xff0074EB).withOpacity(.05),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      width(context) * .02,
                    ),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(width(context) * .02),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(width(context) * .02),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(width(context) * .02),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                ),
              ),
              SizedBox(
                height: height(context) * .01,
              ),
             /* Row(
                children: [
                  Container(
                    width: width(context) * .05,
                    height: width(context) * .05,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: Color(0xff0074EB),
                        width: 2,
                      ),
                    ),
                    child: Checkbox(
                      activeColor: Colors.white,
                      checkColor: Color(0xff0074EB),
                      onChanged: (val) {},
                      value: true,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Запомнить пароль",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w500),
                  ),
                ],
              ),*/
              /*    Container(
                width: getWidth(context),
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Забыли пароль',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                      color: Color(0xff0074EB),
                    ),
                  ),
                ),
              ),*/
              SizedBox(
                height: height(context) * .05,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff0074EB),
                  foregroundColor: const Color(0xff98A2B3).withOpacity(.01),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  minimumSize: Size(width(context), height(context) * .08),
                ),
                onPressed: () {
                  courierLogin();
          
                },
                child: const Text(
                  'Продолжить',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
