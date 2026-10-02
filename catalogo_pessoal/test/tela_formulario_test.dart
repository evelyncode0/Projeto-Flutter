import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:catalogo_pessoal/screens/tela_formulario.dart';

void main() {
  testWidgets('não permite criar item quando o título está vazio', (
    tester,
  ) async {
    // Arrange: abre a tela do formulário.
    await tester.pumpWidget(const MaterialApp(home: TelaFormulario()));

    // Act: tenta criar o item sem preencher os campos.
    await tester.tap(find.text('Criar curso'));

    await tester.pump();

    // Assert: verifica se a validação do título apareceu.
    expect(find.text('Digite o nome do curso'), findsOneWidget);
  });
}
