import '../models/Post.dart';
import 'dart:convert';
import 'package:http/http.dart' show Client;

class ApiService {
  final String baseUrl = "https://rantpad-api-beta.herokuapp.com";

  Client client = Client();

  // Future<List<Post>> getPosts() async {
  //   final response = await client.get("$baseUrl/api/posts");
  //   if (response.statusCode == 200) {
  //     return postFromJson(response.body);
  //   } else {
  //     return null;
  //   }
  // }

  Future<bool> createPost(Post data) async {
    final response = await client.post(
      "$baseUrl/api/posts",
      headers: {"content-type": "application/json"},
      body: postToJson(data),
    );
    if(response.statusCode == 200){
      return true;
    }else{
      return false;
    }
  }

  Future<bool> updatePost(Post data) async {
    final response = await client.put(
      "$baseUrl/api/posts/${data.id}",
      headers: {"content-type": "application/json"},
      body: postToJson(data),
    );
    if(response.statusCode == 200){
      return true; 
    }else{
      return false;
    }
  }

  Future<bool> deletePost(String id) async{
    final response = await client.delete(
      "$baseUrl/api/posts/$id",
      headers: {"conent-type": "application/json"},
    );
    if(response.statusCode == 200){
      return true;
    }else{
      return false;
    }
  }

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
    try {
      final response = await client.get("$baseUrl/api/posts");

      // final dataResponse = jsonResponse['data'];
      // final jsonPostResponse = dataResponse['posts'];

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        var rest = jsonResponse["data"]["posts"] as List;
        list = rest.map<Post>((json) => Post.fromJson(json)).toList();
        return list;
        // List<Post> list = parseResponse(response.body);
        // return list;
      } else {
        return List<Post>();
      }
    } catch (e) {
      return List<Post>(); // return an empty list exception/error
    }
  }

  // List<Post> parseResponse(String responseBody) {
  //   final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  //   return parsed.map<Post>((json) => Post.fromJson(json)).toList();
  // }

  // Future<bool> createPost(Post data) async {
  //   final response = await http.post(
  //     "$baseUrl/api/posts",
  //     headers: {"content-type": "application/json"},
  //     body: postToJson(data),
  //   );
  //   if (response.statusCode == 201) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }
}
