/// Equation parser & evaluator for Math Riddles.
///
/// Parses human-readable equation strings like "A+B×C=42" or "A=?"
/// into structured tokens, then evaluates the left-hand side given a
/// symbol→int mapping.
///
/// See architecture.md §2.7 for the public surface contract.
library;

import 'package:flutter/foundation.dart' show immutable;

// ─── Tokens ───

/// Base class for equation tokens.
sealed class Token {
  const Token();
}

/// A letter-variable symbol: A, B, C, … H.
@immutable
class SymbolToken extends Token {
  const SymbolToken(this.letter);
  final String letter;

  @override
  bool operator ==(Object other) =>
      other is SymbolToken && other.letter == letter;

  @override
  int get hashCode => letter.hashCode;

  @override
  String toString() => 'Symbol($letter)';
}

/// An operator: +, -, ×, ÷.
@immutable
class OpToken extends Token {
  const OpToken(this.op);
  final String op;

  @override
  bool operator ==(Object other) => other is OpToken && other.op == op;

  @override
  int get hashCode => op.hashCode;

  @override
  String toString() => 'Op($op)';
}

/// An integer literal.
@immutable
class LiteralToken extends Token {
  const LiteralToken(this.value);
  final int value;

  @override
  bool operator ==(Object other) =>
      other is LiteralToken && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Literal($value)';
}

/// The unknown placeholder: `?`.
@immutable
class UnknownToken extends Token {
  const UnknownToken();

  @override
  bool operator ==(Object other) => other is UnknownToken;

  @override
  int get hashCode => 0;

  @override
  String toString() => 'Unknown';
}

// ─── Parser ───

/// Parses an equation string into LHS tokens and an optional RHS integer.
///
/// - "A+B×C=42" → (tokens=[Symbol(A), Op(+), Symbol(B), Op(×), Symbol(C)],
///                  rhs=42)
/// - "A=?"      → (tokens=[Symbol(A)], rhs=null)
///
/// Whitespace is ignored. Throws [FormatException] on malformed input.
class EquationParser {
  EquationParser._();

  static ({List<Token> lhs, int? rhs}) parse(String s) {
    final cleaned = s.replaceAll(' ', '');
    if (cleaned.isEmpty) {
      throw const FormatException('Empty equation string');
    }

    final eqIndex = cleaned.indexOf('=');
    if (eqIndex == -1) {
      throw FormatException('No "=" found in equation: $s');
    }

    final lhsStr = cleaned.substring(0, eqIndex);
    final rhsStr = cleaned.substring(eqIndex + 1);

    final lhsTokens = _tokenize(lhsStr);
    if (lhsTokens.isEmpty) {
      throw FormatException('Empty left-hand side in equation: $s');
    }

    // RHS is either "?" (unknown) or an integer.
    int? rhs;
    if (rhsStr == '?') {
      rhs = null;
    } else {
      rhs = int.tryParse(rhsStr);
      if (rhs == null) {
        throw FormatException('Invalid RHS "$rhsStr" in equation: $s');
      }
    }

    return (lhs: lhsTokens, rhs: rhs);
  }

  static List<Token> _tokenize(String expr) {
    final tokens = <Token>[];
    var i = 0;
    while (i < expr.length) {
      final ch = expr[i];

      // Letter symbol A-H
      if (_isSymbolLetter(ch)) {
        tokens.add(SymbolToken(ch));
        i++;
        continue;
      }

      // Operator
      if (_isOperator(ch)) {
        tokens.add(OpToken(_normalizeOp(ch)));
        i++;
        continue;
      }

      // Digit — consume all consecutive digits
      if (_isDigit(ch)) {
        final start = i;
        while (i < expr.length && _isDigit(expr[i])) {
          i++;
        }
        tokens.add(LiteralToken(int.parse(expr.substring(start, i))));
        continue;
      }

      // Unknown
      if (ch == '?') {
        tokens.add(const UnknownToken());
        i++;
        continue;
      }

      throw FormatException('Unexpected character "$ch" at position $i');
    }
    return tokens;
  }

  static bool _isSymbolLetter(String ch) {
    final code = ch.codeUnitAt(0);
    // A (65) through H (72)
    return code >= 65 && code <= 72;
  }

  static bool _isOperator(String ch) =>
      ch == '+' ||
      ch == '-' ||
      ch == '×' ||
      ch == '÷' ||
      ch == '*' ||
      ch == '/';

  /// Normalize ASCII * and / to × and ÷ for consistent internal handling.
  static String _normalizeOp(String ch) {
    if (ch == '*') return '×';
    if (ch == '/') return '÷';
    return ch;
  }

  static bool _isDigit(String ch) {
    final code = ch.codeUnitAt(0);
    return code >= 48 && code <= 57; // '0'..'9'
  }
}

// ─── Evaluator ───

/// Evaluates a list of tokens with PEMDAS (×÷ before +-) using the given
/// symbol→int mapping.
///
/// Throws [FormatException] if an [UnknownToken] is present or a symbol
/// is not found in [values].
int evaluate(List<Token> tokens, Map<String, int> values) {
  if (tokens.isEmpty) {
    throw const FormatException('Cannot evaluate empty token list');
  }

  // Convert tokens to a list of ints and ops.
  final nums = <int>[];
  final ops = <String>[];

  for (final token in tokens) {
    switch (token) {
      case SymbolToken():
        final v = values[token.letter];
        if (v == null) {
          throw FormatException(
            'Symbol "${token.letter}" not found in values map',
          );
        }
        nums.add(v);
      case LiteralToken():
        nums.add(token.value);
      case OpToken():
        ops.add(token.op);
      case UnknownToken():
        throw const FormatException(
          'Cannot evaluate expression containing unknown (?)',
        );
    }
  }

  if (nums.length != ops.length + 1) {
    throw const FormatException(
      'Malformed expression: mismatched operators and operands',
    );
  }

  // Pass 1: resolve × and ÷ (left-to-right).
  final nums2 = <int>[nums[0]];
  final ops2 = <String>[];

  for (var i = 0; i < ops.length; i++) {
    if (ops[i] == '×' || ops[i] == '÷') {
      final left = nums2.removeLast();
      final right = nums[i + 1];
      nums2.add(ops[i] == '×' ? left * right : left ~/ right);
    } else {
      nums2.add(nums[i + 1]);
      ops2.add(ops[i]);
    }
  }

  // Pass 2: resolve + and − (left-to-right).
  var result = nums2[0];
  for (var i = 0; i < ops2.length; i++) {
    if (ops2[i] == '+') {
      result += nums2[i + 1];
    } else {
      result -= nums2[i + 1];
    }
  }

  return result;
}
