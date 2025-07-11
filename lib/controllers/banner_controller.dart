import 'dart:typed_data';
import 'package:app_web/global_variable.dart';
import 'package:app_web/models/banner.dart';
import 'package:app_web/views/services/manage_http_response.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:http/http.dart' as http;

class BannerController {
    uploadBanner({required Uint8List  pickedImage, required context}) async {
    try {
      final cloudinary = CloudinaryPublic(
        'dyofprakj',
        'jdc5wc1n',
      );

      // Upload the image 
       final ByteData imageByteData = pickedImage.buffer.asByteData();

      CloudinaryResponse imageResponse =
        await  cloudinary.uploadFile(CloudinaryFile.fromByteData(imageByteData, identifier: 'pickedImage',folder: 'banners'));

      String image =  imageResponse.secureUrl;

      BannerModel bannerModel = BannerModel(id: '', image: image);

      http.Response response = await http.post(Uri.parse("$uri/api/banners"),
        body: bannerModel.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },

      );
       manageHttpResponse(response: response, context: context, onSuccess: () {
        showSnackBar(context, 'Banner Uploaded');
      });
    } catch (e) {
      print('Error uploading to cloundinary: $e');
    }
  }
}