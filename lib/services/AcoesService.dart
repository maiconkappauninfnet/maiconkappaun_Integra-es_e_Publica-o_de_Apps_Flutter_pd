import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_2/models/acoes.dart';

class AcoesService {
  late CollectionReference _acoes;

  AcoesService() {
    final firebaseFirestore = FirebaseFirestore.instance;
    _acoes = firebaseFirestore.collection('acoes');
  }

  Future<String> addAcao(Acao acao) async {
    var docRef = await _acoes.add(acao.toMap());
    return docRef.id;
  }

  Future<Acao?> getAcao(String acaoId) async {
    var docRef = await _acoes.doc(acaoId).get();
    if (docRef.exists) {
      return Acao.fromDocument(docRef);
    } else {
      return null;
    }
  }

  Future<void> updateAcao(Acao acao) async {
    await _acoes.doc(acao.id).update(acao.toMap());
  }

  Future<void> deleteAcao(String acaoId) async {
    await _acoes.doc(acaoId).delete();
  }

  Future<List<Acao>> getAll() async {
    var snapshot = await _acoes.get();
    return snapshot.docs.map((docRef) => Acao.fromDocument(docRef)).toList();
  }
}
