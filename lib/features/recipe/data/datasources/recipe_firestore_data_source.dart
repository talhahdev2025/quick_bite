import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quick_bite/features/recipe/data/models/recipe_model.dart';

class RecipeFirestoreDataSource {
  final FirebaseFirestore _firestore;

  RecipeFirestoreDataSource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  //approve recipe
  Future<void> approveRecipe(String recipeId) async {
    await _firestore.collection('recipes').doc(recipeId).update({
      'status': 'approved',
    });
  }

  //reject recipe
  Future<void> rejectRecipe(String recipeId,String rejectReason) async {
    await _firestore.collection('recipes').doc(recipeId).update({
      'status': 'rejected',
      'rejectionReason': rejectReason,
    });
  }

  //add recipe
  Future<void> addRecipe(Map<String, dynamic> recipe) async {
    // await _firestore.collection('recipes').doc().set(recipe);
    await _firestore.collection('recipes').add(recipe);
  }

  Stream<List<RecipeModel>> getRecipes() {
    return _firestore
        .collection('recipes')
        .where('status', isEqualTo: 'approved')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            return RecipeModel.fromMap({...data, 'id': doc.id});
          }).toList();
        });
  }

  Stream<List<RecipeModel>> getPendingRecipes() {
    return _firestore
        .collection('recipes')
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();

            return RecipeModel.fromMap({...data, 'id': doc.id});
          }).toList();
        });
  }
}
