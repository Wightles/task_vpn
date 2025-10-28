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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Container(
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 47, 65, 85),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: List.generate(tabs.length, (index) {
                final bool isSelected = selectedIndex == index;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => _onTabTapped(index),
                    child: Container(
                      margin: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF2563EB)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            tabs[index],
                            style: TextStyle(
                              color: Colors.white,
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
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Container(
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: widget.onSearchChanged,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.normal,
              ),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 16.0,
                ),
                border: InputBorder.none,
                hintText: 'Поиск',
                hintStyle: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 16,
                  fontWeight: FontWeight.w200,
                ),
                prefixIcon: Icon(
                  CupertinoIcons.search,
                  color: Colors.white.withOpacity(0.6),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: Colors.white.withOpacity(0.6),
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