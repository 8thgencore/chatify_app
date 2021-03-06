import 'package:chatify_app/models/chat.dart';
import 'package:chatify_app/models/chat_message.dart';
import 'package:chatify_app/providers/authentication_provider.dart';
import 'package:chatify_app/providers/chat_page_provider.dart';
import 'package:chatify_app/widgets/custom_input_fileds.dart';
import 'package:chatify_app/widgets/custom_list_view_tiles.dart';
import 'package:chatify_app/widgets/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  final Chat chat;

  const ChatPage({Key? key, required this.chat}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late double _deviceHeight;
  late double _deviceWidth;

  late AuthenticationProvider _auth;
  late ChatPageProvider _pageProvider;

  late GlobalKey<FormState> _messageFormState;
  late ScrollController _messagesListViewController;

  @override
  void initState() {
    super.initState();
    _messageFormState = GlobalKey<FormState>();
    _messagesListViewController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthenticationProvider>(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ChatPageProvider>(
          create: (_) => ChatPageProvider(widget.chat.uid, _auth, _messagesListViewController),
        ),
      ],
      child: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Builder(builder: (BuildContext context) {
      _pageProvider = context.watch<ChatPageProvider>();
      return Scaffold(
        // appBar: AppBar(
        //   centerTitle: true,
        //   backgroundColor: const Color.fromRGBO(36, 35, 49, 1.0),
        //   foregroundColor: const Color.fromRGBO(0, 82, 218, 1.0),
        //   title: Text(
        //     widget.chat.title(),
        //     style: const TextStyle(color: Colors.white, fontSize: 16),
        //   ),
        //   actions: [
        //     IconButton(
        //       icon: const Icon(Icons.delete, color: Color.fromRGBO(0, 82, 218, 1.0)),
        //       onPressed: () => _pageProvider.deleteChat(),
        //     ),
        //   ],
        // ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: _deviceWidth * 0.03,
              vertical: _deviceHeight * 0.03,
            ),
            height: _deviceHeight * 0.97,
            width: _deviceWidth * 0.97,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TopBar(
                  barTitle: widget.chat.title(),
                  fontSize: 18,
                  primaryAction: IconButton(
                    icon: const Icon(Icons.delete, color: Color.fromRGBO(0, 82, 218, 1.0)),
                    onPressed: () => _pageProvider.deleteChat(),
                  ),
                  secondaryAction: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Color.fromRGBO(0, 82, 218, 1.0)),
                    onPressed: () => _pageProvider.goBack(),
                  ),
                ),
                _messagesListView(),
                _sendMessageForm(),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _messagesListView() {
    if (_pageProvider.messages != null) {
      if (_pageProvider.messages!.isNotEmpty) {
        return SizedBox(
          height: _deviceHeight * 0.74,
          child: ListView.builder(
              controller: _messagesListViewController,
              itemCount: _pageProvider.messages!.length,
              itemBuilder: (BuildContext context, int index) {
                ChatMessage message = _pageProvider.messages![index];
                bool isOwnMessage = message.userId == _auth.chatUser.uid;
                return CustomChatListViewTile(
                  deviceHeight: _deviceHeight,
                  width: _deviceWidth * 0.80,
                  message: message,
                  isOwnMessage: isOwnMessage,
                  sender: widget.chat.members.where((m) => m.uid == message.userId).first,
                );
              }),
        );
      } else {
        return const Align(
          alignment: Alignment.center,
          child: Text("Be the first to say Hi!", style: TextStyle(color: Colors.white)),
        );
      }
    } else {
      return const Center(child: CircularProgressIndicator(color: Colors.white));
    }
  }

  Widget _sendMessageForm() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(30, 29, 37, 1.0),
        borderRadius: BorderRadius.circular(100),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      child: Form(
        key: _messageFormState,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _messageTextField(),
            _sendMessageButton(),
            _imageMessageButton(),
          ],
        ),
      ),
    );
  }

  Widget _messageTextField() {
    return SizedBox(
      width: _deviceWidth * 0.64,
      child: CustomTextFormField(
        onSaved: (value) => _pageProvider.message = value,
        regEx: r"^(?!\s*$).+",
        hintText: "Type a message",
        obscureText: false,
      ),
    );
  }

  Widget _sendMessageButton() {
    double size = _deviceHeight * 0.05;
    return SizedBox(
      height: size,
      width: size,
      child: IconButton(
        icon: const Icon(Icons.send, color: Colors.white),
        onPressed: () {
          if (_messageFormState.currentState!.validate()) {
            _messageFormState.currentState!.save();
            _pageProvider.sendTextMessage();
            _messageFormState.currentState!.reset();
          }
        },
      ),
    );
  }

  Widget _imageMessageButton() {
    double size = _deviceHeight * 0.04;
    return SizedBox(
      height: size,
      width: size,
      child: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(12, 97, 238, 1.0),
        onPressed: () => _pageProvider.sendImageMessage(),
        child: const Icon(Icons.camera_enhance),
      ),
    );
  }
}
