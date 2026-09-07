import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quick_bite/features/recipe/data/models/recipe_model.dart';

class RecipeFirestoreDataSource {
  final FirebaseFirestore _firestore;

  RecipeFirestoreDataSource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  //add recipe
  Future<void> addRecipe(Map<String, dynamic> recipe) async {
    await _firestore.collection('recipes').doc().set(recipe);
  }

  Stream<List<RecipeModel>> getRecipes() {
    return _firestore
        .collection('recipes')
        .where('isApproved', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            return RecipeModel.fromMap({...data,'firestoreId':doc.id});
          }).toList();
        });
  }
}
