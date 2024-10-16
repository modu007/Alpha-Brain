import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:neuralcode/Utils/Components/Text/simple_text.dart';
import '../../Color/colors.dart';

class HomeAppBar extends StatelessWidget {
  final TabController tabController;
  final Widget widget;
  // final bool isVisibleWhenScroll;
  final bool darkTheme;
  const HomeAppBar({
    super.key,
    required this.tabController,
    required this.widget,
    // required this.isVisibleWhenScroll,
    required this.darkTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: darkTheme?const Color(0xff121212):Colors.white,
      padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
      child: Column(
        children: [
          Row(
            children: [
              const SimpleText(
                text: "Ekonara",
                fontSize: 24,
                fontColor: ColorClass.headingColor,
                fontWeight: FontWeight.w500,
              ),
              const Spacer(),
              Builder(
                  builder: (context) => InkWell(
                      onTap: () {
                        Scaffold.of(context).openEndDrawer();
                      },
                      child: SvgPicture.asset("assets/svg/menu_dark.svg")))
            ],
          ),
          const SizedBox(height: 10,),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.black12, // Adjust the color and opacity as needed
                  Colors.transparent,
                ],
                stops: [0, 0.5, 1],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            height: 1.0, // Adjust the height of the divider
          ),
          const SizedBox(
            height: 10,
          ),
          widget,
          const SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
