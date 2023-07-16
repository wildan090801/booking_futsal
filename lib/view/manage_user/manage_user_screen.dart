import 'package:booking_futsal/model/user_model.dart';
import 'package:booking_futsal/state/state_management.dart';
import 'package:booking_futsal/view/manage_user/edit_user_data_screen.dart';
import 'package:booking_futsal/widgets/card_manage_customer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ManageUserScreen extends ConsumerWidget {
  const ManageUserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController searchController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Data Pelanggan',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/add-user');
            },
            icon: const Icon(Icons.add),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
            child: Container(
              height: 34,
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              decoration: BoxDecoration(
                color: const Color(0xffF0F0F0),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                children: [
                  const Positioned(
                    top: 2,
                    bottom: 0,
                    child: Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                  ),
                  TextField(
                    controller: searchController,
                    style: const TextStyle(fontSize: 14),
                    onChanged: (value) {
                      ref
                          .read(searchUserTextProvider.notifier)
                          .update((state) => state = value);
                    },
                    decoration: const InputDecoration(
                      hintText: 'Cari nama pelanggan...',
                      hintStyle: TextStyle(color: Colors.grey),
                      contentPadding: EdgeInsets.only(
                        top: 15,
                        bottom: 8,
                        left: 35,
                        right: 15,
                      ),
                      isDense: true,
                      border: InputBorder.none,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Consumer(builder: (context, ref, _) {
        final searchUserText =
            ref.watch(searchUserTextProvider.notifier).state.toLowerCase();

        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              List<UserModel> userList = snapshot.data!.docs.map((doc) {
                Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                return UserModel.fromJson(data);
              }).toList();

              // Filter berdasarkan nama atau email
              List<UserModel> filteredUsers = userList.where((user) {
                final name = user.name?.toLowerCase() ?? '';
                final email = user.email?.toLowerCase() ?? '';
                return name.contains(searchUserText) ||
                    email.contains(searchUserText);
              }).toList();

              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
                itemCount: filteredUsers.length,
                itemBuilder: (BuildContext context, int index) {
                  UserModel user = filteredUsers[index];
                  return CardManageCustomer(
                    userModel: user,
                    onUpdate: () {
                      _navigateToEditUser(context, user);
                    },
                  );
                },
              );
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error fetching users'));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        );
      }),
    );
  }

  void _navigateToEditUser(BuildContext context, UserModel user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditUserDataScreen(user: user),
      ),
    );
  }
}
