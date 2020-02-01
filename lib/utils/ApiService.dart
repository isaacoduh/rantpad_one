import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/Post.dart';

class ApiService {
  final String baseUrl = "https://rantpad-api-beta.herokuapp.com";
  

  // Future<List<Post>> getPosts() async{
  //   final response = await client.get("$baseUrl/api/posts");
  //   if(response.statusCode == 200){
  //     return postFromJson(response.body);
  //   }else{
  //     return null;
  //   }
  // }

  Future<List<Post>> getPosts() async {
    List<Post> list;
    try{
      final response = await http.get("$baseUrl/api/posts");
     
      // final dataResponse = jsonResponse['data'];
      // final jsonPostResponse = dataResponse['posts'];
      
      if(response.statusCode == 200){
         final jsonResponse = json.decode(response.body);
         var rest = jsonResponse["data"]["posts"] as List;
         print(rest);
         list = rest.map<Post>((json) => Post.fromJson(json)).toList();
         return list;
        // List<Post> list = parseResponse(response.body);
        // return list;
      }else{
        return List<Post>();
      }
    }catch(e){
      return List<Post>(); // return an empty list exception/error
    }
  }

  List<Post> parseResponse(String responseBody){
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Post>((json) => Post.fromJson(json)).toList();
  }

}