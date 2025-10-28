import 'package:flutter/material.dart';
import 'package:task_vpn/navbar.dart';
import 'package:task_vpn/widgets/scenes/all_servers_tab.dart';
import 'package:task_vpn/widgets/scenes/my_servers_tab.dart';
import 'package:task_vpn/widgets/scenes/favorites_tab.dart';
import 'package:flutter/cupertino.dart';

class SceneAll extends StatefulWidget {
  const SceneAll({super.key});

  @override
  State<SceneAll> createState() => _SceneAllState();
}

class _SceneAllState extends State<SceneAll> {
  String searchText = '';
  int _currentTabIndex = 0;

  void _onSearchChanged(String value) {
    setState(() {
      searchText = value;
    });
  }

  void _onTabChanged(int index) {
    setState(() {
      _currentTabIndex = index;
      searchText = '';
    });
  }

  Widget _buildCurrentScene() {
    switch (_currentTabIndex) {
      case 0:
        return AllServersTab(searchText: searchText);
      case 1:
        return MyServersTab(searchText: searchText);
      case 2:
        return FavoritesTab(searchText: searchText);
      default:
        return AllServersTab(searchText: searchText);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final paddingTop = mediaQuery.padding.top;
    final paddingBottom = mediaQuery.padding.bottom;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 18, 36, 50),
      body: Padding(
        padding: EdgeInsets.only(
          top: paddingTop,
          bottom: paddingBottom,
          left: 16.0,
          right: 16.0,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 10),
              FilterMenu(
                onSearchChanged: _onSearchChanged,
                showNoResults: searchText.isNotEmpty,
                onTabChanged: _onTabChanged,
              ),
              const SizedBox(height: 24),
              _buildCurrentScene(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(
            CupertinoIcons.chevron_back,
            color: Colors.white,
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(
            'Точки доступа',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}