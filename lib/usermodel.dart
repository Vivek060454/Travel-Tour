

class UserModel{
  String? uid;
  String? email;
  String? phone;


  UserModel({this.uid,this.email,this.phone, required eamil});


  factory UserModel.fromMap(map){

    return UserModel(
      uid: map['uid'],
      eamil: map['email'],
      phone:map['phone'],);
  }
  Map<String,dynamic>
  toMap() {
    return {
      'uid':uid,
      'email':email,
      'phone':phone,


    };
  }
}





