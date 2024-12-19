import 'dart:convert'; // To decode JSON
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // For making HTTP requests
import 'package:shared_preferences/shared_preferences.dart'; // For using SharedPreferences

class InvitedFriendsPage extends StatefulWidget {
  @override
  _InvitedFriendsPageState createState() => _InvitedFriendsPageState();
}

// Model for Invited Friend
class InvitedFriend {
  final String name;
  final String phoneNumber;

  InvitedFriend({
    required this.name,
    required this.phoneNumber,
  });

  // Factory constructor to create InvitedFriend from JSON
  factory InvitedFriend.fromJson(Map<String, dynamic> json) {
    return InvitedFriend(
      name: json['name'],
      phoneNumber: json['phone'],
    );
  }
}

class _InvitedFriendsPageState extends State<InvitedFriendsPage> {
  List<InvitedFriend> invitedFriends = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchPhoneFromPrefsAndFetchInvitedFriends();
  }

  Future<void> fetchPhoneFromPrefsAndFetchInvitedFriends() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? phone =
        prefs.getString('phone'); // Retrieve phone from SharedPreferences

    if (phone != null) {
      fetchInvitedFriends(phone);
    } else {
      setState(() {
        errorMessage = 'No phone number found in preferences.';
        isLoading = false;
      });
    }
  }

  Future<void> fetchInvitedFriends(String phone) async {
    final String apiUrl = 'https://api.dannycode.site/api/refference';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {'phone': phone}, // Send the reference phone number
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List invitedUsers = data['users']; // Get the list of users
        setState(() {
          invitedFriends =
              invitedUsers.map((user) => InvitedFriend.fromJson(user)).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Không có người dùng nào được mời.';
          isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        errorMessage = 'Failed to load data: $error';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.white,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: Color(0xFF40B59F),
        middle: Text(
          'Danh sách bạn bè đã được mời',
          style: TextStyle(color: CupertinoColors.white),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            CupertinoIcons.back,
            color: Colors.white,
          ),
        ),
      ),
      child: SafeArea(
        child: isLoading
            ? Center(child: CupertinoActivityIndicator())
            : errorMessage.isNotEmpty
                ? Center(
                    child: Text(errorMessage,
                        style: TextStyle(
                            fontSize: 18.0, color: CupertinoColors.black)))
                : ListView.builder(
                    itemCount: invitedFriends.length,
                    itemBuilder: (context, index) {
                      return _buildInvitedFriendItem(
                          context, invitedFriends[index]);
                    },
                  ),
      ),
    );
  }

  Widget _buildInvitedFriendItem(BuildContext context, InvitedFriend friend) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white, // Background color of each list item
        border: Border(
          bottom: BorderSide(
            color: CupertinoColors.separator,
            width: 0.5,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            friend.name,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4.0),
          Text(
            'Số điện thoại: ${friend.phoneNumber}',
            style: TextStyle(
              color: CupertinoColors.systemGrey,
              fontSize: 14.0,
            ),
          ),
        ],
      ),
    );
  }
}
