import 'package:courier_app/feature/courier/data/repositories/courier_repository_impl.dart';
import 'package:courier_app/feature/courier/presentation/pages/main/main_pages.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../resources/values_manager.dart';

class OrderDetailsPage extends StatefulWidget {
  const OrderDetailsPage(
      {super.key, required this.orderId,});

  final String orderId;


  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  Map<String, dynamic> order = {};

  void showSuccessToast(String message) {
    FlutterToastr.show(
      message,
      context,
      backgroundColor: Colors.green,
      position: FlutterToastr.top,
    );
  }

  void showErrorToast(String message) {
    FlutterToastr.show(
      message,
      context,
      backgroundColor: Colors.red,
      position: FlutterToastr.top,
    );
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    String url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> fetchSingleOrder() async {
    CourierRepositoryImpl repository = CourierRepositoryImpl();

    var result = await repository.getSingleCourierOrder(widget.orderId);
    result.fold((left) {
      showErrorToast('Error occurred: $left');
    }, (right) {

      setState(() {
        order = right;
      });

    });
  }

  Future<void> _launchURL(String lat, String long) async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showErrorToast("Location permissions are denied");
        return Future.error('Location permissions are denied.');
      }
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    String url =
        'yandexmaps://maps.yandex.com/?rtext=${position.latitude},${position.longitude}~$lat,$long&rtt=auto';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> getDeliveryOrder() async {
    CourierRepositoryImpl repository = CourierRepositoryImpl();
    var result = await repository.pickDeliver(order["id"]);

    result.fold((left) {
      showErrorToast("Error occurred: status code : ${left.toString()}");
      print(' ${left.toString()}');
    }, (right) {
      if (right["code"] == 200) {
        showSuccessToast("Вы успешно получили доставку");
      }
    });
  }

  Future<void> giveDeliveryOrder() async {
    CourierRepositoryImpl repository = CourierRepositoryImpl();
    var result = await repository.orderDelivered(order["id"]);

    result.fold((left) {
      showErrorToast("Delivery is done");
    }, (right) {
      if (right["code"] == 200) {
        showSuccessToast("Delivery is delivered successfully!");
      }
    });
  }

  Future<void> orderCourierStart() async {
    CourierRepositoryImpl repository = CourierRepositoryImpl();
    var result = await repository.orderCourierStart(order["id"]);

    result.fold((left) {
      showErrorToast("Delivery has error");
    }, (right) {
      print(right.toString());
      showSuccessToast("Delivery is started successfully!");
    });
  }

  Future<bool> isDelivering()async{
    return  await order["is_delivering"];
  }

  @override
  void initState() {
    super.initState();
    fetchSingleOrder();
  }
  @override
  Widget build(BuildContext context) {
    bool is_delivering = order["is_delivering"]??false;
    int statusId = order["status_id"];
    String status = order["status"];
    print(isDelivering());
    print('is delivering: $is_delivering');
    print(order["status_id"]);
    print("status is $status");
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              print("button is pressed");

            },
            icon: Icon(Icons.refresh),
          ),
        ],
        title: Text(
          'ID ${order["order_id"]}'.toUpperCase(),
          style: const TextStyle(color: Color(0xff0F172A), fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              SizedBox(
                width: width(context),
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
                        const Center(
                          child: Text(
                            'Забрать доставку',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        ListTile(
                          leading: const Text(
                            'Куда',
                            style: TextStyle(
                              color: Color(0xff48535B),
                              fontSize: 20,
                            ),
                          ),
                          trailing: SizedBox(
                            width: 200,
                            child: Text(
                              '${order["delivery_addr_name"]}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        ListTile(
                          leading: const Text(
                            'Номер телефона',
                            style: TextStyle(
                              color: Color(0xff48535B),
                              fontSize: 20,
                            ),
                          ),
                          trailing: Text(
                            '+${order["client_phone_number"]}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        ListTile(
                          leading: const Text(
                            'Дата',
                            style: TextStyle(
                              color: Color(0xff48535B),
                              fontSize: 20,
                            ),
                          ),
                          trailing: Text(
                            '${order["created_at"]}'.substring(0, 10),
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        const ListTile(
                          leading: Text(
                            'Оплата',
                            style: TextStyle(
                              color: Color(0xff48535B),
                              fontSize: 20,
                            ),
                          ),
                          trailing: Text(
                            'Картой',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        ListTile(
                          leading: const Text(
                            'Итого к оплате',
                            style: TextStyle(
                              color: Color(0xff48535B),
                              fontSize: 20,
                            ),
                          ),
                          trailing: Text(
                            '${order["total_price"]} сум',
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        const ListTile(
                          leading: Text(
                            'Статус оплаты',
                            style: TextStyle(
                              color: Color(0xff48535B),
                              fontSize: 20,
                            ),
                          ),
                          trailing: Text(
                            'Оплачен',
                            style: TextStyle(
                              color: Color(0xff00D509),
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        const Center(
                          child: Text(
                            'Связаться с отправителем',
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    width: width(context),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 8),
                            width: width(context) * .2,
                            height: width(context) * .2,
                            child: Image.network(
                              order['products'][index]['main_image'],
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 20),
                          SizedBox(
                              // height: width(context) * .2,
                              width: width(context) * .6,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    order['products'][index]['name_uz'],
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text(
                                    '${order['products'][index]['quantity']} шт.',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text(
                                    '${order['products'][index]['product_price']} сум',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ),
                  );
                },
                itemCount: order['products'].length,
              ),
              SizedBox(
                height: height(context) * .05,
              ),
              SizedBox(
                width: width(context),
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
                        Center(
                          child: Text(
                            'ID ${order["order_id"]}'.toUpperCase(),
                            style: const TextStyle(
                                color: Color(0xff0F172A), fontSize: 20),
                          ),
                        ),
                        Center(
                          child: Text(
                            textAlign: TextAlign.center,
                            '${order["delivery_addr_name"]}',
                          ),
                        ),
                        const SizedBox(height: 10),
                        Divider(
                          height: 2,
                          thickness: 2,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: SizedBox(
                            width: width(context) * .8,
                            child: TextButton(
                              onPressed: () {
                                makePhoneCall(order["client_phone_number"]);
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.phone_outlined,
                                    color: Colors.blue,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'Позвонить клиенту',
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height(context) * .05,
              ),
              Builder(
                builder: (context) {
                  print(status);
                  print(statusId);
                  if (statusId==4) {
                    if (status == "picked") {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          minimumSize:
                              Size(width(context), height(context) * .06),
                        ),
                        onPressed: () async {
                          if (kDebugMode) {
                            print(order['delivery_addr_lat']);
                          }
                          if (kDebugMode) {
                            print(order['delivery_addr_long']);
                          }
                          await orderCourierStart();
                          _launchURL(order['delivery_addr_lat'].toString(),
                              order['delivery_addr_long'].toString());

                          /*showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },

                        child: Text('Нет'),
                      ),
                      TextButton(
                        onPressed: () async{
                          await giveDeliveryOrder();
                          pop();
                        },
                        child: Text('Да'),
                      ),
                    ],
                    title: Text('Подтверждение'),
                    contentPadding: EdgeInsets.all(20),
                    content: Text("Хотите получить доставку?"),
                  ),
                );*/
                        },
                        child: const Text(
                          "Поехать к клиенту",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      );
                    } else if (status == "delivering") {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          minimumSize:
                              Size(width(context), height(context) * .06),
                        ),
                        onPressed: () {
                          // _launchURL();
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              actions: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Нет'),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          await giveDeliveryOrder();
                                          pop();
                                        },
                                        child: const Text('Да'),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                              contentPadding: const EdgeInsets.all(20),
                              title: const Text("Вы доставили заказ?"),
                            ),
                          );
                        },
                        child: const Text(
                          "Отдать заказ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      );
                    }

                  }else if(statusId==3){
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        minimumSize:
                        Size(width(context), height(context) * .06),
                      ),
                      onPressed: () {
                        // _launchURL();
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            actions: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Нет'),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        await giveDeliveryOrder();
                                        pop();
                                      },
                                      child: const Text('Да'),
                                    ),
                                  ),
                                ],
                              )
                            ],
                            contentPadding: const EdgeInsets.all(20),
                            title: const Text("Вы доставили заказ?"),
                          ),
                        );
                      },
                      child: const Text(
                        "Отдать заказ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    );
                  }

                  else{
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        minimumSize: Size(width(context), height(context) * .05),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            actions: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Нет'),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        await getDeliveryOrder();

                                        popOne();
                                      },
                                      child: const Text('Дa'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            // title: const Text('Подтверждение'),
                            contentPadding: const EdgeInsets.all(20),
                            title: const Text(
                              "Хотите получить доставку?",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        "Забрать доставку",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    );
                  }
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: Size(width(context), height(context) * .05),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Нет'),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      await getDeliveryOrder();

                                      popOne();
                                    },
                                    child: const Text('Дa'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                          // title: const Text('Подтверждение'),
                          contentPadding: const EdgeInsets.all(20),
                          title: const Text(
                            "Хотите получить доставку?",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      "Забрать доставку",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  );


                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void pop() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const MyPages()));
  }

  void popOne() {
    Navigator.pop(context);
  }
}
