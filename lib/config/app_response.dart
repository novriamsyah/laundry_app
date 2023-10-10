import 'dart:convert';

import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:laundry_app/config/exception_response.dart';

class AppResponse {
  static Map data(Response response) {
    DMethod.printResponse(response);

    switch (response.statusCode) {
      case 200:
      case 201:
        var responseBody = jsonDecode(response.body);
        return responseBody;
      case 204:
        return {'success': true};
      case 400:
        throw BadRequestFailure(response.body);
      case 401:
        throw UnauthorizedFailure(response.body);
      case 403:
        throw ForbidenFailure(response.body);
      case 404:
        throw NotFoundFailure(response.body);
      case 422:
        throw InvalidInputFailur(response.body);
      case 500:
        throw ServerFailure(response.body);
      default:
        throw FetchFailure(response.body);
    }
  }

  static invalidInput(BuildContext context, String messageBody) {
    Map errors = jsonDecode(messageBody)['errors'];

    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        titlePadding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        title: const Text("invalid Input"),
        children: [
          ...errors.entries.map(
            (e) {
              return ListTile(
                title: Text(e.key),
                subtitle: Column(
                  children: (e.value as List).map((itemError) {
                    return Row(
                      children: [
                        const Text("-"),
                        Expanded(
                          child: Text(itemError),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              );
            },
          ).toList(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("close"),
            ),
          ),
        ],
      ),
    );
  }
}
