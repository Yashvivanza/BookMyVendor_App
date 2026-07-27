import 'package:flutter/material.dart';
import 'package:flutter_application_88/core/constants/app_colors.dart';
import 'subcategory_screen.dart';
import 'app_drawer.dart';
import 'package:provider/provider.dart';
import 'viewmodels/category_view_model.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {

  
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<CategoryViewModel>().loadCategories();
    });
  }

  
  @override
  Widget build(BuildContext context) {
    final categoryVM =
    context.watch<CategoryViewModel>();

    return Scaffold(
        backgroundColor:AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          "Categories",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: const AppDrawer(),
      body: categoryVM.isLoading
    ? const Center(
        child: CircularProgressIndicator(),
      )
      :Padding(
      padding: const EdgeInsets.all(10),
      
      child: GridView.builder(
        itemCount: categoryVM.categories.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.70,
        ),
      itemBuilder: (context, index) {
       final item =
    categoryVM.categories[index];

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [ 
          Expanded(
            flex: 7,
            child: Image.network(
              item.categoryImage,
              fit: BoxFit.cover,
              width: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                debugPrint("FAILED URL = ${item.categoryImage}");
                debugPrint(error.toString());
                return const Icon(Icons.broken_image);
              },
            ),
          ),
         Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

                  Text(
                    item.categoryName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(238, 13, 27, 61),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SubCategoryScreen(
                            categoryId: item.categoryId.toString(),
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      "View Subcategory",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  },
  ),
  
      ),
    );
  } 
}