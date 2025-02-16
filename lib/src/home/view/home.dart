import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:odoo_common_code_latest/common/config/app_colors.dart';
import 'package:odoo_common_code_latest/common/utils/utils.dart';
import 'package:odoo_common_code_latest/common/widgets/main_container.dart';
import 'package:odoo_common_code_latest/src/home/controller/home_controller.dart';
import 'package:odoo_common_code_latest/src/job_card/view/job_card_create.dart';
import 'package:odoo_common_code_latest/src/home/view/new_contact_form.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _homeController = Get.put(HomeController());
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _homeController.getPartners();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          title: Text('SoftCroft'),
          automaticallyImplyLeading: false,
        ),
      ),
      body: _currentIndex == 0 ? _buildContacts() : Container(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts),
            label: 'Contacts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'Job Card',
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_currentIndex == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NewContactForm()),
            );
          } else if (_currentIndex == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => JobCardCreate()),
            );
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildContacts() {
    return Obx(
      () {
        return ListView.builder(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          itemCount: _homeController.listOfPartners.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: _homeController
                        .listOfPartners[index].image512!.isNotEmpty
                    ? Image.memory(
                        base64.decode(
                            _homeController.listOfPartners[index].image512!),
                        height: 40,
                        width: 40,
                      )
                    : Icon(
                        Icons.person,
                        color: AppColors.grey,
                        size: 40,
                      ),
              ),
              title: Text(_homeController.listOfPartners[index].name!),
              subtitle: Text(_homeController.listOfPartners[index].email!),
            );
          },
        );
      },
    );
  }
}
