import 'package:flutter/material.dart';

class CategoriaSelectField extends FormField<List<String>> {
  CategoriaSelectField({
    Key? key,
    required List<String> initialValue,
    required this.onChanged,
    required this.categoriasDisponiveis,
    String? Function(List<String>?)? validator,
    String label = "Categoria",
  }) : super(
          key: key,
          initialValue: initialValue,
          validator: validator,
          builder: (state) {
            return GestureDetector(
              onTap: () async {
                final selecionadas = List<String>.from(state.value ?? []);

                final resultado = await showDialog<List<String>>(
                  context: state.context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Selecionar Categorias"),
                      content: StatefulBuilder(
                        builder: (context, setStateSB) {
                          return SingleChildScrollView(
                            child: Column(
                              children: categoriasDisponiveis.map((cat) {
                                final isSelected = selecionadas.contains(cat);
                                return CheckboxListTile(
                                  title: Text(cat),
                                  value: isSelected,
                                  onChanged: (val) {
                                    if (val == true) {
                                      selecionadas.add(cat);
                                    } else {
                                      selecionadas.remove(cat);
                                    }
                                    setStateSB(() {});
                                  },
                                );
                              }).toList(),
                            ),
                          );
                        },
                      ),
                      actions: [
                        TextButton(
                          child: Text("Cancelar"),
                          onPressed: () => Navigator.pop(context),
                        ),
                        ElevatedButton(
                          child: Text("Confirmar"),
                          onPressed: () => Navigator.pop(context, selecionadas),
                        ),
                      ],
                    );
                  },
                );

                if (resultado != null) {
                  state.didChange(resultado);
                  onChanged(resultado);
                }
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 18,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    )
                  ],
                ),
                child: Text(
                  (state.value == null || state.value!.isEmpty)
                      ? "Selecione uma ou mais categorias"
                      : state.value!.join(", "),
                  style: TextStyle(
                    color: (state.value == null || state.value!.isEmpty)
                        ? Colors.grey
                        : Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            );
          },
        );

  final Function(List<String>) onChanged;
  final List<String> categoriasDisponiveis;
}
