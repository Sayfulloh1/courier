import 'package:flutter/material.dart';

import '../../../../data/repositories/courier_repository_impl.dart';
import '../../../resources/values_manager.dart';

class CompletedOrdersPage extends StatefulWidget {
  const CompletedOrdersPage({super.key});

  @override
  State<CompletedOrdersPage> createState() => _CompletedOrdersPageState();
}

class _CompletedOrdersPageState extends State<CompletedOrdersPage> {

  List<Map<String, dynamic>> completedOrders = [];


  Future<void> fetchAllCompletedOrders() async {
    CourierRepositoryImpl repository = CourierRepositoryImpl();

    var result = await repository.getAllCompletedOrders();
    result.fold((left) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error occurred: $left")));
    }, (right) {
      setState(() {
        completedOrders = right;
      });
    });
  }

  @override
  void initState() {
    fetchAllCompletedOrders();
    super.initState();
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

      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * .03, vertical: 20),
        child: ListView.builder(
          itemBuilder: (context, index) {
            var order = completedOrders[index];
            return GestureDetector(
              onTap: () {

              },
              child: Container(
                margin: EdgeInsets.only(top: 12),
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
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        ListTile(
                          leading: Container(
                              width: 20,
                              height: 20,
                              child: Image.asset('assets/images/person.png')),
                          title: Text(order['client_first_name'] +
                              ' ' +
                              order['client_last_name']),
                        ),

                        ListTile(
                          leading: Container(
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
          itemCount: completedOrders.length,
          physics: ScrollPhysics(),
        ),
      ),
    );
  }
}
