import 'package:crypt/controllers/assets_controller.dart';
import 'package:crypt/models/tracked_asset.dart';
import 'package:crypt/pages/details_page.dart';
import 'package:crypt/utils.dart';
import 'package:crypt/widgets/add_asset_dilog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  AssetsController assetsController = Get.find();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _appBar(
        context,
      ),
      body: _buildUI(
        context,
      ),
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      title: const CircleAvatar(
          backgroundImage: NetworkImage(
        "https://i.pravatar.cc/150?img=3",
      )),
      actions: [
        IconButton(
            onPressed: () {
              Get.dialog(
                AddAssetDilog(),
              );
            },
            icon: Icon(Icons.add))
      ],
    );
  }

  Widget _buildUI(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          _portfolioValue(
            context,
          ),
          _trackedAssetsList(
            context,
          )
        ],
      ),
    );
  }

  Widget _portfolioValue(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      margin: EdgeInsets.symmetric(
        vertical: MediaQuery.sizeOf(context).height * 0.03,
      ),
      child: Center(
        child: Text.rich(
          textAlign: TextAlign.center,
          TextSpan(children: [
            const TextSpan(
              text: "\$",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextSpan(
              text:
                  "${assetsController.getPortfolioValue().toStringAsFixed(2)}\n",
              style: const TextStyle(
                fontSize: 45,
                fontWeight: FontWeight.w500,
              ),
            ),
            const TextSpan(
              text: "Portfolio Value",
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w200,
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _trackedAssetsList(
    BuildContext context,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.sizeOf(context).width * 0.03,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.05,
            child: const Text(
              "Portfolio",
              style: TextStyle(
                fontSize: 10,
                color: Colors.black38,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.65,
              width: MediaQuery.sizeOf(context).width,
              child: ListView.builder(
                itemCount: assetsController.trackedAssets.length,
                itemBuilder: (context, index) {
                  TrackedAsset trackedAsset =
                      assetsController.trackedAssets[index];
                  return ListTile(
                    leading: Image.network(
                      getCryptoImageURL(trackedAsset.name!),
                    ),
                    title: Text(
                      trackedAsset.name!,
                    ),
                    subtitle: Text(
                        "USD :${assetsController.getAssetPrice(trackedAsset.name!)},"),
                    trailing: Text(
                      trackedAsset.amount.toString(),
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.black38,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () {
                      Get.to(() {
                        return DetailsPage(
                            coin: assetsController
                                .getCoinData(trackedAsset.name!)!);
                      });
                    },
                  );
                },
              ))
        ],
      ),
    );
  }
}
