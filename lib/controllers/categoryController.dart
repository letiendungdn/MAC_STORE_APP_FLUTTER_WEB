import 'dart:typed_data';
import 'package:app_web/global_variable.dart';
import 'package:app_web/models/category.dart';
import 'package:app_web/views/services/manage_http_response.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:http/http.dart' as http;

class CategoryController {
  uploadCategory({required Uint8List  pickedImage,required Uint8List pickedBanner, required String name, required context}) async {
    try {
      final cloudinary = CloudinaryPublic(
        'dyofprakj',
        'jdc5wc1n',
      );

      // Upload the image 
       final ByteData imageByteData = pickedImage.buffer.asByteData();
      final ByteData bannerByteData = pickedBanner.buffer.asByteData();

      CloudinaryResponse imageResponse =
        await  cloudinary.uploadFile(CloudinaryFile.fromByteData(imageByteData, identifier: 'pickedImage',folder: 'categoryImages'));

      String image =  imageResponse.secureUrl;

      CloudinaryResponse bannerResponse =
        await cloudinary.uploadFile(CloudinaryFile.fromByteData(bannerByteData, identifier: 'pickedBanner',folder: 'categoryImages'));
      
      String banner = bannerResponse.secureUrl;
      Category category = Category(
        id: "", // Replace with actual ID or generate it
        name: name, // Replace with actual category name
        image: image,
        banner: banner,
      );
      http.Response response = await http.post(Uri.parse("$uri/api/categories"),
        body: category.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },

      );
      manageHttpResponse(response: response, context: context, onSuccess: () {
        showSnackBar(context, 'upload Category');
      });
    } catch (e) {
      print('Error uploading to cloundinary: $e');
    }
  }
}