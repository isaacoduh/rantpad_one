import 'package:flutter/material.dart';
import 'package:rantpad_one/screens/form_add_screen.dart';
import 'package:rantpad_one/utils/ApiService.dart';
import '../models/Post.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  BuildContext context;
  ApiService apiService;

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder(
        future: apiService.getPosts(),
        builder: (BuildContext context, AsyncSnapshot<List<Post>> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Something went wrong: ${snapshot.error.toString()}"),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            List<Post> posts = snapshot.data;
            return _buildListView(posts);
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget _buildListView(List<Post> posts) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
    child: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          Post post = posts[index];
          // print(post);
          return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      post.title,
                      style: Theme.of(context).textTheme.title,
                    ),
                    Text(post.rant),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        FlatButton(
                          onPressed: (){
                            showDialog(context: context, builder: (context){
                              return AlertDialog(
                                title: Text("Warning"),
                                content: Text("Are you sure want to delete post data ${post.title}?"),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text("Yes"),
                                    onPressed: (){
                                      Navigator.pop(context);
                                      apiService.deletePost(post.id).then((isSuccess){
                                        if(isSuccess){
                                          setState((){});
                                          Scaffold.of(this.context).showSnackBar(SnackBar(content: Text("Post deleted successfully")));
                                        }else{
                                          Scaffold.of(this.context).showSnackBar(SnackBar(content: Text("Post deletion failed.")));
                                        }
                                      });
                                    },
                                  ),
                                  FlatButton(
                                    child: Text("No"),
                                    onPressed: (){
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            });
                          },
                          child: Text("Delete", style: TextStyle(color: Colors.red),),
                        ),
                        FlatButton(
                          onPressed:() {
                            Navigator.push(context, MaterialPageRoute(builder: (context){
                              return FormAddScreen(post: post);
                            }));
                          },
                          child: Text("Edit", style: TextStyle(color: Colors.blue),),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
  );
}

}

