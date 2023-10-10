import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundry_app/config/app_assets.dart';
import 'package:laundry_app/config/app_constants.dart';
import 'package:laundry_app/config/exception_response.dart';
import 'package:laundry_app/config/navigation.dart';
import 'package:laundry_app/data/models/response/shop_model.dart';
import 'package:laundry_app/datasources/shop_datasource.dart';
import 'package:laundry_app/pages/detail_shop_page.dart';
import 'package:laundry_app/providers/search_by_city_provider.dart';

class SearchByCityPage extends ConsumerStatefulWidget {
  const SearchByCityPage({
    super.key,
    required this.query,
  });

  final String query;

  @override
  ConsumerState<SearchByCityPage> createState() => _SearchByCityPageState();
}

class _SearchByCityPageState extends ConsumerState<SearchByCityPage> {
  final edtSearch = TextEditingController();

  executeSearch() {
    ShopDatasource.getSearchByCity(edtSearch.text).then((result) {
      setSearchByCityStatusProvider(ref, 'Loading');
      result.fold(
        (failure) {
          switch (failure.runtimeType) {
            case ServerFailure:
              setSearchByCityStatusProvider(ref, 'Server Error');
              break;
            case NotFoundFailure:
              setSearchByCityStatusProvider(ref, 'Not Found');
              break;
            case ForbidenFailure:
              setSearchByCityStatusProvider(ref, 'You don\'t have access');
              break;
            case BadRequestFailure:
              setSearchByCityStatusProvider(ref, 'Bad request');
              break;
            case UnauthorizedFailure:
              setSearchByCityStatusProvider(ref, 'Unauthorised');
              break;
            default:
              setSearchByCityStatusProvider(ref, 'Request Error');
              break;
          }
        },
        (data) {
          setSearchByCityStatusProvider(ref, 'Success');
          List datas = data['data'];
          List<ShopModel> promos = datas.map((item) {
            return ShopModel.fromJson(item);
          }).toList();

          ref.read(searchByCityListProvider.notifier).setData(promos);
        },
      );
    });
  }

  @override
  void initState() {
    if (widget.query != '') {
      edtSearch.text = widget.query;

      executeSearch();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              const Text(
                'City: ',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                  height: 1,
                ),
              ),
              Expanded(
                child: TextField(
                  controller: edtSearch,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  style: const TextStyle(height: 1),
                  onSubmitted: (value) => executeSearch(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => executeSearch(),
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Consumer(
        builder: (_, wiRef, __) {
          String status = wiRef.watch(searchByCityStatusProvider);
          List<ShopModel> listData = wiRef.watch(searchByCityListProvider);

          if (status == '') {
            return DView.nothing();
          }

          if (status == 'Loading') {
            return DView.loadingCircle();
          }

          if (status == 'Success') {
            return ListView.builder(
              itemCount: listData.length,
              itemBuilder: (context, index) {
                ShopModel items = listData[index];
                return GestureDetector(
                  onTap: () {
                    Nav.push(context, DetailShopPage(shop: items));
                  },
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      15,
                      index == 0 ? 15 : 5,
                      15,
                      index == listData.length - 1 ? 15 : 5,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 75,
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: FadeInImage(
                                  placeholder: const AssetImage(
                                      AppAssets.placeholderLaundry),
                                  image: NetworkImage(
                                      '${AppConstants.baseImageUrl}/shop/${items.image}'),
                                  fit: BoxFit.cover,
                                  imageErrorBuilder:
                                      (context, error, stackTrace) {
                                    return const Icon(Icons.error);
                                  },
                                ),
                              ),
                            ),
                          ),
                          DView.spaceWidth(10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'loremmsmsmsmmsknsksnksnks ksnsknsknsksnks knsnsksnksnk',
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    // height: 1,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                DView.spaceHeight(4),
                                Text(
                                  items.location,
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                DView.spaceHeight(4),
                                Row(
                                  children: [
                                    RatingBar.builder(
                                      itemCount: 5,
                                      initialRating: items.rate,
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
                                      '(${items.rate})',
                                      style: const TextStyle(
                                        color: Colors.black87,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                Nav.push(context, DetailShopPage(shop: items));
                              },
                              icon: const Icon(Icons.navigate_next))
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return DView.error(status);
        },
      ),
    );
  }
}
