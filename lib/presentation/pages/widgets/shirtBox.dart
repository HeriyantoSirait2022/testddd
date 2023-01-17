import 'package:testddd/infrastructure/shopdata/data_entity.dart';
import 'package:testddd/presentation/routes/router.gr.dart';
import 'package:testddd/presentation/theme/theme.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShirtBox extends StatelessWidget {
  const ShirtBox({
    Key? key,
    required this.shopData,
  }) : super(key: key);

  final Datum shopData;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(BoxConstraints(
      maxHeight: MediaQuery.of(context).size.height,
      maxWidth: MediaQuery.of(context).size.width,
    ));
    return Padding(
      padding: EdgeInsets.only(
        left: 15.h,
        right: 15.h,
        top: 10.h,
      ),
      child: Container(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              //AutoRouter.of(context).push(DetailRoute(shopData: shopData));
            },
            child: Image(
              image: NetworkImage(shopData.thumbnail!),
              height: 1.sh / 3,
              fit: BoxFit.cover,
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  shopData.title!,
                  style: Apptheme(context).boldText.copyWith(
                        fontSize: 15.h,
                      ),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.favorite_border, size: 20.h),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 5.h,
              bottom: 5.h,
            ),
            child: Text(
              shopData.description!,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: Apptheme(context).normalText.copyWith(
                    fontSize: 13.h,
                  ),
            ),
          ),
          Wrap(
            children: [
              Text(
                "Rp. ${shopData.price!}",
                style: Apptheme(context).boldText.copyWith(
                      fontSize: 14.h,
                    ),
              ),
              Text(
                "Rp. \ ${shopData.price!}",
                style: Apptheme(context).thinText.copyWith(
                      fontSize: 10.h,
                      decoration: TextDecoration.lineThrough,
                    ),
              ),
              Text(
                "% ${shopData.discountPercentage!} OFF ",
                style: Apptheme(context).thinText.copyWith(
                      fontSize: 10.h,
                      color: Colors.redAccent,
                    ),
              ),
            ],
          )
        ],
      )),
    );
  }
}
