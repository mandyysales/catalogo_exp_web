import 'package:firebase_ai/firebase_ai.dart';

class GeminiService {
  final model = FirebaseAI.googleAI().generativeModel(
    model: 'gemini-2.5-flash',
  );

  /// Gera a descrição de um equipamento a partir do nome
  Future<String> gerarDescricao(String nomeEquipamento) async {
    try {
      final prompt = [
        Content.text(
          'Create a 4 to 6-line description in portuguese of the equipment $nomeEquipamento stating what it is typically used for.'
        ),
      ];

      final response = await model.generateContent(prompt);
      return response.text ?? 'Descrição não gerada';
    } catch (e) {
      print('Erro ao gerar descrição: $e');
      return 'Erro ao gerar descrição';
    }
  }
}



