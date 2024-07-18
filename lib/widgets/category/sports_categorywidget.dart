class CategoryModel {
  final String name;
  final String image;

  CategoryModel({
    required this.name,
    required this.image,
  });
}

List<CategoryModel> categories = [
  CategoryModel(
      name: "Foot Ball",
      image: 'assets/images/category_images/joueur-football-masculin-ballon-terrain-herbe.jpg'),
  CategoryModel(
      name: "Volley Ball",
      image: 'assets/images/category_images/AdobeStock_688169104_Preview.jpeg'),
  CategoryModel(
      name: "Basket Ball",
      image: 'assets/images/category_images/AdobeStock_81876097_Preview.jpeg'),
  CategoryModel(
      name: "Hand Ball",
      image: 'assets/images/category_images/AdobeStock_696083127_Preview.jpeg'),
];
