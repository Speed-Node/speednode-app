
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speednode/controller/speednode_engine_controller.dart';
import 'package:speednode/controller/single_dns_ping_controller.dart';
import 'package:speednode/core/resources/app_colors.dart';
import 'package:speednode/core/widgets/dis.dart';

class DNSSelectorBottomSheetSpeedNode extends StatelessWidget {
  DNSSelectorBottomSheetSpeedNode({
    super.key,
  });
final SpeednodeEngineController speednodeEngineController = Get.find();
final SingleDnsPingController dnsPingController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Dis(
      child: DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.7,
        minChildSize: 0.3,
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: AppColors.dnsSelectionContainerSpeedNodeBackground,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Select DNS',
                        style: TextStyle(
                          color:
                              AppColors.dnsSelectionContainerSpeedNodeAppBarText,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.close,
                          color:
                              AppColors.dnsSelectionContainerSpeedNodeCloseIcon,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: speednodeEngineController.dnsListSpeedNode.length,
                    itemBuilder: (context, index) {
                      final dns =
                          speednodeEngineController.dnsListSpeedNode[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            speednodeEngineController.selectedDns.value = dns;
                            dnsPingController.pingPrimaryDns();
                            dnsPingController.pingSecondaryDns();
                            speednodeEngineController.saveSelectedDnsValue();
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: AppColors
                                  .dnsSelectionContainerSpeedNodeContainer,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors
                                    .dnsSelectionContainerSpeedNodeBorderContainer,
                                width: 2,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      speednodeEngineController
                                          .dnsListSpeedNode[index].name,
                                      style: TextStyle(
                                        color: AppColors
                                            .dnsSelectionContainerSpeedNodeDnsName,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Primary: ${speednodeEngineController.dnsListSpeedNode[index].primaryDNS}",
                                      style: TextStyle(
                                        color: AppColors
                                            .dnsSelectionContainerSpeedNodeDns,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      'Secondary: ${speednodeEngineController.dnsListSpeedNode[index].secondaryDNS}',
                                      style: TextStyle(
                                        color: AppColors
                                            .dnsSelectionContainerSpeedNodeDns,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                speednodeEngineController
                                        .dnsListSpeedNode[index].name
                                        .contains('*')
                                    ? const Icon(
                                        Icons.remove_circle,
                                        color: Color.fromARGB(255, 255, 30, 0),
                                      )
                                    : const Icon(
                                        Icons.check_circle,
                                        color: Color.fromARGB(255, 48, 136, 51),
                                      ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
