import 'package:flutter/foundation.dart';
import 'package:testddd/application/shopdata/shopdata_bloc.dart';
import 'package:testddd/infrastructure/shopdata/data_entity.dart';
import 'package:testddd/injection.dart';
import 'package:testddd/presentation/core/empty.dart';
import 'package:testddd/presentation/core/failure.dart';
import 'package:testddd/presentation/core/loading.dart';
import 'package:testddd/presentation/pages/widgets/shirtBox.dart';

import 'package:testddd/presentation/theme/theme.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import "package:collection/collection.dart";

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController searchInputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  bool loadComplete = false;
  bool fullPage = false;
  List<String> groupCat = [];
  String _category = "";

  void _onScrollEvent() {
    if (_scrollController.position.atEdge) {
      bool isTop = _scrollController.position.pixels == 0;
      if (isTop) {
        //print('At the top');
      } else {
        if (!fullPage) if (loadComplete) {
          loadComplete = false;
          _currentPage++;
          setState(() {});
          if (_currentPage == 3) fullPage = true;
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScrollEvent);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScrollEvent);
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(BoxConstraints(
      maxHeight: MediaQuery.of(context).size.height,
      maxWidth: MediaQuery.of(context).size.width,
    ));
    return Scaffold(
      appBar: AppBar(
        //leading: Icon(Icons.arrow_back_ios_new_outlined),
        title: Container(
            height: 40,
            child: TextField(
              controller: searchInputController,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      width: 2,
                      color: Color.fromARGB(255, 133, 133, 133),
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  filled: true,
                  focusColor: Color.fromARGB(255, 133, 133, 133),
                  hintStyle: const TextStyle(
                      color: Color.fromARGB(255, 143, 143, 143),
                      fontStyle: FontStyle.italic),
                  hintText: "Search",
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15)),
              textInputAction: TextInputAction.search,
              onSubmitted: (value) {
                if (value.length > 0) {
                  setState(() {
                    _category = searchInputController.text;
                    fullPage = true;
                    _currentPage = 3;
                  });
                } else {
                  setState(() {
                    fullPage = false;
                    _currentPage = 1;
                    _category = "";
                  });
                }
              },
            )),
        actions: [
          IconButton(
            onPressed: () {
              if (searchInputController.text.length > 0) {
                setState(() {
                  _category = searchInputController.text;
                  fullPage = true;
                  _currentPage = 3;
                });
              } else {
                setState(() {
                  fullPage = false;
                  _currentPage = 1;
                  _category = "";
                });
              }
            },
            icon: Icon(
              Icons.search,
              size: 32,
            ),
          ),
        ],
      ),
      body: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (conetxt) => getIt<ShopdataBloc>()
                ..add(
                  const ShopdataEvent.watchAllProducts(),
                ),
            ),
          ],
          child: BlocBuilder<ShopdataBloc, ShopdataState>(
            builder: (context, state) {
              return state.map(
                initial: (_) => Loading(),
                loadInProgress: (_) => Loading(),
                loadSuccess: (state) {
                  loadComplete = true;
                  if (groupCat.isEmpty)
                    groupBy(state.shopdata, (Datum items) => items.category)
                        .forEach((key, value) {
                      groupCat.add(key!);
                    });
                  List<Datum> listShirt = [];

                  if (_category.isEmpty) {
                    listShirt = state.shopdata;
                  } else {
                    for (var item in state.shopdata) {
                      if (item.category == _category ||
                          item.title!
                              .toString()
                              .toLowerCase()
                              .contains(_category.toLowerCase())) {
                        listShirt.add(item);
                      }
                    }
                  }
                  if (listShirt.isEmpty) return Center(child: Empty());

                  return SingleChildScrollView(
                    controller: _scrollController,
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        Container(
                            height: 40,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 0.0),
                              itemCount: groupCat.length,
                              // physics: const BouncingScrollPhysics(),
                              itemBuilder: (_, i) {
                                return Container(
                                    margin: EdgeInsets.symmetric(horizontal: 5),
                                    child: TextButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Color.fromARGB(
                                                    255, 121, 121, 121)),
                                      ),
                                      child: Text(
                                        groupCat[i],
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.white),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _category = groupCat[i];
                                        });
                                      },
                                    ));
                              },
                            )),
                        GridView.builder(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            itemCount: _category.isEmpty
                                ? _currentPage * 10
                                : listShirt.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1.sw > 450 ? 3 : 2,
                              childAspectRatio: 1.sw > 450
                                  ? MediaQuery.of(context).size.width /
                                      (MediaQuery.of(context).size.height / .65)
                                  : MediaQuery.of(context).size.width /
                                      (MediaQuery.of(context).size.height /
                                          0.93),
                            ),
                            itemBuilder: (context, index) {
                              return ShirtBox(shopData: listShirt[index]);
                            }),
                        if (_currentPage < 3) Loading()
                      ],
                    ),
                  );
                },
                loadFailure: (_) => Failure(),
                empty: (_) => Empty(),
              );
            },
          )),
    );
  }
}
