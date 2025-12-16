import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:yumshare/models/country.dart';

class CountryRepo {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  var logger = Logger();

  Future<List<Country>> fetchCountries() async {
    try {
      final querySnapshot = await firestore.collection('countries').orderBy('name').get();

      return querySnapshot.docs.map((doc) => Country.fromMap(doc.data())).toList();
    } catch (e) {
      logger.e("Error fetching countries", error: e);
      rethrow;
    }
  }
}
