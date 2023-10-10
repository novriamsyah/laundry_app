import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laundry_app/data/models/response/laundry_model.dart';

final laundryStatusProvider = StateProvider.autoDispose((ref) => '');

setLaundryStatusProvider(WidgetRef ref, String newStatus) {
  ref.read(laundryStatusProvider.notifier).state = newStatus;
}

final laundryCategoryStatusProvider = StateProvider.autoDispose((ref) => 'All');

setLaundryCategoryStatusProvider(WidgetRef ref, String newStatus) {
  ref.read(laundryCategoryStatusProvider.notifier).state = newStatus;
}

final laundryDataListProvider =
    StateNotifierProvider.autoDispose<LaundryDataList, List<LaundryModel>>(
        (ref) => LaundryDataList([]));

class LaundryDataList extends StateNotifier<List<LaundryModel>> {
  LaundryDataList(super.state);

  setData(List<LaundryModel> newList) {
    state = newList;
  }
}
