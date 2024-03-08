import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dashboard/Responsive.dart';
import 'package:flutter_dashboard/model/health_model.dart';
import 'package:flutter_dashboard/widgets/custom_card.dart';
import 'package:flutter_svg/svg.dart';

class ActivityDetailsCard extends StatelessWidget {
  final String title;
  final String value;
  final String icon;
  final Function()? onClick;
  const ActivityDetailsCard({super.key, required this.title, required this.value, required this.icon, this.onClick});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: SizedBox(
        width: Responsive.isMobile(context) ? double.infinity : null,
        child: CustomCard(
          padding: EdgeInsets.all(Responsive.isMobile(context) ? 15 : 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(icon, color: Colors.white, height: 30, width: 30,),
              Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 4),
                child: Text(
                  value,
                  style: const TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Text(
                title,
                style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                    fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
