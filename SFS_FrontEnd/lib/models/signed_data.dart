import 'dart:convert';

import 'package:sfs_frontend/helper/chain.dart';
import 'package:sfs_frontend/models/data.dart';

import 'package:sfs_frontend/helper/type.dart';

//  Decorator pattern
class SignedData implements Data {
  final Bytes signature;
  final Data data;
  
  SignedData(this.signature, this.data);

  @override
  String toBase64() {
    return base64Encode(signature + encryptedKey + encryptedData);
  }

  static SignedData fromBytes(Bytes l) {
    var sig = l.sublist(0, Chain.keySize);
    var data = Data.fromBytes(l.sublist(Chain.keySize));
    
    return SignedData(
      sig, 
      data
    );
  }
  
  @override
  Bytes get encryptedData => data.encryptedData;
  
  @override
  Bytes get encryptedKey => data.encryptedKey;
}
