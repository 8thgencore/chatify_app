import 'package:chatify_app/providers/authentication_provider.dart';
import 'package:chatify_app/widgets/custom_list_view_tiles.dart';
import 'package:chatify_app/widgets/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({Key? key}) : super(key: key);

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  late double _deviceHeight;
  late double _deviceWidth;

  late AuthenticationProvider _auth;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthenticationProvider>(context);
    return _buildUI();
  }

  Widget _buildUI() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: _deviceWidth * 0.03,
        vertical: _deviceHeight * 0.02,
      ),
      height: _deviceHeight * 0.98,
      width: _deviceWidth * 0.97,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TopBar(
            barTitle: "Chats",
            primaryAction: IconButton(
              icon: const Icon(Icons.logout, color: Color.fromRGBO(0, 82, 218, 1.0)),
              onPressed: () => _auth.logout(),
            ),
          ),
          // CustomListViewTileWithActivity(
          //   height: _deviceHeight * 0.10,
          //   title: "Hussain Mustaf",
          //   subtitle: "Subtitile",
          //   imagePath: "https://i.pravatar.cc/300",
          //   isActive: false,
          //   isActivity: false,
          //   onTap: () {},
          // ),
          SizedBox(height: _deviceHeight * 0.04),
        ],
      ),
    );
  }
}
