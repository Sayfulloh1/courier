


import 'package:courier_app/core/either/either.dart';

abstract class CourierRepository{
  Future<Either<Exception,String>> loginWithEmailAndPassword(String email, String password);
  Future<Either<Exception,List<Map<String, dynamic>>>> getAllCourierOrders();
  Future<Either<Exception,Map<String, dynamic>>> getSingleCourierOrder(String orderId);
  Future<Either<Exception, Map<String,dynamic>>> pickDeliver(String id);
  Future<Either<Exception, Map<String,dynamic>>> orderDelivered(String id);
  Future<Either<Exception, List<Map<String, dynamic>>>> getAllCompletedOrders();
  Future<Either<Exception, Map<String, dynamic>>> orderCourierStart(String orderId);

}