import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const Color kPrimaryBlue = Color(0xFF274B7F);
const Color kAccentBlue = Color(0xFFE8EEF5);

// This must be a global variable in its own file
final viewModeProvider = StateProvider<bool>((ref) => false);