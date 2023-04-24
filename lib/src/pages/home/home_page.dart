
import 'dart:convert';
import 'dart:io';
import 'package:bangkaew/src/config/theme.dart' as custom_theme;
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bangkaew/src/bloc/species/species_bloc.dart';
import 'package:bangkaew/src/pages/home/widgets/customTabBar.dart';
import 'package:bangkaew/src/pages/home/widgets/custom_drawer.dart';
import 'package:bangkaew/src/viewmodels/tab_menu_view_model.dart';

class HomePage extends StatefulWidget {

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final _tabsMenu = TabMenuViewModel().items;
  TextEditingController _searchController = TextEditingController();

  Future<List<String>> getBreed() async {
    String contents = await rootBundle.loadString('assets/model/my_labels_breeds.txt');

    List<String> breedList = [];

    for (var line in LineSplitter().convert(contents)) {
      // แปลงเป็นตัวพิมพ์เล็กและแทนที่ _ ด้วยช่องว่าง
      final breedName = line.toLowerCase().replaceAll('_', ' ');
      breedList.add(breedName);
    }
    return breedList;

  }
  List<String> _breedList = [];
  @override
  void initState() {
    super.initState();

    getBreed().then((breeds) {
      breeds.insertAll(0, ['All', 'bulldog','pitbull','shiba']);
      setState(() {
        _breedList = breeds;
      });
    });
  }
  List<String> get breedList => _breedList;


  @override
  Widget build(BuildContext context) {
    //debugPrint("_breedList at widget : ${_breedList}");
    return DefaultTabController(
      length: _tabsMenu.length,
      child: Scaffold(
        appBar: _buildAppBar(),
        drawer: CustomDrawer(),
        body: TabBarView(
          children: _tabsMenu.map((item) => item.widget).toList(),
        ),
      ),
    );
  }
  AppBar _buildAppBar() {
    return AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: custom_theme.Theme.gradient,
        ),
      ),
      title: DropdownSearch(
        dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            labelText: 'Enter species',
            labelStyle: TextStyle(
                color: Colors.white
            ),
          ),

        ),
        items: _breedList,
        onChanged: (value) {
          context.read<SpeciesBloc>().add(SpeciesSelected(value!));
        },
        selectedItem: "All",
        validator: (String? item) {
          if (item == null)
            return "Required field";
          else
            return null;
        },
      ),
      bottom: CustomTabBar(_tabsMenu),
      actions: [

      ],
    );
  }

}

