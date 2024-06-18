import 'package:dartz/dartz.dart';
import 'package:flutter_absensi_app/core/constants/variables.dart';
import 'package:http/http.dart' as http;

import '../models/response/user_response_model.dart';

class AuthRemoteDatasource {

  Future<Either<String, UserResponseModel>> updateProfileRegisterFace(
    String embedding,
  ) async {
    final url = Uri.parse('${Variables.baseUrl}/api/update-profile');
    final request = http.MultipartRequest('POST', url)
      ..fields['face_embedding'] = embedding
      ..headers['Accept'] = 'application/json'
      ..headers['Content-Type'] = 'application/json';

    final response = await request.send();
    final responseString = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      return Right(UserResponseModel.fromJson(responseString));
    } else {
      return Left('Failed to update profile: ${responseString}');
    }
  }
}
