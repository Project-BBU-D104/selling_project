import 'dart:io';
import 'package:selling_project/models/product_management/product_model.dart';
import 'package:selling_project/services/api_services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductServices {
  final ApiServices _api = ApiServices();
  final String collection = "products";

  final SupabaseClient _supabase = Supabase.instance.client;

  Stream<List<ProductModel>> getProducts() {
    return _api.get(collection).map((data) {
      return data.map((item) {
        return ProductModel.fromJson(
          Map<String, dynamic>.from(item),
          item["id"]?.toString(),
        );
      }).toList();
    });
  }

  Future<String?> uploadImage(File file) async {
    try {
      final extension = file.path.split('.').last;
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.$extension';
      final path = 'items/$fileName';
      await _supabase.storage.from('product-images').upload(
            path,
            file,
            fileOptions: FileOptions(
              cacheControl: '3600',
              contentType: 'image/$extension',
              upsert: false,
            ),
          );
      final String publicUrl =
          _supabase.storage.from('product-images').getPublicUrl(path);

      return publicUrl;
    } catch (e) {
      throw Exception("Failed to upload image to Supabase: $e");
    }
  }

  Future<String> addProduct(ProductModel product, {File? imageFile}) async {
    try {
      String? imageUrl = product.image;
      if (imageFile != null) {
        imageUrl = await uploadImage(imageFile);
      }

      final newProduct = product.copyWith(image: imageUrl);

      return await _api.post(
        collection,
        newProduct.toJson(),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateProduct(ProductModel product, {File? newImageFile}) async {
    if (product.id == null || product.id!.isEmpty) {
      throw Exception("Product ID cannot be null or empty during update.");
    }

    try {
      String? imageUrl = product.image;

      if (newImageFile != null) {
        imageUrl = await uploadImage(newImageFile);
      }

      final updatedProduct = product.copyWith(image: imageUrl);

      await _api.put(
        collection,
        product.id!,
        updatedProduct.toJson(),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteProduct(String id) async {
    if (id.isEmpty) {
      throw Exception("Product ID cannot be empty.");
    }
    
    await _api.delete(
      collection,
      id,
    );
  }
}