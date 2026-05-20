import 'package:flutter_test/flutter_test.dart';
import 'package:math_riddles/core/utils/equation.dart';

void main() {
  group('EquationParser.parse', () {
    test('simple addition: A+A+A=30', () {
      final result = EquationParser.parse('A+A+A=30');
      expect(result.lhs, [
        const SymbolToken('A'),
        const OpToken('+'),
        const SymbolToken('A'),
        const OpToken('+'),
        const SymbolToken('A'),
      ]);
      expect(result.rhs, 30);
    });

    test('question form: A=?', () {
      final result = EquationParser.parse('A=?');
      expect(result.lhs, [const SymbolToken('A')]);
      expect(result.rhs, isNull);
    });

    test('mixed operators: A+B×C=42', () {
      final result = EquationParser.parse('A+B×C=42');
      expect(result.lhs, [
        const SymbolToken('A'),
        const OpToken('+'),
        const SymbolToken('B'),
        const OpToken('×'),
        const SymbolToken('C'),
      ]);
      expect(result.rhs, 42);
    });

    test('whitespace ignored', () {
      final result = EquationParser.parse(' A + B = 10 ');
      expect(result.lhs, [
        const SymbolToken('A'),
        const OpToken('+'),
        const SymbolToken('B'),
      ]);
      expect(result.rhs, 10);
    });

    test('division: A÷B=5', () {
      final result = EquationParser.parse('A÷B=5');
      expect(result.lhs.length, 3);
      expect((result.lhs[1] as OpToken).op, '÷');
    });

    test('ASCII * normalised to ×', () {
      final result = EquationParser.parse('A*B=6');
      expect((result.lhs[1] as OpToken).op, '×');
    });

    test('ASCII / normalised to ÷', () {
      final result = EquationParser.parse('A/B=3');
      expect((result.lhs[1] as OpToken).op, '÷');
    });

    test('literal on LHS: 2+A=10', () {
      final result = EquationParser.parse('2+A=10');
      expect(result.lhs[0], const LiteralToken(2));
    });

    test('multi-digit literal: A+10=20', () {
      final result = EquationParser.parse('A+10=20');
      expect(result.lhs[2], const LiteralToken(10));
      expect(result.rhs, 20);
    });

    test('symbols A through H accepted', () {
      for (final letter in ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H']) {
        final result = EquationParser.parse('$letter=?');
        expect(result.lhs, [SymbolToken(letter)]);
      }
    });

    test('throws on empty string', () {
      expect(
        () => EquationParser.parse(''),
        throwsA(isA<FormatException>()),
      );
    });

    test('throws on missing equals sign', () {
      expect(
        () => EquationParser.parse('A+B'),
        throwsA(isA<FormatException>()),
      );
    });

    test('throws on invalid RHS', () {
      expect(
        () => EquationParser.parse('A=xyz'),
        throwsA(isA<FormatException>()),
      );
    });

    test('throws on invalid character', () {
      expect(
        () => EquationParser.parse('A+@=5'),
        throwsA(isA<FormatException>()),
      );
    });
  });

  group('evaluate', () {
    test('simple addition: A+A+A with A=10 → 30', () {
      final result = EquationParser.parse('A+A+A=30');
      expect(evaluate(result.lhs, {'A': 10}), 30);
    });

    test('subtraction: A-B with A=10, B=3 → 7', () {
      final result = EquationParser.parse('A-B=7');
      expect(evaluate(result.lhs, {'A': 10, 'B': 3}), 7);
    });

    test('multiplication: A×B with A=5, B=6 → 30', () {
      final result = EquationParser.parse('A×B=30');
      expect(evaluate(result.lhs, {'A': 5, 'B': 6}), 30);
    });

    test('division: A÷B with A=20, B=4 → 5', () {
      final result = EquationParser.parse('A÷B=5');
      expect(evaluate(result.lhs, {'A': 20, 'B': 4}), 5);
    });

    test('PEMDAS: A+B×C with A=2, B=3, C=4 → 14', () {
      final result = EquationParser.parse('A+B×C=14');
      expect(evaluate(result.lhs, {'A': 2, 'B': 3, 'C': 4}), 14);
    });

    test('PEMDAS: A×B+C with A=3, B=4, C=5 → 17', () {
      final result = EquationParser.parse('A×B+C=17');
      expect(evaluate(result.lhs, {'A': 3, 'B': 4, 'C': 5}), 17);
    });

    test('mixed precedence: A+B×C-D÷E', () {
      // A=1, B=2, C=3, D=10, E=5 → 1 + 6 - 2 = 5
      final result = EquationParser.parse('A+B×C-D÷E=5');
      expect(
        evaluate(result.lhs, {'A': 1, 'B': 2, 'C': 3, 'D': 10, 'E': 5}),
        5,
      );
    });

    test('self-multiplication: A×A with A=7 → 49', () {
      final result = EquationParser.parse('A×A=49');
      expect(evaluate(result.lhs, {'A': 7}), 49);
    });

    test('literal in expression: 2+A with A=8 → 10', () {
      final result = EquationParser.parse('2+A=10');
      expect(evaluate(result.lhs, {'A': 8}), 10);
    });

    test('single symbol: A with A=42 → 42', () {
      final result = EquationParser.parse('A=42');
      expect(evaluate(result.lhs, {'A': 42}), 42);
    });

    test('throws on unknown token (?)', () {
      expect(
        () => evaluate([const UnknownToken()], {}),
        throwsA(isA<FormatException>()),
      );
    });

    test('throws on missing symbol in values', () {
      final result = EquationParser.parse('A+B=5');
      expect(
        () => evaluate(result.lhs, {'A': 1}),
        throwsA(isA<FormatException>()),
      );
    });

    test('throws on empty token list', () {
      expect(
        () => evaluate([], {}),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
