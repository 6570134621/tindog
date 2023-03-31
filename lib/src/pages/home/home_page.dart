
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tindog/src/bloc/species/species_bloc.dart';
import 'package:tindog/src/pages/home/widgets/customTabBar.dart';
import 'package:tindog/src/pages/home/widgets/custom_drawer.dart';
import 'package:tindog/src/viewmodels/tab_menu_view_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _tabsMenu = TabMenuViewModel().items;
  TextEditingController _searchController = TextEditingController();
  @override

  @override
  Widget build(BuildContext context) {
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
      title: Expanded(
        child: Row(
          children: [
            Text("TinDog"),
            SizedBox(width: 50,),
            Expanded(
                child: Container(
                  margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                  decoration: BoxDecoration(
                    border:  Border.all(width: 0, color: Colors.transparent)
                  ),
                  child: DropdownSearch(
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: 'Enter species',
                        labelStyle: TextStyle(
                          color: Colors.white
                        ),
                      ),

                    ),
                    items: ["Pitbull", "Shiba", "Bulldog", "Bangkaew","All"],
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
                )
            ),

          ],
        ),
      ),
      bottom: CustomTabBar(_tabsMenu),
      actions: [

      ],
    );
  }

}

