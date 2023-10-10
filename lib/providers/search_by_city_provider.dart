import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laundry_app/data/models/response/shop_model.dart';

final searchByCityStatusProvider = StateProvider.autoDispose((ref) => '');

setSearchByCityStatusProvider(WidgetRef ref, String newStatus) {
  ref.read(searchByCityStatusProvider.notifier).state = newStatus;
}

final searchByCityListProvider =
    StateNotifierProvider.autoDispose<SearchByCityList, List<ShopModel>>(
        (ref) => SearchByCityList([]));

class SearchByCityList extends StateNotifier<List<ShopModel>> {
  SearchByCityList(super.state);

  setData(List<ShopModel> newList) {
    state = newList;
  }
}
