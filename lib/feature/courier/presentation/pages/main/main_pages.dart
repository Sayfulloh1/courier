import 'package:courier_app/feature/courier/presentation/pages/main/completed_orders/completed_orders_page.dart';
import 'package:courier_app/feature/courier/presentation/pages/main/new_orders/new_orders_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyPages extends StatefulWidget {
  const MyPages({super.key});

  @override
  State<MyPages> createState() => _MyPagesState();
}

class _MyPagesState extends State<MyPages> {
  late PageController controller;
  var selected = 0;

  @override
  void initState() {
    super.initState();
    controller = PageController();
    controller.addListener(() {
      setState(() {
        selected = controller.page!.round();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: PageView(
        controller: controller,
        onPageChanged: (index) {
          setState(() {
            selected = index;
          });
        },
        children: const [
          NewOrdersPage(),
          CompletedOrdersPage(),

        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        showSelectedLabels: true,
        selectedItemColor: Colors.blue,
        currentIndex: selected,
        selectedLabelStyle: TextStyle(fontSize: screenHeight / 50),
        unselectedLabelStyle: TextStyle(fontSize: screenHeight / 50),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            selected = index;
            controller.animateToPage(index,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeIn);
          });
        },
        items: [
          BottomNavigationBarItem(
              activeIcon: SvgPicture.asset('assets/images/active_new.svg'),
              icon: SvgPicture.asset('assets/images/icon_new.svg'),
              label: 'Новые заказы'),
          const BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month), label: 'Завершенные'),


          //BottomNavigationBarItem(icon: Icon(Icons.person),label: ''),
        ],
      ),
    );
  }
}
