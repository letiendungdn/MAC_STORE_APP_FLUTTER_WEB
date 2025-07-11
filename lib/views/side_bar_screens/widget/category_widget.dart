import 'package:app_web/controllers/categoryController.dart';
import 'package:app_web/models/category.dart';
import 'package:flutter/material.dart';

class CategoryWidget extends StatefulWidget {
  const CategoryWidget({super.key});

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  // A future that will hold the list  of categories once loaded from the Api
  late Future<List<Category>> futureCategory;

  @override
  void initState() {
    super.initState();
    futureCategory = CategoryController().loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
