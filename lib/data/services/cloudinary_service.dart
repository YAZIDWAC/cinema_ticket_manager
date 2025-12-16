import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class CloudinaryService {
  static const String cloudName = 'dqurt5mcf'; // ⚠️ le tien
  static const String uploadPreset = 'movies'; // ⚠️ ton preset

  static Future<String?> uploadImage(File image) async {
    final uri = Uri.parse(
      'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
    );

    final request = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(
        await http.MultipartFile.fromPath('file', image.path),
      );

    final response = await request.send();
    final responseData = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final decoded = jsonDecode(responseData);
      return decoded['secure_url']; // ✅ URL AUTOMATIQUE
    } else {
      print('❌ Cloudinary error: $responseData');
      return null;
    }
  }
}
