import 'package:app_web/controllers/category_controller.dart';
import 'package:app_web/controllers/subcategory_controller.dart';
import 'package:app_web/models/category.dart';
import 'package:app_web/views/side_bar_screens/widget/subcategory_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class SubcategoryScreen extends StatefulWidget {
  const SubcategoryScreen({super.key});

  static const String id = 'subcategoryScreen';
  @override
  State<SubcategoryScreen> createState() => _SubcategoryScreenState();
}

class _SubcategoryScreenState extends State<SubcategoryScreen> {
  final SubcategoryController subcategoryController = SubcategoryController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Future<List<Category>> futureCategory;
  late String name;
  Category? selectedCategory;

  @override
  void initState() {
    super.initState();
    futureCategory = CategoryController().loadCategories();
  }

  dynamic _image;
  pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (result != null) {
      setState(() {
        _image = result.files.first.bytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                alignment: Alignment.topLeft,
                child: const Text(
                  'Categories',
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(4.0),
              child: Divider(color: Colors.grey),
            ),
            FutureBuilder(
              future: futureCategory,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No Categories'));
                } else {
                  return DropdownButton<Category>(
                    value: selectedCategory,
                    hint: const Text('Select Subategory'),
                    items: snapshot.data!.map((Category category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value;
                      });
                      print(selectedCategory!.name);
                    },
                  );
                }
              },
            ),
            Row(
              children: [
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: _image != null
                        ? Image.memory(_image)
                        : const Text('Subcategory image'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 200,
                    child: TextFormField(
                      onChanged: (value) {
                        name = value;
                      },
                      validator: (value) {
                        if (value!.isNotEmpty) {
                          return null;
                        } else {
                          return 'Please enter a subcategory name';
                        }
                      },
                      decoration: const InputDecoration(
                        labelText: 'Enter Catagory Name',
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                     await subcategoryController.uploadSubcategory(categoryId: selectedCategory!.id,
                          categoryName: selectedCategory!.name,
                          pickedImage: _image,
                          subCategoryName: name,
                          context: context);
                          setState(() {
                            _formKey.currentState!.reset();
                            _image = null;
                          });
                    }
                  },
                  child: const Text(
                    'Save',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  pickImage();
                },
                child: const Text('Pick Image'),
              ),
            ),
            const Divider(color: Colors.grey),
            const SubcategoryWidget(),
          ],
        ),
      ),
    );
  }
}
