import 'dart:io';

import 'package:akalne/core/features/auth/controller/auth_controller.dart';
import 'package:akalne/restuarant/models/menu_item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/providers/storage_repository_provider.dart';
import '../../../../core/utils.dart';
import '../../../../recipient/models/restaurant_model.dart';
import '../repository/menu_repository.dart';

final menuControllerProvider = StateNotifierProvider<MenuController, bool>(
  (ref) => MenuController(
    menuRepository: ref.watch(menuRepositoryProvider),
    ref: ref,
    storageRepository: ref.watch(storageRepositoryProvider),
  ),
);

final menuItemsProvider = StreamProvider((ref) {
  final controller = ref.watch(menuControllerProvider.notifier);
  return controller.getRestaurantMenuItemsByID();
});

class MenuController extends StateNotifier<bool> {
  final MenuRepository _menuRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;

  MenuController({
    required MenuRepository menuRepository,
    required Ref ref,
    required StorageRepository storageRepository,
  })  : _menuRepository = menuRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  void addProduct(
      {required String productName,
      required String ProductMaxQuantity,
      required String Description,
      required File productImage,
      required BuildContext context}) async {
    state = true;
    String imagePath = "";
    final uuid = Uuid();

    if (productImage != null) {
      final res = await _storageRepository.storeFile(
        file: productImage,
        path: "restaurants/menu",
        id: uuid.v4(),
      );

      res.fold(
        (l) => showSnackBar(context, l.message),
        (r) => imagePath = r,
      );
    }
    RestaurantModel model = _ref.read(restaurantProvider)!;

    MenuItemModel menuItemModel = new MenuItemModel(
      id: uuid.v4(),
      name: productName,
      maximumOrder: int.parse(ProductMaxQuantity),
      description: Description,
      image: imagePath,
      dateAdded: DateTime.now().toString(),
      restaurant: model,
    );
    final result = await _menuRepository.addProduct(menuItemModel);
    state = false;
    result.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        Navigator.pop(context);
      },
    );
  }

  Stream<List<MenuItemModel>> getRestaurantMenuItemsByID() {
    final id = _ref.read(restaurantProvider)!.id ?? "";
    return _menuRepository.getRestaurantMenuItemsByID(id);
  }

  void deleteProduct({required String id, required BuildContext context}) async {
    state = true;
    final restaurantId = _ref.read(restaurantProvider)!.id ?? "";
    final result = await _menuRepository.deleteProduct(id, restaurantId);
    state = false;
    result.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        print("delete");
      },
    );
  }
}
