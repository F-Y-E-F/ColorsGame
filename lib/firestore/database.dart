
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:color_run/models/user.dart';

class Database{

  final CollectionReference users = Firestore.instance.collection("users");


  Future<bool> checkUserContains(String uid) async{
    try{
      DocumentSnapshot snapshot = await users.document(uid).get();
      if(snapshot.exists){
        return true;
      }
      else{
        return false;
      }
    }catch(e){
      return null;
    }
  }

  Future insertUser(Map<String,dynamic> userMap) async{
    try{
      return await users.document(userMap['uid']).setData(userMap);
    }catch(e){
      return null;
    }
  }

  Future<User> getUserInfo(String uid) async{
    try{
      DocumentSnapshot snapshot = await users.document(uid).get();
      User user = User(uid: null, nickName: null,highScore: null);
      return user.userFromMap(snapshot.data);
    }catch(e){
      return null;
    }
  }

  Future updateNick(String newNick,String uid) async{
    try{
      return await users.document(uid).updateData({"nickName":newNick});
    }catch(e){
      return e.toString();
    }
  }

}