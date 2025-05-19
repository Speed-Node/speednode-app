import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:speednode/core/resources/extention_sized.dart';
import 'package:speednode/core/resources/media_query_size.dart';
import 'package:speednode/gen/assets.gen.dart';
import 'package:speednode/core/resources/app_colors.dart';

class WorldMap extends StatelessWidget {
  const WorldMap({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
            children: [
              20.height,
              Flexible(
                child: SvgPicture.asset(
                  Assets.svg.world,
                  colorFilter: ColorFilter.mode(
                      AppColors.worldMap, BlendMode.srcIn),
                  fit: BoxFit.cover,
                  height: ScreenSize.height * 0.5,
                ),
              ),
            ],
          );
  }
}