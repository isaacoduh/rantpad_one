import 'package:flutter/material.dart';
import 'package:rantpad_one/utils/ApiService.dart';
import '../models/Post.dart';

final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class FormAddScreen extends StatefulWidget {
  Post post;

  FormAddScreen({this.post});

  @override
  _FormAddScreenState createState() => _FormAddScreenState();
}

class _FormAddScreenState extends State<FormAddScreen> {
  bool _isLoading = false;
  ApiService _apiService = ApiService();
  bool _isFieldTitleValid;
  bool _isFieldRantValid;
  TextEditingController _controllerTitle = TextEditingController();
  TextEditingController _controllerRant = TextEditingController();

  @override
  void initState() {
    if (widget.post != null) {
      _isFieldTitleValid = true;
      _controllerTitle.text = widget.post.title;
      _isFieldRantValid = true;
      _controllerRant.text = widget.post.rant;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          widget.post == null ? "Post A Rant" : "Update a Rant",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _buildTextFieldTitle(),
                _buildTextFieldRant(),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: RaisedButton(
                    child: Text(
                      widget.post == null
                          ? "Post Rant".toUpperCase()
                          : "Update Rant".toUpperCase(),
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      if (_isFieldTitleValid == null ||
                          _isFieldRantValid == null ||
                          !_isFieldTitleValid ||
                          !_isFieldRantValid) {
                        final snackbar =
                            SnackBar(content: Text('Please fill all fields'));
                        _scaffoldState.currentState.showSnackBar(snackbar);
                        return;
                      }
                      setState(() => _isLoading = true);
                      String title = _controllerTitle.text.toString();
                      String rant = _controllerRant.text.toString();
                      Post post = Post(title: title, rant: rant);
                      if (widget.post == null) {
                        _apiService.createPost(post).then((isSuccess) {
                          setState(() => _isLoading = false);
                          if (isSuccess) {
                            Navigator.pop(_scaffoldState.currentState.context);
                          } else {
                            _scaffoldState.currentState.showSnackBar(SnackBar(
                              content: Text("Failed to Post Rant"),
                            ));
                          }
                        });
                      } else {
                        post.id = widget.post.id;
                        _apiService.updatePost(post).then((isSuccess) {
                          setState(() => _isLoading = false);
                          if (isSuccess) {
                            Navigator.pop(_scaffoldState.currentState.context);
                          } else {
                            _scaffoldState.currentState.showSnackBar(SnackBar(
                              content: Text("Failed to Update Rant"),
                            ));
                          }
                        });
                      }
                    },
                    color: Colors.blue[600],
                  ),
                ),
              ],
            ),
          ),
          _isLoading
              ? Stack(
                  children: <Widget>[
                    Opacity(
                      opacity: 0.3,
                      child: ModalBarrier(
                        dismissible: false,
                        color: Colors.grey,
                      ),
                    ),
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }

  Widget _buildTextFieldTitle() {
    return TextField(
      controller: _controllerTitle,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "Title",
        errorText: _isFieldTitleValid == null || _isFieldTitleValid
            ? null
            : "Title of Post is required",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldTitleValid) {
          setState(() => _isFieldTitleValid = isFieldValid);
        }
      },
    );
  }

  Widget _buildTextFieldRant() {
    return TextField(
      controller: _controllerRant,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        labelText: "Rant....",
        errorText: _isFieldRantValid == null || _isFieldRantValid
            ? null
            : "Rant is required",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldRantValid) {
          setState(() => _isFieldRantValid = isFieldValid);
        }
      },
    );
  }
}
