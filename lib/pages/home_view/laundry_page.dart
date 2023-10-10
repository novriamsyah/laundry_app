import 'package:d_input/d_input.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:laundry_app/config/app_constants.dart';
import 'package:laundry_app/config/app_formats.dart';
import 'package:laundry_app/config/app_response.dart';
import 'package:laundry_app/config/app_sessions.dart';
import 'package:laundry_app/config/custom_snackbar.dart';
import 'package:laundry_app/config/navigation.dart';
import 'package:laundry_app/data/models/response/laundry_model.dart';
import 'package:laundry_app/data/models/response/user_model.dart';
import 'package:laundry_app/datasources/laundry_datsource.dart';
import 'package:laundry_app/pages/detail_laundry_page.dart';
import 'package:laundry_app/pages/widgets/home_empty_page.dart';
import 'package:laundry_app/providers/laundry_provider.dart';

import '../../config/exception_response.dart';

class LaundryPage extends ConsumerStatefulWidget {
  const LaundryPage({super.key});

  @override
  ConsumerState<LaundryPage> createState() => _LaundryPageState();
}

class _LaundryPageState extends ConsumerState<LaundryPage> {
  late UserModel user;

  getMyLaundry() {
    LaundryDatasource().readByUser(user.id).then((value) {
      value.fold(
        (failure) {
          switch (failure.runtimeType) {
            case ServerFailure:
              setLaundryStatusProvider(ref, 'Server Error');
              break;
            case NotFoundFailure:
              setLaundryStatusProvider(ref, 'Not Found');
              break;
            case ForbidenFailure:
              setLaundryStatusProvider(ref, 'You don\'t have access');
              break;
            case BadRequestFailure:
              setLaundryStatusProvider(ref, 'Bad request');
              break;
            case UnauthorizedFailure:
              setLaundryStatusProvider(ref, 'Unauthorised');
              break;
            default:
              setLaundryStatusProvider(ref, 'Request Error');
              break;
          }
        },
        (result) {
          setLaundryStatusProvider(ref, 'Success');
          List data = result['data'];
          List<LaundryModel> laundries =
              data.map((itm) => LaundryModel.fromJson(itm)).toList();
          ref.read(laundryDataListProvider.notifier).setData(laundries);
        },
      );
    });
  }

  dialogClaim() {
    final edtLaundryID = TextEditingController();
    final edtClaimCode = TextEditingController();
    final formKey = GlobalKey<FormState>();
    showDialog(
      context: context,
      builder: (context) {
        return Form(
          key: formKey,
          child: SimpleDialog(
            titlePadding: const EdgeInsets.all(16),
            contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            title: const Text('Claim Laundry'),
            children: [
              DInput(
                controller: edtLaundryID,
                title: 'Laundry ID',
                radius: BorderRadius.circular(10),
                validator: (input) => input == '' ? "Don't empty" : null,
                inputType: TextInputType.number,
              ),
              DView.spaceHeight(),
              DInput(
                controller: edtClaimCode,
                title: 'Claim Code',
                radius: BorderRadius.circular(10),
                validator: (input) => input == '' ? "Don't empty" : null,
              ),
              DView.spaceHeight(20),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    Navigator.pop(context);
                    claimNow(edtLaundryID.text, edtClaimCode.text);
                  }
                },
                child: const Text('Claim Now'),
              ),
              DView.spaceHeight(8),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ],
          ),
        );
      },
    );
  }

  claimNow(String id, String claimCode) {
    LaundryDatasource.claim(id, claimCode).then((value) {
      value.fold(
        (failure) {
          switch (failure.runtimeType) {
            case ServerFailure:
              ShowSnackbarCustom.showCustomSnackbarError(
                  context, 'Server Error');
              break;
            case NotFoundFailure:
              ShowSnackbarCustom.showCustomSnackbarError(
                  context, 'Not Found');
              break;
            case ForbidenFailure:
              ShowSnackbarCustom.showCustomSnackbarError(
                  context, 'You don\'t have access');
              break;
            case BadRequestFailure:
              ShowSnackbarCustom.showCustomSnackbarError(
                  context, 'Laundry has been claimed');
              break;
            case InvalidInputFailur:
              AppResponse.invalidInput(context, failure.message ?? '{}');
              break;
            case UnauthorizedFailure:
              ShowSnackbarCustom.showCustomSnackbarError(
                  context, 'Unauthorised');
              break;
            default:
              ShowSnackbarCustom.showCustomSnackbarError(
                  context, 'Request Error');
              break;
          }
        },
        (result) {
          ShowSnackbarCustom.showCustomSnackbarSuccess(
                  context, 'Claim Success');
          getMyLaundry();
        },
      );
    });
  }

  @override
  void initState() {
    AppSessions.getUser().then((value) {
      user = value!;
      getMyLaundry();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        header(),
        categories(),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async => getMyLaundry(),
            child: Consumer(
              builder: (_, wiRef, __) {
                String statusList = wiRef.watch(laundryStatusProvider);
                String statusCategory =
                    wiRef.watch(laundryCategoryStatusProvider);

                List<LaundryModel> listBackup =
                    wiRef.watch(laundryDataListProvider);

                if (statusList == '') return DView.loadingCircle();
                if (statusList != 'Success') {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(30, 0, 30, 80),
                    child: HomeEmptyPage(
                      ratio: 16 / 9,
                      message: statusList,
                    ),
                  );
                }

                List<LaundryModel> list = [];
                if (statusCategory == 'All') {
                  list = List.from(listBackup);
                } else {
                  list = listBackup
                      .where((element) => element.status == statusCategory)
                      .toList();
                }

                if (list.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(30, 30, 30, 80),
                    child: Stack(
                      children: [
                        const HomeEmptyPage(
                          ratio: 16 / 9,
                          message: 'Empty',
                        ),
                        IconButton(
                          onPressed: () => getMyLaundry(),
                          icon: const Icon(Icons.refresh, color: Colors.white),
                        ),
                      ],
                    ),
                  );
                }
                return GroupedListView(
                  padding: const EdgeInsets.fromLTRB(30, 0, 30, 80),
                  elements: list,
                  groupBy: (element) =>
                      AppFormats.dateFormatShort(element.createdAt),
                  order: GroupedListOrder.DESC,
                  itemComparator: (element1, element2) {
                    return element1.createdAt.compareTo(element2.createdAt);
                  },
                  groupSeparatorBuilder: (value) => Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.grey[400]!),
                      ),
                      margin: const EdgeInsets.only(top: 24, bottom: 20),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      child: Text(
                        AppFormats.dateFormatMiddle(value),
                      ),
                    ),
                  ),
                  itemBuilder: (context, laundry) {
                    return GestureDetector(
                      onTap: () {
                        Nav.push(context, DetailLaundryPage(laundry: laundry));
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    laundry.shop.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                DView.spaceWidth(),
                                Text(
                                  AppFormats.longPrice(laundry.total),
                                  textAlign: TextAlign.end,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                            DView.spaceHeight(12),
                            Row(
                              children: [
                                if (laundry.withPickup)
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    margin: const EdgeInsets.only(right: 8),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    child: const Text(
                                      'Pickup',
                                      style: TextStyle(
                                          color: Colors.white, height: 1),
                                    ),
                                  ),
                                if (laundry.withDelivery)
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    margin: const EdgeInsets.only(right: 8),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    child: const Text(
                                      'Delivery',
                                      style: TextStyle(
                                          color: Colors.white, height: 1),
                                    ),
                                  ),
                                Expanded(
                                  child: Text(
                                    '${laundry.weight}kg',
                                    textAlign: TextAlign.end,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Consumer categories() {
    return Consumer(
      builder: (_, wiRef, __) {
        String categorySelected = wiRef.watch(laundryCategoryStatusProvider);
        return SizedBox(
          height: 30.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: AppConstants.laundryStatusCategory.length,
            itemBuilder: (context, index) {
              String category = AppConstants.laundryStatusCategory[index];
              return Padding(
                padding: EdgeInsets.only(
                  left: index == 0 ? 30 : 8,
                  right: index == AppConstants.laundryStatusCategory.length - 1
                      ? 30
                      : 8,
                ),
                child: InkWell(
                  onTap: () {
                    setLaundryCategoryStatusProvider(ref, category);
                  },
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: category == categorySelected
                            ? Colors.green
                            : Colors.grey[400]!,
                      ),
                      color: category == categorySelected
                          ? Colors.green
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      category,
                      style: TextStyle(
                        height: 1,
                        color: category == categorySelected
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
      padding: const EdgeInsets.fromLTRB(30, 60, 30, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'My Laundry',
            style: GoogleFonts.montserrat(
              fontSize: 24,
              color: Colors.green,
              fontWeight: FontWeight.w600,
            ),
          ),
          Transform.translate(
            offset: const Offset(0, -8),
            child: OutlinedButton.icon(
              onPressed: () => dialogClaim(),
              icon: const Icon(Icons.add),
              label: const Text(
                'Claim',
                style: TextStyle(height: 1),
              ),
              style: ButtonStyle(
                shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                padding: const MaterialStatePropertyAll(
                  EdgeInsets.fromLTRB(8, 2, 16, 2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
