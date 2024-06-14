import 'package:crypt/controllers/assets_controller.dart';
import 'package:crypt/models/api_response.dart';
import 'package:crypt/services/http_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddAssetDilogController extends GetxController {
  RxBool loading = false.obs;
  RxList<String> assets = <String>[].obs;
  RxString selectedAsset = "".obs;
  RxDouble assetValue = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    _getAssets();
  }

  Future<void> _getAssets() async {
    loading.value = true;
    HTTPService httpService = Get.find();
    var responseData = await httpService.get("currencies");
    CurrenciesListAPIResponse currenciesListAPIResponse =
        CurrenciesListAPIResponse.fromJson(responseData);
    currenciesListAPIResponse.data?.forEach((coin) {
      assets.add(
        coin.name!,
      );
    });
    selectedAsset.value = assets.first;

    loading.value = false;
  }
}

class AddAssetDilog extends StatelessWidget {
  final controller = Get.put(
    AddAssetDilogController(),
  );
  AddAssetDilog({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Center(
        child: Material(
          child: Container(
            height: MediaQuery.sizeOf(context).height * 0.40,
            width: MediaQuery.sizeOf(context).width * .80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                15,
              ),
              color: Colors.white,
            ),
            child: _buildUI(
              context,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUI(
    BuildContext context,
  ) {
    if (controller.loading.isTrue) {
      return const Center(
          child: SizedBox(
        height: 30,
        width: 30,
        child: CircularProgressIndicator(),
      ));
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DropdownButton(
                value: controller.selectedAsset.value,
                items: controller.assets.map((asset) {
                  return DropdownMenuItem(
                      value: asset,
                      child: Text(
                        asset,
                      ));
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    controller.selectedAsset.value = value;
                  }
                }),
            TextField(
              onChanged: (value) {
                controller.assetValue.value = double.parse(
                  value,
                );
              },
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            MaterialButton(
              onPressed: () {
                AssetsController assetsController = Get.find();
                assetsController.addTrackedAsset(controller.selectedAsset.value,
                    controller.assetValue.value);
                Get.back(
                  closeOverlays: true,
                );
              },
              color: Theme.of(context).colorScheme.primary,
              child: const Text(
                "Add Asset",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      );
    }
  }
}
