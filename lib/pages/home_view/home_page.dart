import 'package:d_button/d_button.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundry_app/config/app_assets.dart';
import 'package:laundry_app/config/app_colors.dart';
import 'package:laundry_app/config/app_constants.dart';
import 'package:laundry_app/config/app_formats.dart';
import 'package:laundry_app/config/exception_response.dart';
import 'package:laundry_app/config/navigation.dart';
import 'package:laundry_app/data/models/response/promo_model.dart';
import 'package:laundry_app/data/models/response/shop_model.dart';
import 'package:laundry_app/datasources/promo_datasource.dart';
import 'package:laundry_app/datasources/shop_datasource.dart';
import 'package:laundry_app/pages/detail_shop_page.dart';
import 'package:laundry_app/pages/search_by_city_page.dart';
import 'package:laundry_app/pages/widgets/home_empty_page.dart';
import 'package:laundry_app/providers/home_provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  static final edtSearch = TextEditingController();
  gotoSearchCity() {
    Nav.push(context, SearchByCityPage(query: edtSearch.text));
  }

  getPromoLimit() {
    PromoDatasource.getPromos().then((result) {
      result.fold(
        (failure) {
          switch (failure.runtimeType) {
            case ServerFailure:
              setHomePromoStatusProvider(ref, 'Server Error');
              break;
            case NotFoundFailure:
              setHomePromoStatusProvider(ref, 'Error Not Found');
              break;
            case ForbidenFailure:
              setHomePromoStatusProvider(ref, 'You don\'t have access');
              break;
            case BadRequestFailure:
              setHomePromoStatusProvider(ref, 'Bad request');
              break;
            case UnauthorizedFailure:
              setHomePromoStatusProvider(ref, 'Unauthorised');
              break;
            default:
              setHomePromoStatusProvider(ref, 'Request Error');
              break;
          }
        },
        (data) {
          setHomePromoStatusProvider(ref, 'success');
          List datas = data['data'];
          List<PromoModel> promos = datas.map((item) {
            return PromoModel.fromJson(item);
          }).toList();
          ref.read(homePromoListProvider.notifier).setData(promos);
        },
      );
    });
  }

  getrecommendationLimit() {
    ShopDatasource.getRecommendLimit().then((result) {
      result.fold(
        (failure) {
          switch (failure.runtimeType) {
            case ServerFailure:
              setHomeRecommendStatusProvider(ref, 'Server Error');
              break;
            case NotFoundFailure:
              setHomeRecommendStatusProvider(ref, 'Error Not Found');
              break;
            case ForbidenFailure:
              setHomeRecommendStatusProvider(ref, 'You don\'t have access');
              break;
            case BadRequestFailure:
              setHomeRecommendStatusProvider(ref, 'Bad request');
              break;
            case UnauthorizedFailure:
              setHomeRecommendStatusProvider(ref, 'Unauthorised');
              break;
            default:
              setHomeRecommendStatusProvider(ref, 'Request Error');
              break;
          }
        },
        (data) {
          setHomeRecommendStatusProvider(ref, 'success');
          List datas = data['data'];
          List<ShopModel> recommendShops = datas.map((item) {
            return ShopModel.fromJson(item);
          }).toList();
          ref.read(homeRecommendListProvider.notifier).setData(recommendShops);
        },
      );
    });
  }

  getDataRefresh() {
    getPromoLimit();
    getrecommendationLimit();
  }

  @override
  void initState() {
    getDataRefresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => getDataRefresh(),
      child: ListView(
        children: [
          header(),
          category(),
          DView.spaceHeight(20),
          listPromo(),
          DView.spaceHeight(20),
          shopRecomend(),
        ],
      ),
    );
  }

  Consumer shopRecomend() {
    return Consumer(
      builder: (_, wiRef, __) {
        List<ShopModel> listShop = wiRef.watch(homeRecommendListProvider);
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DView.textTitle('Recommendation', color: Colors.black),
                  DView.textAction(() {}, color: AppColors.primaryColor),
                ],
              ),
            ),
            if (listShop.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Align(
                      alignment: Alignment.center,
                      child: HomeEmptyPage(
                          ratio: 16 / 9, message: 'No recommendation Yet')),
                ),
              ),
            if (listShop.isNotEmpty)
              SizedBox(
                height: 250,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: listShop.length,
                  itemBuilder: (context, index) {
                    ShopModel itemShop = listShop[index];
                    return GestureDetector(
                      onTap: () {
                        Nav.push(context, DetailShopPage(shop: itemShop));
                      },
                      child: Container(
                        margin: EdgeInsets.fromLTRB(
                          index == 0 ? 30 : 10,
                          0,
                          index == listShop.length - 1 ? 30 : 10,
                          0,
                        ),
                        width: 200,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: FadeInImage(
                                placeholder: const AssetImage(
                                    AppAssets.placeholderLaundry),
                                image: NetworkImage(
                                    '${AppConstants.baseImageUrl}/shop/${itemShop.image}'),
                                fit: BoxFit.cover,
                                imageErrorBuilder:
                                    (context, error, stackTrace) {
                                  return const Icon(Icons.error);
                                },
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: 150,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                  gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black,
                                      ]),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 8,
                              bottom: 8,
                              right: 8,
                              child: Column(
                                children: [
                                  Row(
                                    children: ['Regular', 'Express'].map((e) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          color: Colors.green.withOpacity(0.8),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        margin: const EdgeInsets.only(right: 4),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        child: Text(
                                          e,
                                          style: const TextStyle(
                                            height: 1,
                                            color: Colors.white,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                  DView.spaceHeight(8),
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          itemShop.name,
                                          style: GoogleFonts.ptSans(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                        DView.spaceHeight(4),
                                        Row(
                                          children: [
                                            RatingBar.builder(
                                              itemCount: 5,
                                              initialRating: itemShop.rate,
                                              allowHalfRating: true,
                                              itemSize: 12,
                                              itemBuilder: (context, index) {
                                                return const Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                );
                                              },
                                              unratedColor: Colors.grey[300],
                                              onRatingUpdate: (value) {},
                                              ignoreGestures: true,
                                            ),
                                            DView.spaceWidth(4),
                                            Text(
                                              '(${itemShop.rate})',
                                              style: const TextStyle(
                                                color: Colors.black87,
                                                fontSize: 11,
                                              ),
                                            ),
                                          ],
                                        ),
                                        DView.spaceHeight(4),
                                        Text(
                                          itemShop.location,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }

  Consumer listPromo() {
    final pageController = PageController();
    return Consumer(
      builder: (_, wiRef, __) {
        List<PromoModel> dataPromos = wiRef.watch(homePromoListProvider);
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DView.textTitle('Promo', color: Colors.black),
                  DView.textAction(() {}, color: AppColors.primaryColor),
                ],
              ),
            ),
            if (dataPromos.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Align(
                      alignment: Alignment.center,
                      child: HomeEmptyPage(
                          ratio: 16 / 9, message: 'No Yet Promo')),
                ),
              ),
            if (dataPromos.isNotEmpty)
              AspectRatio(
                aspectRatio: 16 / 9,
                child: PageView.builder(
                  controller: pageController,
                  itemCount: dataPromos.length,
                  itemBuilder: (context, index) {
                    PromoModel itemPromo = dataPromos[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: FadeInImage(
                                placeholder: const AssetImage(
                                    AppAssets.placeholderLaundry),
                                image: NetworkImage(
                                    '${AppConstants.baseImageUrl}/promo/${itemPromo.image}'),
                                fit: BoxFit.cover,
                                imageErrorBuilder:
                                    (context, error, stackTrace) {
                                  return const Icon(Icons.error);
                                },
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 6,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    itemPromo.shop.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  DView.spaceHeight(4),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '${AppFormats.shortPrice(itemPromo.newPrice)} /kg',
                                        style: const TextStyle(
                                          color: Colors.green,
                                        ),
                                      ),
                                      DView.spaceWidth(),
                                      Text(
                                        '${AppFormats.shortPrice(itemPromo.oldPrice)} /kg',
                                        style: const TextStyle(
                                          color: Colors.red,
                                          decoration:
                                              TextDecoration.lineThrough,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            if (dataPromos.isNotEmpty) DView.spaceHeight(8),
            if (dataPromos.isNotEmpty)
              SmoothPageIndicator(
                controller: pageController,
                count: dataPromos.length,
                effect: WormEffect(
                  dotHeight: 4,
                  dotWidth: 12,
                  dotColor: Colors.grey[300]!,
                  activeDotColor: AppColors.primaryColor,
                ),
              ),
          ],
        );
      },
    );
  }

  Consumer category() {
    return Consumer(
      builder: (_, wiRef, __) {
        String selectedCategory = wiRef.watch(homeSelectedCategoryProvider);
        return SizedBox(
          height: 30,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: AppConstants.homeCategories.length,
            itemBuilder: (context, index) {
              String currentCategory = AppConstants.homeCategories[index];

              return Padding(
                padding: EdgeInsets.fromLTRB(
                    index == 0 ? 30 : 8,
                    0,
                    index == AppConstants.homeCategories.length - 1 ? 30 : 8,
                    0),
                child: InkWell(
                  onTap: () {
                    setHomeSelectedCategory(ref, currentCategory);
                  },
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: currentCategory == selectedCategory
                            ? Colors.green
                            : Colors.grey[400]!,
                      ),
                      color: currentCategory == selectedCategory
                          ? Colors.green
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      currentCategory,
                      style: TextStyle(
                        height: 1,
                        color: selectedCategory == currentCategory
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Padding header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 20, 30, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'We\'re ready',
            style: GoogleFonts.ptSans(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          DView.spaceHeight(4),
          Text(
            'to clean your clothes',
            style: GoogleFonts.ptSans(
              color: Colors.black54,
              fontSize: 20,
              fontWeight: FontWeight.w400,
              height: 1,
            ),
          ),
          DView.spaceHeight(20),
          Row(
            children: [
              const Icon(
                Icons.location_city,
                color: Colors.green,
                size: 20,
              ),
              DView.spaceWidth(4),
              Text(
                'Find by city',
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          DView.spaceHeight(8),
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => gotoSearchCity(),
                          icon: const Icon(Icons.search),
                        ),
                        Expanded(
                          child: TextField(
                            controller: edtSearch,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Search...',
                            ),
                            onSubmitted: (value) => gotoSearchCity(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                DView.spaceWidth(),
                DButtonElevation(
                  onClick: () {},
                  mainColor: Colors.green,
                  splashColor: Colors.greenAccent,
                  width: 50,
                  radius: 10,
                  child: const Icon(Icons.tune, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
