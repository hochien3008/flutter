import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:mac_verdor_store/global_variables.dart';
import 'package:mac_verdor_store/models/product.dart';
import 'package:mac_verdor_store/services/manage_http_response.dart';

class ProductController {
  Future<void> uploadProduct({
    required String productName,
    required int productPrice,
    required int quantity,
    required String description,
    required String category,
    required String vendorId,
    required String fullName,
    required String subCategory,
    required List<File>? pickedImages,
    required context,
  }) async {
    if (pickedImages != null) {
      final cloudinary = CloudinaryPublic("difssiefr", "yzummgg5");
      List<String> images = [];
      //loop through each  image in the  pickImages list
      for (var i = 0; i < pickedImages.length; i++) {
        //await the upload of the current image to cloudinary
        CloudinaryResponse cloudinaryResponse = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(pickedImages[i].path, folder: productName),
        );
        //add the secure Url to the images list
        images.add(cloudinaryResponse.secureUrl);
      }

      if (category.isNotEmpty && subCategory.isNotEmpty) {
        final Product product = Product(
          id: '',
          productName: productName,
          productPrice: productPrice,
          quantity: quantity,
          description: description,
          category: category,
          vendorId: vendorId,
          fullName: fullName,
          subCategory: subCategory,
          images: images,
        );
        http.Response response = await http.post(
          Uri.parse("$uri/api/add-product"),
          body: product.toJson(),
          headers: <String, String>{
            "Content-Type": "application/json; charset=UTF-8",
          },
        );
        manageHttpResonse(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, 'Product Uploaded');
          },
        );
      } else {
        showSnackBar(context, 'Select Category');
      }
    } else {
      showSnackBar(context, 'Select Image');
    }
  }
}
