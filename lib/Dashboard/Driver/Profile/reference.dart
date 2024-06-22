import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Model for Invited Friend
class InvitedFriend {
  final String name;
  final String phoneNumber; // Phone number of the invited friend

  InvitedFriend({
    required this.name,
    required this.phoneNumber,
  });
}

class InvitedFriendsPage extends StatelessWidget {
  // Dummy list of invited friends
  final List<InvitedFriend> invitedFriends = [
    InvitedFriend(
      name: 'Phạm Thiên Đăng',
      phoneNumber: '+1234567890',
    ),
    InvitedFriend(
      name: 'Nghèo',
      phoneNumber: '+0987654321',
    ),
    InvitedFriend(
      name: 'Vãi Chưởng',
      phoneNumber: '+1357924680',
    ),
    InvitedFriend(
      name: 'Ước Mơ',
      phoneNumber: '+1357924680',
    ),
    InvitedFriend(
      name: 'Giàu Như Bác Lợi',
      phoneNumber: '+1357924680',
    ),
    InvitedFriend(
      name: 'Có Giàn PC xịn cùng màn hình',
      phoneNumber: '+1357924680',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: Color(0xFF40B59F), // Set navigation bar color
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
        child: ListView.builder(
          itemCount: invitedFriends.length,
          itemBuilder: (context, index) {
            return _buildInvitedFriendItem(context, invitedFriends[index]);
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
