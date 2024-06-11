import 'package:courier_app/core/either/either.dart';
import 'package:courier_app/feature/courier/domain/repositories/courier_repository.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

String email1 = '';
String password1 = '';

class CourierRepositoryImpl extends CourierRepository {
  SharedPreferences? _prefs;

  // Constructor to initialize SharedPreferences
  CourierRepositoryImpl() {
    _initPrefs();
  }

  // Initialize SharedPreferences
  void _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Save token to SharedPreferences
  Future<void> _saveToken(String token) async {
    if (_prefs != null) {
      await _prefs!.setString('token', token);
    }
  }

  @override
  Future<Either<Exception, String>> loginWithEmailAndPassword(
      String email, String password) async {
    String url =
        'https://ulab-market-v2-n6zf.onrender.com/api/auth/login_courier';
    try {
      email1 = email;
      password1 = password;
      Dio dio = Dio();
      // Make POST request with the provided body
      Response response = await dio.post(
        url,
        data: {
          "login": email,
          "password": password,
        },
      );
      // Extract token from the response
      String token = response.data['token'];
      await _saveToken(token); // Save token to SharedPreferences
      print(token);
      print('token is got successfully');
      return Right(token);
    } catch (error) {
      print('error occurred in login');
      return Left(Exception(error.toString()));
    }
  }

  @override
  Future<Either<Exception, List<Map<String, dynamic>>>>
      getAllCourierOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    /*  String? token = await _getToken();
    if (token == null) {
      try {
        // Attempt to login to obtain token if it's not available
        Either<Exception, String> loginResult =
            await loginWithEmailAndPassword("$email1", "$password1");
        loginResult.fold((left) {
          // Login failed, return the error
          return Left(left);
        }, (right) {
          // Login successful, retrieve token again
          token = right;
        });
      } catch (error) {
        return Left(Exception("Failed to obtain token: $error"));
      }
    }*/

    if (token == null) {
      return Left(Exception('Bearer token is not available'));
    }

    String url = 'https://ulab-market-v2-n6zf.onrender.com/api/order/courier';
    try {
      Dio dio = Dio();
      // Make GET request with bearer token in headers
      Response response = await dio.get(
        url,
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );
      // Extract data from the response
      List<Map<String, dynamic>> orders =
          List<Map<String, dynamic>>.from(response.data);
      return Right(orders);
    } catch (error) {
      print('error occurred while fetching orders');
      return Left(Exception(error.toString()));
    }
  }

  // @override
  // Future<Either<Exception, List<Map<String, dynamic>>>>
  // getSingleCourierOrder(String orderId) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final token = prefs.getString('token');
  //
  //   /*  String? token = await _getToken();
  //   if (token == null) {
  //     try {
  //       // Attempt to login to obtain token if it's not available
  //       Either<Exception, String> loginResult =
  //           await loginWithEmailAndPassword("$email1", "$password1");
  //       loginResult.fold((left) {
  //         // Login failed, return the error
  //         return Left(left);
  //       }, (right) {
  //         // Login successful, retrieve token again
  //         token = right;
  //       });
  //     } catch (error) {
  //       return Left(Exception("Failed to obtain token: $error"));
  //     }
  //   }*/
  //
  //   if (token == null) {
  //     return Left(Exception('Bearer token is not available'));
  //   }
  //
  //   String url = 'https://ulab-market-v2-n6zf.onrender.com/api/order/courier';
  //   try {
  //     Dio dio = Dio();
  //     // Make GET request with bearer token in headers
  //     Response response = await dio.get(
  //       url,
  //       options: Options(headers: {
  //         'Authorization': 'Bearer $token',
  //       }),
  //     );
  //     // Extract data from the response
  //     List<Map<String, dynamic>> orders =
  //     List<Map<String, dynamic>>.from(response.data);
  //     return Right(orders);
  //   } catch (error) {
  //     print('error occurred while fetching orders');
  //     return Left(Exception(error.toString()));
  //   }
  // }

  @override
  Future<Either<Exception, Map<String, dynamic>>> getSingleCourierOrder(
      String orderId) async {
    String url = 'https://ulab-market-v2-n6zf.onrender.com/api/order/$orderId';

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      return Left(Exception('Bearer token is not available'));
    }

    try {
      Dio dio = Dio();
      Response response = await dio.get(
        url,
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );
      Map<String, dynamic> order =
      Map<String, dynamic>.from(response.data);
      return Right(order);
    } catch (error) {
      print('error occurred while fetching orders by id');
      return Left(Exception(error.toString()));
    }
  }

  @override
  Future<Either<Exception, Map<String, dynamic>>> pickDeliver(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    /* String? token = await _getToken();
    if (token == null) {
      try {
        // Attempt to login to obtain token if it's not available
        Either<Exception, String> loginResult =
            await loginWithEmailAndPassword(email1, password1);
        loginResult.fold((left) {
          // Login failed, return the error
          return Left(left);
        }, (right) {
          // Login successful, retrieve token again
          token = right;
        });
      } catch (error) {
        return Left(Exception("Failed to obtain token: $error"));
      }
    }*/

    if (token == null) {
      return Left(Exception('Bearer token is not available'));
    }

    String url =
        'https://ulab-market-v2-n6zf.onrender.com/api/order/picked_deliver/$id';
    try {
      Dio dio = Dio();
      // Make GET request with bearer token in headers
      Response response = await dio.get(
        url,
        data: {
          "id": id,
        },
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );
      // Extract data from the response
      Map<String, dynamic> data = Map<String, dynamic>.from(response.data);
      return Right(data);
    } catch (error) {
      print('error occurred while fetching orders');
      return Left(Exception(error.toString()));
    }
  }

  @override
  Future<Either<Exception, Map<String, dynamic>>> orderDelivered(
      String id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    /* String? token = await _getToken();
    if (token == null) {
      try {
        // Attempt to login to obtain token if it's not available
        Either<Exception, String> loginResult =
        await loginWithEmailAndPassword(email1, password1);
        loginResult.fold((left) {
          // Login failed, return the error
          return Left(left);
        }, (right) {
          // Login successful, retrieve token again
          token = right;
        });
      } catch (error) {
        return Left(Exception("Failed to obtain token: $error"));
      }
    }*/

    if (token == null) {
      return Left(Exception('Bearer token is not available'));
    }

    String url =
        'https://ulab-market-v2-n6zf.onrender.com/api/order/delivered/$id';
    try {
      Dio dio = Dio();
      // Make GET request with bearer token in headers
      Response response = await dio.get(
        url,
        data: {
          "id": id,
        },
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );
      // Extract data from the response
      Map<String, dynamic> data = Map<String, dynamic>.from(response.data);
      return Right(data);
    } catch (error) {
      print('error occurred while fetching orders');
      return Left(Exception(error.toString()));
    }
  }

  @override
  Future<Either<Exception, List<Map<String, dynamic>>>>
      getAllCompletedOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    /*String? token = await _getToken();
    if (token == null) {
      try {
        // Attempt to login to obtain token if it's not available
        Either<Exception, String> loginResult = await loginWithEmailAndPassword("$email1", "$password1");
        loginResult.fold((left) {
          // Login failed, return the error
          return Left(left);
        }, (right) {
          // Login successful, retrieve token again
          token = right;
        });
      } catch (error) {
        return Left(Exception("Failed to obtain token: $error"));
      }
    }*/

    if (token == null) {
      return Left(Exception('Bearer token is not available'));
    }

    String url =
        'https://ulab-market-v2-n6zf.onrender.com/api/order/courier/myorders?limit=1000&page=1';
    try {
      Dio dio = Dio();
      // Make GET request with bearer token in headers
      Response response = await dio.get(
        url,
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );
      // Check the status code
      if (response.statusCode == 200) {
        // Extract data from the response
        var data = response.data;
        List<Map<String, dynamic>> result =
            List<Map<String, dynamic>>.from(data['data']);
        return Right(result);
      } else {
        return Left(Exception(
            'Failed to fetch orders. Status code: ${response.statusCode}'));
      }
    } catch (error) {
      print('error occurred while fetching orders');
      return Left(Exception(error.toString()));
    }
  }

  @override
  Future<Either<Exception, Map<String, dynamic>>> orderCourierStart(
      String orderId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      return Left(Exception('Bearer token is not available'));
    }

    String url =
        'https://ulab-market-v2-n6zf.onrender.com/api/order/courier/start';
    try {
      Dio dio = Dio();
      // Make POST request with bearer token in headers and order_id in body
      Response response = await dio.post(
        url,
        data: {
          "order_id": orderId,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        // Assuming the response contains updated list of orders, you can parse it accordingly
        Map<String, dynamic> data = response.data as Map<String, dynamic>;
        return Right(data);
      } else {
        return Left(Exception(
            'Failed to start courier. Status code: ${response.statusCode}'));
      }
    } catch (error) {
      print('Error occurred while starting courier: $error');
      return Left(Exception('Error occurred while starting courier: $error'));
    }
  }
}
