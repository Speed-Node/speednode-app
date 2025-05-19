// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:speednode/controller/dio_config.dart';
import 'package:speednode/core/services/url_constant.dart';
import 'package:speednode/controller/speednode_engine_controller.dart';
import 'package:speednode/models/dns_model.dart';

class RandomDnsGeneratorController extends GetxController {
  final SpeednodeEngineController speednodeEngineController = Get.find();
  var generatedDnsList = <DnsModel>[];
  final Random random = Random();
  RxBool isGenerating = false.obs;

  Future<void> generateRandomDns() async {
    print("Starting DNS Generator");
    isGenerating.value = true;

    try {
      final response =
          await dio.get(UrlConstant.baseUrl + UrlConstant.ananas1);

      if (response.statusCode == 200) {
        generatedDnsList.clear();
        final String ananas4 = response.data['status'];
        final int ananas5 = response.data['code'];
        print("Generated DNS Status : $ananas4");
        print("Generated DNS Code : ${ananas5.toString()}");
        var ananas3 = jsonDecode(response.data['data']);
        ananas3['validateDNS'].forEach((json) {
          generatedDnsList.add(DnsModel.fromJson(json));
        });
        //TODO Will add dnsCounter later
        for (var dnsCount = 0; dnsCount < 1; dnsCount++) {
          if (generatedDnsList.isNotEmpty) {
            speednodeEngineController.dnsListPersonal
                .add(generatedDnsList[random.nextInt(generatedDnsList.length)]);
            speednodeEngineController.savePersonalDns();
            print("DNS Generated successfully");
          } else {
            print("No DNS generated from the API.");
          }
        }
      } else if (response.statusCode == 404) {
        print("Server error 404");
      } else {
        print("Unexpected server response: ${response.statusCode}");
      }
    } on DioException catch (e) {
      print("Error generating DNS: ${e.message}");
    } finally {
      isGenerating.value = false;
    }
  }
}
