import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controller/database_controller.dart';
import '../models/product_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DataBaseController dataBaseController = Get.find();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await dataBaseController.loadString(
          path: "assets/json/product_data.json");
      await dataBaseController.init();
      await dataBaseController.insertBulkRecord();
      await dataBaseController.fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.grey,
      body: Obx(() => (dataBaseController.productFetchData.value.isEmpty)
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.06, vertical: size.width * 0.05),
              child: Column(
                children: [
                  Expanded(
                      child: ListView.builder(
                    itemCount: dataBaseController.productFetchData.length,
                    itemBuilder: (context, index) {
                      Product product =
                          dataBaseController.productFetchData[index];

                      return Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(bottom: 10),
                        clipBehavior: Clip.none,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  offset: Offset(0, 2),
                                  blurRadius: 2,
                                  spreadRadius: 0.3)
                            ],
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          children: [
                            Container(
                              width: size.width * 0.9,
                              height: size.width * 0.5,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Container(
                                width: size.width * 0.7,
                                height: size.width * 0.5,
                                decoration: BoxDecoration(),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: MemoryImage(
                                        base64Decode(product.image!),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 100),
                                  child: Text(
                                    "${product.name}",
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Container(
                                  margin: EdgeInsets.only(left: 100),
                                  child: Row(
                                    children: [
                                      const Text("Quantity: ",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18)),
                                      Text(
                                        "${product.quantity}",
                                        style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),
                                if (product.quantity != 0)
                                  InkWell(
                                    onTap: () {
                                      if (dataBaseController
                                                  .randomNumber.value ==
                                              index &&
                                          dataBaseController.countDown.value >=
                                              20) {
                                        dataBaseController.isAddToCart(true);
                                      }

                                      dataBaseController.addToCart(
                                          product: product);
                                    },
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 10),
                                      decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Text("Add To Cart",
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                  ),
                                SizedBox(height: 10),
                                if (index ==
                                    dataBaseController.randomNumber.value) ...[
                                  Text(
                                    "Out Of Stock",
                                    style: const TextStyle(
                                        color: Colors.red, fontSize: 16),
                                  ),
                                  SizedBox(width: 10),
                                  Obx(
                                    () => Text(
                                      "${dataBaseController.countDown.value}",
                                      style: const TextStyle(
                                          color: Colors.red, fontSize: 16),
                                    ),
                                  )
                                ]
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ))
                ],
              ),
            )),
    );
  }
}
