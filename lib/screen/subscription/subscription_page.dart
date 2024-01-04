import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_app/constant/color.dart';
import 'package:video_app/constant/widget/expanded_title.dart';
import 'package:video_app/screen/subscription/widget/all_cat_month.dart';
import 'package:video_app/screen/subscription/widget/single_cat_month.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Subscription'.tr,
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('price')
              .doc('ehEWIZZymdNkj7UZz2CM9L7zBUd2')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  color: appColor1,
                ),
              );
            }
            if (!snapshot.data!.exists) {
              return const Center(
                child: Text('No Data'),
              );
            }
            return Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      SingleCatMonth(
                          index: 0,
                          selectIndex: index,
                          price: '\$${snapshot.data!['single']}.00 / month',
                          onTap: () {
                            setState(() {
                              index = 0;
                            });
                          }),
                      const SizedBox(width: 15),
                      AllCatMonth(
                          index: 1,
                          selectIndex: index,
                          price: '\$${snapshot.data!['all']}.00 / month',
                          onTap: () {
                            setState(() {
                              index = 1;
                            });
                          }),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Spacer(),
                  ExpandTileWidget(
                    amount: index == 0
                        ? snapshot.data!['single']
                        : snapshot.data!['all'],
                    index: index,
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            );
          }),
    );
  }
}
