import 'package:courier_app/feature/courier/data/repositories/courier_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../resources/values_manager.dart';

class OrderDetailsPage extends StatefulWidget {
  const OrderDetailsPage({super.key, required this.order});

  final Map<String, dynamic> order;

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {

  bool isPicked = false;
  bool isGived = false;

   makePhoneCall(String phoneNumber) async {
    String url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  
  _launchURL(String lat, String long) async {
    String url = 'https://yandex.ru/maps/?ll=$lat,$long';
    if (await launch(url)) {
      await canLaunch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  getDeliveryOrder()async{
    CourierRepositoryImpl repository = CourierRepositoryImpl();
    var result = await repository.pickDeliver(widget.order["id"]);

    result.fold((left) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error occurred: $left")));
    }, (right) {
      if(right["code"]==200){
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Вы успешно получили доставку")));
      }

    });
  }
  giveDeliveryOrder()async{
    CourierRepositoryImpl repository = CourierRepositoryImpl();
    var result = await repository.orderDelivered(widget.order["id"]);

    result.fold((left) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error occurred: $left")));
    }, (right) {
      if(right["code"]==200){
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("You successfully give order")));
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'ID ${widget.order["order_id"]}'.toUpperCase(),
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
                          child: Text('Забрать доставку',style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),),
                        ),
                        ListTile(
                          leading: const Text(
                            'Куда',
                            style: TextStyle(
                              color: Color(0xff48535B),
                              fontSize: 20,
                            ),
                          ),
                          trailing: Text(
                            '${widget.order["delivery_addr_name"]}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
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
                            '+${widget.order["client_phone_number"]}',
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
                            '${widget.order["created_at"]}'.substring(0, 10),
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
                            '${widget.order["total_price"]} сум',
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
                    width: width(context),


                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      child: Row(

                        children: [
                          Container(
                            margin:const EdgeInsets.symmetric(vertical: 10,horizontal: 8),
                            width: width(context) * .2,
                            height: width(context) * .2,
                            child: Image.network(
                              widget.order['products'][index]['main_image'],
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Container(
                              // height: width(context) * .2,
                              width: width(context) * .6,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.order['products'][index]['name_uz'],
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text(
                                    '${widget.order['products'][index]['quantity']} шт.',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text(
                                    '${widget.order['products'][index]['product_price']} сум',
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
                itemCount: widget.order['products'].length,
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
                            'ID ${widget.order["order_id"]}'.toUpperCase(),
                            style: const TextStyle(
                                color: Color(0xff0F172A), fontSize: 20),
                          ),
                        ),
                        Center(
                          child: Text(
                            textAlign: TextAlign.center,
                            '${widget.order["delivery_addr_name"]}',                        ),
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.phone_outlined,
                                  color: Colors.blue,
                                ),
                                const SizedBox(width: 10),
                                TextButton(
                                  onPressed: (){
                                    makePhoneCall(widget.order["client_phone_number"]);
                                  },
                                  child: const Text(
                                    'Позвонить клиенту',
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
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
              SizedBox(
                height: height(context) * .1,
              ),
            !isPicked?
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:  Colors.blue,
                minimumSize: Size(width(context), height(context) * .05),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },

                        child: const Text('Нет'),
                      ),
                      TextButton(
                        onPressed: () async{
                          await getDeliveryOrder();
                          setState(() {
                            isPicked = true;
                          });
                          pop();
                        },
                        child: const Text('Дa'),
                      ),
                    ],
                    title: const Text('Подтверждение'),
                    contentPadding: const EdgeInsets.all(20),
                    content: const Text("Хотите получить доставку?"),
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
            ):
            !isGived?ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: Size(width(context), height(context) * .06),
              ),
              onPressed: () {
                 _launchURL(widget.order['delivery_addr_lat'].toString(),widget.order['delivery_addr_lot'].toString());
                 setState(() {
                   isGived = true;
                   print(isGived);
                 });
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
            ):
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: Size(width(context), height(context) * .06),
              ),
              onPressed: () {
                // _launchURL();
                showDialog(
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
                    content: Text("Вы действительно доставили заказ?"),
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
            ),
            ],
          ),
        ),
      ),
    );
  }

  void pop() {Navigator.pop(context);}



}
