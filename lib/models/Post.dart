import 'dart:convert';

class Post {
  String id;
  String title;
  String rant;

  Post({this.id, this.title, this.rant});

  factory Post.fromJson(Map<String, dynamic> json){
    return Post(
      id: json["_id"],
      title: json["title"],
      rant: json["rant"],
    );
  }
  // factory Post.fromJson(Map<String, dynamic> map){
  //   return Post(
  //     id: map["id"], title: map["title"], rant: map["rant"]
  //   );
  // }

  // Map<String, dynamic> toJson(){
  //   return {"_id": id, "title": title, "rant": rant};
  // }

  // @override
  //   String toString(){
  //     return 'Post {id: $id, title: $title, rant: $rant}';
  //   }

  // List<Post> postFromJson(String jsonData){
  //   final data = json.decode(jsonData);
  //   return List <Post>.from(data.map((item) => Post.fromJson(item)));
  // }

  // String postToJson (Post data){
  //   final jsonData = data.toJson();
  //   return json.encode(jsonData);
  // }
}