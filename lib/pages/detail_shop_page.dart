import 'package:d_info/d_info.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:laundry_app/config/app_assets.dart';
import 'package:laundry_app/config/app_colors.dart';
import 'package:laundry_app/config/app_constants.dart';
import 'package:laundry_app/config/app_formats.dart';
import 'package:laundry_app/data/models/response/shop_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

class DetailShopPage extends StatelessWidget {
  const DetailShopPage({super.key, required this.shop});

  final ShopModel shop;

  launchWA(BuildContext context, String number) async {
    bool? yes = await DInfo.dialogConfirmation(
      context,
      'Chat via Whatsapp',
      'Yes to confirm',
    );

    if (yes ?? false) {
      final link = WhatsAppUnilink(
        phoneNumber: number,
        // phoneNumber: '6285864712838',
        text: 'Hello, I want to order a laundry service',
      );
      if (await canLaunchUrl(link.asUri())) {
        launchUrl(link.asUri(), mode: LaunchMode.externalApplication);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          headerContent(context),
          DView.spaceHeight(10),
          groupInfo(),
          DView.spaceHeight(20),
          sectionCategory(),
          DView.spaceHeight(20),
          sectionDescription(),
          DView.spaceHeight(20),
          Container(
            height: 50,
            margin: const EdgeInsets.symmetric(horizontal: 24),
            child: ElevatedButton(
              onPressed: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.shopping_basket,
                    size: 20,
                  ),
                  DView.spaceWidth(6),
                  const Text(
                    'Order Now',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          DView.spaceHeight(15),
          Container(
            height: 50,
            margin: const EdgeInsets.symmetric(horizontal: 24),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color.fromARGB(255, 49, 49, 49).withOpacity(0.7)),
              onPressed: () => launchWA(context, '6282282920710'),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    AppAssets.wa,
                    width: 35,
                  ),
                  DView.spaceWidth(1),
                  const Text(
                    'Whatsapp',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          DView.spaceHeight(20),
        ],
      ),
    );
  }

  Padding sectionDescription() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DView.textTitle('Description', color: Colors.black87),
          DView.spaceHeight(8),
          Text(
            shop.description,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Padding sectionCategory() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DView.textTitle('Category', color: Colors.black87),
          DView.spaceHeight(8),
          Wrap(
            spacing: 6,
            children: [
              'Regular',
              'Express',
              'Economical',
              'Exlusive',
            ].map((itm) {
              return Chip(
                visualDensity: const VisualDensity(vertical: -4),
                label: Text(
                  itm,
                  style: const TextStyle(height: 1),
                ),
                backgroundColor: Colors.white,
                side: const BorderSide(
                  color: AppColors.primaryColor,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Padding groupInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                itemInfo(
                  const Icon(
                    Icons.location_city_rounded,
                    color: AppColors.primaryColor,
                    size: 20,
                  ),
                  shop.city,
                ),
                DView.spaceHeight(6),
                itemInfo(
                  const Icon(
                    Icons.location_on,
                    color: AppColors.primaryColor,
                    size: 20,
                  ),
                  shop.location,
                ),
                DView.spaceHeight(6),
                itemInfo(
                  Image.asset(
                    AppAssets.wa,
                    width: 20,
                  ),
                  shop.whatsapp,
                ),
              ],
            ),
          ),
          DView.spaceWidth(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                AppFormats.longPrice(shop.price),
                textAlign: TextAlign.right,
                style: const TextStyle(
                  height: 1,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              const Text('/kg'),
            ],
          ),
        ],
      ),
    );
  }

  Row itemInfo(Widget icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 30,
          height: 20,
          alignment: Alignment.centerLeft,
          child: icon,
        ),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  Padding headerContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: AspectRatio(
        aspectRatio: 1,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.network(
                '${AppConstants.baseImageUrl}/shop/${shop.image}',
                fit: BoxFit.cover,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: AspectRatio(
                aspectRatio: 2,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: const LinearGradient(
                      colors: [
                        Colors.black,
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        shop.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      DView.spaceHeight(8),
                      Row(
                        children: [
                          RatingBar.builder(
                            initialRating: shop.rate,
                            itemCount: 5,
                            allowHalfRating: true,
                            itemPadding: const EdgeInsets.all(0),
                            unratedColor: Colors.grey[300],
                            itemBuilder: (context, index) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            itemSize: 12,
                            onRatingUpdate: (value) {},
                            ignoreGestures: true,
                          ),
                          DView.spaceWidth(4),
                          Text(
                            '(${shop.rate})',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      !shop.pickup && !shop.delivery
                          ? DView.nothing()
                          : Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: Row(
                                children: [
                                  if (shop.pickup) childOrder('Pickup'),
                                  if (shop.delivery) DView.spaceWidth(8),
                                  if (shop.delivery) childOrder('Delivery'),
                                ],
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 36,
              left: 16,
              child: SizedBox(
                height: 36,
                child: FloatingActionButton.extended(
                  heroTag: 'fab-back-button',
                  icon: const Icon(Icons.navigate_before),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  extendedIconLabelSpacing: 0,
                  extendedPadding: const EdgeInsets.only(right: 16, left: 10),
                  backgroundColor: Colors.white,
                  label: const Text(
                    'Back',
                    style: TextStyle(
                      height: 1,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container childOrder(String name) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            name,
            style: const TextStyle(color: Colors.white, height: 1),
          ),
          DView.spaceWidth(4),
          const Icon(
            Icons.check_circle,
            color: Colors.white,
            size: 14,
          ),
        ],
      ),
    );
  }
}
