import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class FilterMenu extends StatefulWidget {
  final Function(String) onSearchChanged;
  final bool showNoResults;
  final Function(int) onTabChanged;
  const FilterMenu({
    super.key,
    required this.onSearchChanged,
    required this.showNoResults,
    required this.onTabChanged,
  });

  @override
  State<FilterMenu> createState() => _FilterMenuState();
}

class _FilterMenuState extends State<FilterMenu> {
  int selectedIndex = 0;
  final List<String> tabs = ['Все', 'Мои', 'Избранные'];
  final TextEditingController _searchController = TextEditingController();

  void _onTabTapped(int index) {
    setState(() {
      selectedIndex = index;
      _searchController.clear();
    });
    widget.onTabChanged(index);
    widget.onSearchChanged('');
  }

  double _getAdaptivePadding(BuildContext context, [double basePadding = 8]) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) return basePadding * 0.7;
    if (screenWidth < 400) return basePadding * 0.85;
    if (screenWidth > 600) return basePadding * 1.5;
    return basePadding;
  }

  double _getAdaptiveFontSize(BuildContext context, double baseSize) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scale = screenWidth < 360 ? 0.85 : 
                 screenWidth < 400 ? 0.9 :
                 screenWidth > 600 ? 1.2 : 1.0;
    return baseSize * scale;
  }

  double _getAdaptiveHeight(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    if (screenHeight < 700) return 44;
    if (screenHeight > 1000) return 64;
    return 52;
  }

  double _getAdaptiveBorderRadius(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) return 20;
    if (screenWidth > 600) return 40;
    return 30;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: _getAdaptivePadding(context)),
          child: Container(
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 47, 65, 85),
              borderRadius: BorderRadius.circular(_getAdaptiveBorderRadius(context)),
            ),
            child: Row(
              children: List.generate(tabs.length, (index) {
                final bool isSelected = selectedIndex == index;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => _onTabTapped(index),
                    child: Container(
                      margin: EdgeInsets.all(_getAdaptivePadding(context, 1)),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF2563EB)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(_getAdaptiveBorderRadius(context)),
                      ),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: _getAdaptivePadding(context, 12)),
                          child: Text(
                            tabs[index],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: _getAdaptiveFontSize(context, 14),
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
        SizedBox(height: _getAdaptivePadding(context)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: _getAdaptivePadding(context)),
          child: Container(
            height: _getAdaptiveHeight(context),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(_getAdaptivePadding(context, 12)),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: widget.onSearchChanged,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.normal,
                fontSize: _getAdaptiveFontSize(context, 16),
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: _getAdaptivePadding(context, 16),
                  vertical: _getAdaptivePadding(context, 16),
                ),
                border: InputBorder.none,
                hintText: 'Поиск',
                hintStyle: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: _getAdaptiveFontSize(context, 16),
                  fontWeight: FontWeight.w200,
                ),
                prefixIcon: Icon(
                  CupertinoIcons.search,
                  color: Colors.white.withOpacity(0.6),
                  size: _getAdaptiveFontSize(context, 20),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: Colors.white.withOpacity(0.6),
                          size: _getAdaptiveFontSize(context, 20),
                        ),
                        onPressed: () {
                          _searchController.clear();
                          widget.onSearchChanged('');
                        },
                      )
                    : null,
              ),
            ),
          ),
        ),
      ],
    );
  }
}