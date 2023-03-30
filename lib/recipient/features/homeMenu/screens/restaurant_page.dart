import 'package:akalne/core/common/loader.dart';
import 'package:akalne/core/models/menu_item_model.dart';
import 'package:akalne/core/models/restaurant_model.dart';
import 'package:akalne/recipient/features/homeMenu/controller/home_menu_controller.dart';
import 'package:akalne/recipient/features/homeMenu/screens/widgets/back_button.dart';
import 'package:akalne/recipient/features/homeMenu/screens/widgets/food_item_card.dart';
import 'package:akalne/recipient/features/homeMenu/screens/widgets/image_with_shadow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestaurantPage extends ConsumerStatefulWidget {
  const RestaurantPage({
    super.key,
    required this.restaurantDetails,
  });

  final RestaurantModel restaurantDetails;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RestaurantPageState();
}

class _RestaurantPageState extends ConsumerState<RestaurantPage> {
  late HomeMenuController _controller;
  late List<MenuItemModel> _menuItems;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    _controller = ref.read(homeMenuControllerProvider.notifier);
    getData();
  }

  void getData() async {
    setState(() {
      isLoading = true;
    });

    _menuItems = await _controller
        .getMenuItemsByID(widget.restaurantDetails.id as String);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Loader()
        : Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10, right: 32, left: 32),
                    child: Column(
                      children: [
                        const CustomBackButton(),
                        const SizedBox(height: 10),
                        ImageWithShadow(
                          restaurantDetails: widget.restaurantDetails,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: const [
                            Text(
                              "Available Meals",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _menuItems.length,
                      itemBuilder: (context, index) {
                        return FoodItemCard(
                          menuItemModel: _menuItems[index],
                          isReplace: true,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
