import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speednode/core/resources/extention_sized.dart';
import 'package:speednode/controller/speednode_engine_controller.dart';
import 'package:speednode/core/resources/app_colors.dart';

class DNSStatus extends StatefulWidget {
  const DNSStatus({super.key});

  @override
  State<DNSStatus> createState() => _DNSStatusState();
}

class _DNSStatusState extends State<DNSStatus> {
final SpeednodeEngineController speednodeEngineController = Get.find();
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
        decoration: BoxDecoration(
          gradient: isHovered
              ? GradientAppColors.dnsStatusBackgroundHover 
              : GradientAppColors.dnsStatusBackground, 
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: isHovered
                  ? AppColors.dnsStatusShadow.withValues(alpha: 0.9)
                  : AppColors.dnsStatusShadow,
              blurRadius: isHovered ? 15 : 10,
              offset: const Offset(3, 6),
              spreadRadius: isHovered ? 5 : 3,
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              "DNS: ${speednodeEngineController.selectedDns.value.name}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Colors.white,
                shadows: [
                  BoxShadow(
                    color: AppColors.dnsStatusShadowText,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                    spreadRadius: 5,
                  ),
                ],
              ),
            ),
            8.height,
            Obx(
              () => Text(
                speednodeEngineController.isActive.value
                    ? "DNS is Active"
                    : "DNS is Inactive",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.white,
                  shadows: [
                    BoxShadow(
                      color: AppColors.dnsStatusShadowText1,
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                      spreadRadius: 5,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
