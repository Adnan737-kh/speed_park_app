
import 'package:get/get_navigation/src/root/internacionalization.dart';

class Languages extends Translations {
  @override
  // TODO: implement keys
  Map<String, Map<String, String>> get keys => {
    'en_Us' :{
      'email_hint' : 'email',
      'new_user' : 'newuser',
      'validation' : 'Validation',
      'user_not_found' : 'User not found in database.',
      'invalid_email_or_password' : 'Invalid email or password',
      'enter_email_and_password' : 'Please enter email and password',

      //Firebase Collections
      'car_registration' : 'car_registration',
    }
  };

}