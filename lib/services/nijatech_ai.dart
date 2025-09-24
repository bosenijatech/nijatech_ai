import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constant/app_constants.dart';



import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constant/app_constants.dart';
import '../model/invoice_model.dart';

class apiService {
  static String liveApiPath = AppConstants.apiBaseUrl;

  final http.Client client = http.Client();

  Map<String, String>? headerData;

  apiService();

  /// Get Token from SharedPreferences and prepare headers
  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString('auth_token');

    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $value',
    };
  }


  handleError({message}) {
    throw Exception(message ?? 'Network Error');
  }

  
//login
  static const int timeOutDuration = 35;
 static Future<http.Response> login(String email, String password) async {
    final url = Uri.parse("${liveApiPath}login");
    final headers = {"Content-Type": "application/x-www-form-urlencoded"};

    // encode manually
    final body =
        "username=${Uri.encodeComponent(email)}&password=${Uri.encodeComponent(password)}";

    return await http.post(url, headers: headers, body: body);
  }

  /// If you also need JSON body version
  // static Future<http.Response> loginJson(Map<String, dynamic> data) async {
  //   final url = Uri.parse("${liveApiPath}login");
  //   final headers = {"Content-Type": "application/json"};
  //   return await http.post(url, headers: headers, body: jsonEncode(data));
  // }


  //getallgooglecreds
static Future<http.Response> getallgooglecreds() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('accessToken') ?? '';

  final url = Uri.parse('${liveApiPath}google/creds');
  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Authorization": "Bearer $token",
  };

  return await http.get(url, headers: headers);
}


//addgooglecreds

static Future<http.Response> addgooglecreds(dynamic body) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('accessToken') ?? '';
  final url = Uri.parse('${liveApiPath}google/creds');
  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Authorization": "Bearer $token",
  };

  return await http.post(
    url,
    headers: headers,
    body: jsonEncode(body), 
  );
}


//editgooglecreds
  static Future<http.Response> editgooglecreds(String id, Map<String, dynamic> body) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken') ?? '';

    final url = Uri.parse('${liveApiPath}google/creds/$id'); 
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    return await http.put(
      url,
      headers: headers,
      body: jsonEncode(body),
    );
  }

  //deletegooglecreds
static Future<http.Response> deletegooglecreds(String id) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('accessToken') ?? '';
  final url = Uri.parse('${liveApiPath}google/creds/$id');
  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Authorization": "Bearer $token",
  };

  return await http.delete(url, headers: headers);
}


// GET Netsuite creds
static Future<Map<String, dynamic>> getCreds() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken') ?? '';

    final url = Uri.parse('${liveApiPath}netsuite');
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    final res = await http.get(url, headers: headers).timeout(const Duration(seconds: 15));

    if (res.statusCode == 200) {
      return json.decode(res.body)['netsuite'];
    } else {
      throw Exception('Failed to fetch Netsuite credentials');
    }
  }

  static Future<bool> saveCreds({
    required String consumerKey,
    required String consumerSecret,
    required String token,
    required String tokenSecret,
    required String accountId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('accessToken') ?? '';

    final url = Uri.parse('${liveApiPath}netsuite');
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $authToken",
    };

    final body = json.encode({
      "consumerKey": consumerKey,
      "consumerSecret": consumerSecret,
      "token": token,
      "tokenSecret": tokenSecret,
      "accountId": accountId,
    });

    final res = await http.post(url, headers: headers, body: body);

    return res.statusCode == 200 || res.statusCode == 201;
  }

  static Future<bool> deleteCreds() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken') ?? '';

    final url = Uri.parse('${liveApiPath}netsuite');
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    final res = await http.delete(url, headers: headers);

    return res.statusCode == 200;
  }


//getInvoices

static Future<List<Supplier>> getInvoices() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken') ?? '';

    final url = Uri.parse('${liveApiPath}invoices');
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final suppliersJson = decoded["invoices"][0]["Suppliers"] as List;
      return suppliersJson.map((s) => Supplier.fromJson(s)).toList();
    } else {
      throw Exception('Failed to load invoices');
    }
  }


// GET API
static Future<Map<String, dynamic>> getapikey() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken') ?? '';

    final url = Uri.parse('${liveApiPath}openai');
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    final res = await http.get(url, headers: headers).timeout(const Duration(seconds: 15));

    if (res.statusCode == 200) {
      return json.decode(res.body)['openai'];
    } else {
      throw Exception('Failed to fetch openai credentials');
    }
  }

  static Future<bool> saveapikey({
    required String apiKey,
   
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('accessToken') ?? '';

    final url = Uri.parse('${liveApiPath}openai');
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $authToken",
    };

    final body = json.encode({
      "apiKey": apiKey,
      
    });

    final res = await http.post(url, headers: headers, body: body);

    return res.statusCode == 200 || res.statusCode == 201;
  }

  static Future<bool> deleteapikey() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken') ?? '';

    final url = Uri.parse('${liveApiPath}openai');
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    final res = await http.delete(url, headers: headers);

    return res.statusCode == 200;
  }


}

