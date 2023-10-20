


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/auth_controller.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:pos/models/products_variants_categories.dart';
import 'package:pos/models/variant_item.dart';



class ProductVariantsController extends GetxController{
       FirebaseFirestore firestore = FirebaseFirestore.instance;
        Rx<List<ProductsVariantsCategory>> productsVariantsCategorysReceiver = Rx<List<ProductsVariantsCategory>>([]);
        List<ProductsVariantsCategory> get productsVariantsCategories => productsVariantsCategorysReceiver.value;
        Rx<bool> showSaveButton = Rx<bool>(false);
        Rx<bool> showPassword = Rx<bool>(false);
        AuthController authController = Get.find<AuthController>();
        BusinessController businessController = Get.find<BusinessController>();
        Rx<ProductsVariantsCategory?> selectedCategory = Rx<ProductsVariantsCategory?>(null);
        late Rx<List<ProductsVariantsCategory>> selectedCategories = Rx<List<ProductsVariantsCategory>>([]);
        Stream<List<ProductsVariantsCategory>> getProductsVariantsCategorys() {
          return firestore
              .collection("productsVariantsCategories").where("businessId",isEqualTo: businessController.selectedBusiness.value.id)
              .snapshots()
              .asyncMap((QuerySnapshot querySnapshot) async{
               List<ProductsVariantsCategory> productsVariantsCategories = [];
                  for (var element in querySnapshot.docs) {
                    ProductsVariantsCategory productsVariantsCategory = ProductsVariantsCategory.fromDocumentSnapshot(element);
                    QuerySnapshot querySnapshot = await firestore.collection("productsVariantsCategories")
                    .doc(productsVariantsCategory.id)
                    .collection("variants").get();
                     List<VariantItem> variants = [];
                     for (var doc in querySnapshot.docs) {
                        variants.add(VariantItem.fromDocumentSnapshot(doc));
                     }
                     productsVariantsCategory.variants.value = variants;
                    productsVariantsCategories.add(productsVariantsCategory);
                }
            return productsVariantsCategories;    
          });
        }

    Future getVariants ()async{
      QuerySnapshot querySnapshot = await firestore.collection("productsVariantsCategories")
                    .doc(selectedCategory.value?.id)
                    .collection("variants").get();
                     List<VariantItem> variants = [];
                     for (var doc in querySnapshot.docs) {
                        variants.add(VariantItem.fromDocumentSnapshot(doc));
      }

            selectedCategory.value?.variants.value = variants;
    }
    
        Future<ProductsVariantsCategory> getCategory (id)async{
            DocumentSnapshot doc = await firestore.collection("productsVariantsCategories")
                          .doc(id).get();
                      return ProductsVariantsCategory.fromDocumentSnapshot(doc);
         }

        Future<VariantItem> getVariant(categoryId,id)async{
        DocumentSnapshot doc =  await firestore.collection("productsVariantsCategories")
                          .doc(categoryId)
                    .collection("variants").doc(id).get();
                  return VariantItem.fromDocumentSnapshot(doc);
            }
   
      Future<void> addCategory (title)async{
          try {
            var id = Timestamp.now().toDate().toString();
           await  firestore.collection("productsVariantsCategories").doc(id).set({
              "id":id,
              "businessId":businessController.selectedBusiness.value.id,
              "title":title,
              "createdAt":Timestamp.now()
            });
          } catch (e) {
            print(e);
          }
      }

      Future<void> addVariant (name)async{
          try {
            var id = Timestamp.now().toDate().toString();
           await  firestore.collection("productsVariantsCategories").doc(selectedCategory.value?.id).collection("variants").doc(id).set({
              "id":id,
              "name":name,
              "createdAt":Timestamp.now()
            });
          } catch (e) {
            print(e);
          }
      }
Future<void> updateProductsVariantsCategoryDoc (productsVariantsCategoryId, data)async{
          try {
            var id = Timestamp.now().toDate().toString();
           await  firestore.collection("productsVariantsCategories").doc(productsVariantsCategoryId).update(data);
          } catch (e) {
            print(e);
          }
      }

        Future<void> deleteCategory (id)async{
          try {
           await  firestore.collection("productsVariantsCategories").doc(id).delete();
          } catch (e) {
            print(e);
          }
      }
       
  Future<void> deleteVariant (id)async{
          try {
           await  firestore.collection("productsVariantsCategories").doc(selectedCategory.value?.id).collection("variants").doc(id).delete();
          } catch (e) {
            print(e);
          }
      }
       


        @override
        void onInit() {
        productsVariantsCategorysReceiver.bindStream(getProductsVariantsCategorys());
          super.onInit();
        }
}