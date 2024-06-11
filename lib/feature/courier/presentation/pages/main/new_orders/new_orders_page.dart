import 'package:courier_app/feature/courier/presentation/pages/splash/splash_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../data/repositories/courier_repository_impl.dart';
import '../../../resources/values_manager.dart';
import 'order_details_page.dart';

class NewOrdersPage extends StatefulWidget {
  const NewOrdersPage({super.key});

  @override
  State<NewOrdersPage> createState() => _NewOrdersPageState();
}

class _NewOrdersPageState extends State<NewOrdersPage> {
  List<Map<String, dynamic>> orders = [];
  bool hasNotificationOn = false;


  void refreshOrders()async {
    // Implement your logic to refresh orders here
    await fetchAllOrders();
    setState(() {

    });
  }

  Future<void> fetchAllOrders() async {
    CourierRepositoryImpl repository = CourierRepositoryImpl();

    var result = await repository.getAllCourierOrders();
    result.fold((left) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error occurred: $left")));
    }, (right) {
      setState(() {
        orders = right;
      });
    });
  }

  @override
  void initState() {
    fetchAllOrders(); // Fetch orders when the page initializes
    super.initState();
  }

  Future<void> deleteStringFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Remove the string using its key
    prefs.remove("token");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        // leading: Container(),
        centerTitle: true,
        title: const Text(
          "Новые заказы",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      drawer: Drawer(
        child: Container(
          height: height(context) * .3,
          color: Colors.grey[100],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 30),
                    color: Colors.blue,
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(
                              CupertinoIcons.profile_circled,
                              color: Colors.white,
                              size: 70,
                            ),
                            SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Erkin A.",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  "+998903901898",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: width(context) * .03),
                    child: Container(
                      margin: const EdgeInsets.only(top: 20),
                      width: width(context),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ListTile(
                          leading: const Icon(
                            Icons.notifications_none,
                            size: 30,
                            color: Colors.blue,
                          ),
                          title: const Text(
                            'Уведомления',
                            style: TextStyle(fontSize: 15),
                          ),
                          trailing: Switch(
                            activeColor: Colors.blue,
                            onChanged: (val) {
                              setState(() {
                                hasNotificationOn = !hasNotificationOn;
                              });
                            },
                            value: hasNotificationOn,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width(context) * .03),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      width: width(context) * .8,
                      child: TextButton(
                        onPressed: () async {
                          await deleteStringFromPrefs();
                          goSplash();
                        },
                        child: Row(
                          children: [
                            const Icon(
                              Icons.logout,
                              color: Colors.red,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              "Выйти с аккаунта",
                              style: TextStyle(color: Colors.red, fontSize: 16),
                            ),
                            SizedBox(
                              height: height(context) * .1,
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * .03, vertical: 20),
        child: ListView.builder(
          itemBuilder: (context, index) {
            var order = orders[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderDetailsPage(
                      orderId: order["id"],

                    ),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(top: 12),
                width: MediaQuery.of(context).size.width,
                // height: MediaQuery.of(context).size.width * .5,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: Text(
                            'ID ${order["order_id"]}'.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        ListTile(
                          leading: SizedBox(
                              width: 20,
                              height: 20,
                              child: Image.asset('assets/images/person.png')),
                          title: Text(order['client_first_name'] +
                              ' ' +
                              order['client_last_name']),
                        ),
                        ListTile(
                          leading: SizedBox(
                            width: 20,
                            height: 20,
                            child: Image.asset('assets/images/location.png'),
                          ),
                          title: Text(
                            order['delivery_addr_name'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
          itemCount: orders.length,
          physics: const ScrollPhysics(),
        ),
      ),
    );
  }

  void goSplash() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const SplashPage()));
  }
}
