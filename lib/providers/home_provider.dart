import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laundry_app/data/models/response/promo_model.dart';
import 'package:laundry_app/data/models/response/shop_model.dart';

final homeSelectedCategoryProvider = StateProvider.autoDispose((ref) => 'All');
final homePromoStatusProvider = StateProvider.autoDispose((ref) => '');
final homeRecommendStatusProvider = StateProvider.autoDispose((ref) => '');

setHomeSelectedCategory(WidgetRef ref, String newValue) {
  ref.read(homeSelectedCategoryProvider.notifier).state = newValue;
}

setHomePromoStatusProvider(WidgetRef ref, String newValue) {
  ref.read(homePromoStatusProvider.notifier).state = newValue;
}

setHomeRecommendStatusProvider(WidgetRef ref, String newValue) {
  ref.read(homeRecommendStatusProvider.notifier).state = newValue;
}

final homePromoListProvider =
    StateNotifierProvider.autoDispose<HomePromoList, List<PromoModel>>(
        (ref) => HomePromoList([]));

class HomePromoList extends StateNotifier<List<PromoModel>> {
  HomePromoList(super.state);

  setData(List<PromoModel> newData) {
    state = newData;
  }
}

final homeRecommendListProvider =
    StateNotifierProvider.autoDispose<HomeRecommedList, List<ShopModel>>(
        (ref) => HomeRecommedList([]));

class HomeRecommedList extends StateNotifier<List<ShopModel>> {
  HomeRecommedList(super.state);

  setData(List<ShopModel> newData) {
    state = newData;
  }
}
