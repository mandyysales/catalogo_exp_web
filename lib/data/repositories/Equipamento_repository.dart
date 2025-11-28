
import 'dart:typed_data';

import 'package:catalogo_exp_web/Gemini/Descricao_requisicao.dart';
import 'package:catalogo_exp_web/models/Equipamento.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary/cloudinary.dart';

//import 'package:file_picker/file_picker.dart';
//import 'dart:io';

class EquipamentoRepository {
  final FirebaseFirestore firestore;
  final Cloudinary cloudinary;
  final GeminiService _geminiService = GeminiService();



  EquipamentoRepository({
    FirebaseFirestore? firestore,
    Cloudinary? cloudinary
  })  : firestore = firestore ?? FirebaseFirestore.instance, cloudinary = cloudinary ?? Cloudinary.signedConfig(
    apiKey: "651365192639175",
    apiSecret: "4HijGksNP_EVth8sjkvALhVQA2c",
    cloudName: "dektchdq8",
  );


  // -------------------------------
  // Upload da imagem
  // -------------------------------

  Future<String> uploadImage(Uint8List bytes, String id) async {
  
  final response = await cloudinary.upload(
    fileBytes: bytes,
    resourceType: CloudinaryResourceType.image,
    fileName: id,
    folder: "equipamentos",
  );

  if (response.isSuccessful) {
    return response.secureUrl!;
  }

  throw Exception("Erro ao enviar imagem para o Cloudinary: ${response.error}");
  }

  // -------------------------------
  // Adicionar Equipamento
  // ------------------------------
  Future<Equipamento> addEquipamento(
      Equipamento equipamento, Uint8List? imagem) async {

    final docRef = firestore.collection('equipamentos').doc();
    var equipamentoComId = equipamento.copyWith(id: docRef.id);
    String imagemUrl;

    if (imagem != null) {
      imagemUrl = await uploadImage(imagem, docRef.id);
    }else{
      imagemUrl = 'https://res.cloudinary.com/dektchdq8/image/upload/v1764240972/SemImagem_unypah.png';
    }

    equipamentoComId = equipamentoComId.copyWith(imageUrl: imagemUrl);


    await docRef.set(equipamentoComId.toMap());
    return equipamentoComId;
  }

  // -------------------------------
  // Stream de Equipamentos (tempo real)
  // -------------------------------
  Stream<List<Equipamento>> getEquipamentos() {
    return firestore.collection('equipamentos').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Equipamento.fromFirestore(
          doc.id,         // id vem do Firestore
          doc.data(),     // conteúdo do documento
        );
      }).toList();
    });
  }

  // -------------------------------
  // Deletar Equipamento
  // -------------------------------
  Future<void> deletarEquipamento(String id) async {
    try {
      await firestore.collection('equipamentos').doc(id).delete();
    } catch (e) {
      throw Exception('Erro ao deletar equipamento: $e');
    }
  }

  // -------------------------------
  // Atualizar Equipamento
  // -------------------------------
  Future<void> updateEquipamento(
    Equipamento equipamento,
    Uint8List? imagem,
  ) async {
    String imageUrl = equipamento.imageUrl;

    if (imagem != null) {
      final url = await uploadImage(imagem, equipamento.id);
      imageUrl = url;
    }

    await firestore.collection('equipamentos')
        .doc(equipamento.id)
        .update({
          ...equipamento.toMap(),
          'imageUrl': imageUrl,
        });
  }


  // -------------------------------
  // Atualizar Cliques Equipamento
  // -------------------------------
  Future<void> incrementarVisualizacao(String equipamentoId) async {
    try {
      await firestore.collection('equipamentos')
          .doc(equipamentoId) // ✅ usa o ID passado como argumento
          .update({'visualizacao': FieldValue.increment(1)});
    } catch (e) {
      print("Erro ao atualizar visualizacao: $e");
    }
  }


  Stream<List<Equipamento>> getTopVisualizados({int limit = 4}) {
  return firestore
      .collection('equipamentos')
      .orderBy('visualizacao', descending: true) // ordena do mais para o menos visualizado
      .limit(limit) // pega apenas o top N
      .snapshots()
      .map((snapshot) {
        return snapshot.docs.map((doc) {
          return Equipamento.fromFirestore(doc.id, doc.data());
        }).toList();
      });
  }

  Future<String> gerarDescricaoEquipamento(String nome) async {
    return await _geminiService.gerarDescricao(nome);
  }

}