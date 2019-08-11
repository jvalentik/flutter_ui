import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const String _name = 'Johny';
final ThemeData kIOSTheme = new ThemeData(
  primarySwatch: Colors.orange,
  primaryColor: Colors.grey.shade100,
  primaryColorBrightness: Brightness.light,
);

final ThemeData kDefaultTheme = new ThemeData(
  primarySwatch: Colors.purple,
  accentColor: Colors.orangeAccent.shade100,
);

void main() => runApp(FriendlyChatApp());

class FriendlyChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Friendly Chat',
      theme: defaultTargetPlatform == TargetPlatform.iOS
          ? kIOSTheme
          : kDefaultTheme,
      home: new ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  State createState() => new ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = new TextEditingController();
  bool _isComposing = false;

  _handleSubmitted(String text) {
    _textController.clear();
    setState(() => _isComposing = false);
    ChatMessage chatMessage = new ChatMessage(
      text: text,
      animationController: AnimationController(
        duration: Duration(
          milliseconds: 700,
        ),
        vsync: this,
      ),
    );
    setState(() => this._messages.insert(0, chatMessage));
    chatMessage.animationController.forward();
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(
        color: Theme.of(context).accentColor,
      ),
      child: new Container(
          margin: EdgeInsets.symmetric(horizontal: 8.0),
          child: new Row(
            children: <Widget>[
              new Flexible(
                child: new TextField(
                  controller: _textController,
                  onSubmitted: _handleSubmitted,
                  onChanged: (String text) {
                    setState(() => _isComposing = text.length > 0);
                  },
                  decoration: new InputDecoration.collapsed(
                    hintText: 'Send a message',
                  ),
                ),
              ),
              new Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 4.0,
                ),
                child: Theme.of(context).platform == TargetPlatform.iOS
                    ? //modified
                    new CupertinoButton(
                        //new
                        child: new Text('Send'), //new
                        onPressed: _isComposing //new
                            ? () => _handleSubmitted(_textController.text) //new
                            : null,
                      )
                    : IconButton(
                        icon: Icon(Icons.send),
                        onPressed: _isComposing
                            ? () => _handleSubmitted(_textController.text)
                            : null,
                      ),
              ),
            ],
          )),
    );
  }

  @override
  void dispose() {
    for (ChatMessage chatMessage in _messages) {
      chatMessage.animationController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          'Friendly Chat',
        ),
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
      ),
      body: Container(
          child: Column(
            children: <Widget>[
              Flexible(
                child: ListView.builder(
                  padding: EdgeInsets.all(8.0),
                  reverse: true,
                  itemBuilder: (_, int index) => _messages[index],
                  itemCount: _messages.length,
                ),
              ),
              Divider(
                height: 1.0,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                ),
                child: _buildTextComposer(),
              ),
            ],
          ),
          decoration: Theme.of(context).platform == TargetPlatform.iOS //new
              ? new BoxDecoration(
                  //new
                  border: new Border(
                    //new
                    top: new BorderSide(color: Colors.grey[200]), //new
                  ), //new
                ) //new
              : null),
    );
  }
}

class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.animationController});
  final String text;
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    return new SizeTransition(
      sizeFactor: CurvedAnimation(
        parent: this.animationController,
        curve: Curves.easeOut,
      ),
      axisAlignment: 0.0,
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: 10.0,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                right: 16.0,
              ),
              child: CircleAvatar(
                child: Text(
                  _name[0],
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    _name,
                    style: Theme.of(context).textTheme.subhead,
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: 5.0,
                    ),
                    child: Text(
                      text,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
