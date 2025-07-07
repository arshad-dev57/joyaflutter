import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joya_app/controllers/user_controller.dart';

class AllUsersScreen extends StatelessWidget {
  AllUsersScreen({super.key});
  final UsersController controller = Get.put(UsersController());

  final roles = ['All', 'user', 'vendor', 'admin'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
              ),
              child: Row(
                children: const [
                  Icon(Icons.group, color: Colors.deepPurple),
                  SizedBox(width: 8),
                  Text(
                    'All Users',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.deepPurple),
                  ),
                ],
              ),
            ),

            // 🔍 Search + 🔽 Filter Dropdown
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (val) {
                        controller.searchQuery.value = val;
                        controller.filterUsers();
                      },
                      decoration: InputDecoration(
                        hintText: "Search user...",
                        prefixIcon: Icon(Icons.search),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Obx(() {
                    return DropdownButton<String>(
                      value: controller.selectedRole.value,
                      items: roles
                          .map((role) => DropdownMenuItem(
                                value: role,
                                child: Text(role[0].toUpperCase() + role.substring(1)),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          controller.selectedRole.value = value;
                          controller.filterUsers();
                        }
                      },
                      borderRadius: BorderRadius.circular(10),
                      underline: Container(),
                    );
                  }),
                ],
              ),
            ),

            // 👥 User List
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.filteredList.isEmpty) {
                  return const Center(child: Text('No users found.'));
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.filteredList.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final user = controller.filteredList[index];
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(color: Color(0x1F000000), blurRadius: 8, offset: Offset(0, 4)),
                        ],
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 30,
                            backgroundColor: Color(0xFFD1C4E9),
                            child: Icon(Icons.person, color: Colors.white, size: 30),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${user.firstname} ${user.lastname}',
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: user.role == 'vendor'
                                            ? Colors.orange.shade100
                                            : Colors.blue.shade100,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        user.role.toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: user.role == 'vendor'
                                              ? Colors.orange.shade800
                                              : Colors.blue.shade800,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(user.email, style: const TextStyle(color: Colors.grey, fontSize: 14)),
                                const SizedBox(height: 4),
                                Row(children: [
                                  const Icon(Icons.phone, size: 14, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(user.phone, style: const TextStyle(fontSize: 13)),
                                ]),
                                const SizedBox(height: 4),
                                Row(children: [
                                  const Icon(Icons.flag, size: 14, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(user.country.join(', '), style: const TextStyle(fontSize: 13)),
                                ]),
                                const SizedBox(height: 4),
                                Row(children: [
                                  const Icon(Icons.language, size: 14, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(user.language, style: const TextStyle(fontSize: 13)),
                                ]),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
