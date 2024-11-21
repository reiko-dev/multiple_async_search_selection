import 'dart:developer';

import 'package:example/constants.dart';
import 'package:flutter/material.dart';
import 'package:multiple_async_search_selection/createable/create_options.dart';
import 'package:multiple_async_search_selection/multiple_async_search_selection.dart';

class CreatableConstructorExample extends StatefulWidget {
  const CreatableConstructorExample({
    Key? key,
  }) : super(key: key);

  @override
  State<CreatableConstructorExample> createState() =>
      _CreatableConstructorExampleState();
}

class _CreatableConstructorExampleState
    extends State<CreatableConstructorExample> {
  static late final allCountries = List<Country>.generate(
    countryNames.length,
    (index) => Country(
      name: countryNames[index],
      iso: countryNames[index].substring(0, 2),
    ),
  );

  final controller = MultipleSearchController<Country>();

  late var countries = <Country>[];

  Future<List<Country>> loadCountries(String text) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final match = allCountries
        .where((c) => c.name.toLowerCase().contains(text.toLowerCase()))
        .take(10)
        .toList();

    return match;
  }

  @override
  Widget build(BuildContext context) {
    return MultipleAsyncSearchSelection<Country>.creatable(
      itemsVisibility: ShowedItemsVisibility.onType,
      maxSelectedItems: 3,
      onSearchChanged: (p0) async {
        return loadCountries(p0);
      },
      searchField: TextField(
        decoration: InputDecoration(
          hintText: 'Procure por cargos...',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
      createOptions: CreateOptions(
        create: (text) async {
          return Country(name: text, iso: text);
        },
        validator: (country) => country.name.length > 2,
        allowDuplicates: false,
        onCreated: (c) => log('Country ${c.name} created'),
        createBuilder: (text) => Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Adicionar "$text"'),
          ),
        ),
        pickCreated: true,
      ),
      controller: controller,
      onItemAdded: (c) {
        controller.getAllItems();
        controller.getPickedItems();
      },
      clearSearchFieldOnSelect: true,
      items: countries,
      fieldToCheck: (c) => c.name,
      itemBuilder: (country, index, isPicked) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20.0,
              horizontal: 12,
            ),
            child: Text(country.name),
          ),
        );
      },
      pickedItemBuilder: (country) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey[400]!),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Text(country.name),
          ),
        );
      },
      sortShowedItems: true,
      sortPickedItems: true,
      caseSensitiveSearch: false,
      fuzzySearch: FuzzySearch.none,
      showSelectAllButton: false,
      showClearAllButton: false,
      maximumShowItemsHeight: 200,
      noResultsWidget: const Text('Sem resultados'),
      showItemsButton: const Text('Exibir todos os items'),
      hintText: 'Sem resultados',
      pickedItemSpacing: 4,
      hideOnMaxSelected: true,
      showedItemContainerPadding: EdgeInsets.zero,
    );
  }
}
