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

  void _onTabTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
    widget.onTabChanged(index);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 47, 65, 85),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: List.generate(tabs.length, (index) {
                final bool isSelected = selectedIndex == index;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => _onTabTapped(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF2563EB)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          tabs[index],
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.white,
                            fontWeight: FontWeight.w500,
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
                  fontWeight: FontWeight.normal,
                ),
                prefixIcon: Icon(
                  CupertinoIcons.search,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}