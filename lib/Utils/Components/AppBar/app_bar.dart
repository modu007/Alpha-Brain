import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:neuralcode/Utils/Color/colors.dart';
import 'package:neuralcode/Utils/Components/Text/simple_text.dart';

class HomeAppBar extends StatelessWidget {
  final TabController tabController;
  const HomeAppBar({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 20),
      child: Column(
        children: [
          Row(
            children: [
            const SimpleText(
              text: "Alpha Brains",
              fontSize: 24,
              fontColor: ColorClass.headingColor,
              fontWeight: FontWeight.w500,
            ),
              const Spacer(),
              Builder(
                builder:(context)=>InkWell(
                  onTap: (){
                    Scaffold.of(context).openDrawer();
                  },
                    child: SvgPicture.asset("assets/svg/menu.svg")))
            ],
          ),
          SizedBox(
            width: 150,
            child: TabBar(
              controller: tabController,
              dividerColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorColor: const Color(0xff4EB3CA),
              labelPadding: EdgeInsets.zero,
              indicatorPadding: const EdgeInsets.symmetric(horizontal: 8),
              unselectedLabelStyle: const TextStyle(color: Color(0xff8698A9)),
              labelColor: Colors.black,
              tabs: const [
                Tab(
                    child: SimpleText(
                  text: 'For you',
                  fontSize: 12,
                      fontWeight: FontWeight.w600,
                )),
                Tab(
                    child: SimpleText(
                  text: 'Top picks',
                  fontSize: 12,
                      fontWeight: FontWeight.w600,
                    )),
              ],
            ),
          ),
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
        ],
      ),
    );
  }
}
