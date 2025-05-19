import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speednode/core/resources/extention_sized.dart';
import 'package:speednode/core/resources/media_query_size.dart';
import 'package:speednode/controller/speednode_engine_controller.dart';
import 'package:speednode/core/resources/app_colors.dart';

class DnsSelectionContainer extends StatelessWidget {
  final Function() onPressed;
  final Color color;
  DnsSelectionContainer({
    super.key,
    required this.onPressed,
    required this.color,
  });

  final SpeednodeEngineController speednodeEngineController =
      Get.put(SpeednodeEngineController());
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.all(24),
        backgroundColor: AppColors.dnsSelectionContainer,
        side: BorderSide(
          color: color,
          width: 2,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: SizedBox(
          width: ScreenSize.height * 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                speednodeEngineController.selectedDns.value.name,
                style: TextStyle(
                  color: AppColors.dnsSelectionContainerName,
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
              8.width,
              Icon(
                Icons.keyboard_arrow_down_outlined,
                color: AppColors.dnsSelectionContainerName,
              ),
            ],
          )),
    );
  }
}
