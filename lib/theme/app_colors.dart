import 'package:flutter/material.dart';

/// Classe que centraliza todas as cores utilizadas na aplicação
/// Fornece paletas de cores separadas para tema claro e tema escuro
class AppColors {
  // Cores primárias
  final Color primary; // Cor primária do tema (azul)
  final Color secondary; // Cor secundária do tema (cinza)
  
  // Cores de fundo
  final Color background; // Cor de fundo principal
  final Color surface; // Cor de superfície
  final Color cardBackground; // Cor de fundo dos cards
  
  // Cores semânticas
  final Color success; // Cor de sucesso (verde)
  final Color error; // Cor de erro (vermelho)
  final Color warning; // Cor de aviso (laranja)
  
  // Cores de texto
  final Color textPrimary; // Cor do texto principal
  final Color textSecondary; // Cor do texto secundário
  final Color textTertiary; // Cor do texto terciário
  
  // Cores de ícones
  final Color iconPrimary; // Cor primária dos ícones (azul)
  final Color iconSecondary; // Cor secundária dos ícones (cinza)
  
  // Cores de botões
  final Color buttonPrimary; // Cor de fundo do botão primário (azul)
  final Color buttonPrimaryText; // Cor do texto do botão primário (branco)
  final Color buttonSecondary; // Cor de fundo do botão secundário (cinza)
  final Color buttonSecondaryText; // Cor do texto do botão secundário (branco)
  final Color buttonDanger; // Cor de fundo do botão de perigo (vermelho)
  final Color buttonDangerText; // Cor do texto do botão de perigo (branco/preto)
  
  // Cores de sombra
  final Color shadowColor; // Cor das sombras
  
  // Cores especiais
  final Color divider; // Cor dos divisores
  final Color glassOverlay; // Cor do overlay de vidro (glassmorphism)
  final Color chartBackground; // Cor de fundo dos gráficos
  
  const AppColors({
    required this.primary,
    required this.secondary,
    required this.background,
    required this.surface,
    required this.cardBackground,
    required this.success,
    required this.error,
    required this.warning,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.iconPrimary,
    required this.iconSecondary,
    required this.buttonPrimary,
    required this.buttonPrimaryText,
    required this.buttonSecondary,
    required this.buttonSecondaryText,
    required this.buttonDanger,
    required this.buttonDangerText,
    required this.shadowColor,
    required this.divider,
    required this.glassOverlay,
    required this.chartBackground,
  });

  // Cores do tema claro
  static const AppColors light = AppColors(
    primary: Color(0xFF1976D2), // Azul-700 (azul mais escuro)
    secondary: Color(0xFF757575), // Cinza-600
    background: Color(0xFFF5F5F5), // Cinza claro (fundo principal)
    surface: Color(0xFFFFFFFF), // Branco puro (superfície)
    cardBackground: Color(0xFFFFFFFF), // Branco puro (fundo dos cards)
    success: Color(0xFF4CAF50), // Verde-500
    error: Color(0xFFF44336), // Vermelho-500
    warning: Color(0xFFFF9800), // Laranja-500
    textPrimary: Color(0xFF424242), // Cinza escuro (texto principal)
    textSecondary: Color(0xFF757575), // Cinza-600 (texto secundário)
    textTertiary: Color(0xFF9E9E9E), // Cinza-400 (texto terciário)
    iconPrimary: Color(0xFF1976D2), // Azul-700 (ícones primários)
    iconSecondary: Color(0xFF757575), // Cinza-600 (ícones secundários)
    buttonPrimary: Color(0xFF1976D2), // Azul-700 (botão primário)
    buttonPrimaryText: Color(0xFFFFFFFF), // Branco puro (texto do botão primário)
    buttonSecondary: Color(0xFF757575), // Cinza-600 (botão secundário)
    buttonSecondaryText: Color(0xFFFFFFFF), // Branco puro (texto do botão secundário)
    buttonDanger: Color(0xFFF44336), // Vermelho-500 (botão de perigo)
    buttonDangerText: Color(0xFFFFFFFF), // Branco puro (texto do botão de perigo)
    shadowColor: Color(0x33000000), // Preto com ~20% de opacidade (sombras)
    divider: Color(0xFFE0E0E0), // Cinza claro (divisores)
    glassOverlay: Color(0x1AFFFFFF), // Branco com ~10% de opacidade (overlay de vidro)
    chartBackground: Color(0xFFFFFFFF), // Branco puro (fundo dos gráficos)
  );

  // Cores do tema escuro
  static const AppColors dark = AppColors(
    primary: Color(0xFF64B5F6), // Azul claro-300
    secondary: Color(0xFF9E9E9E), // Cinza claro-500
    background: Color(0xFF121212), // Preto quase puro (fundo principal)
    surface: Color(0xFF1E1E1E), // Cinza muito escuro (superfície)
    cardBackground: Color(0xFF2D2D2D), // Cinza escuro (fundo dos cards)
    success: Color(0xFF81C784), // Verde claro-300
    error: Color(0xFFE57373), // Vermelho claro-300
    warning: Color(0xFFFFB74D), // Laranja claro-300
    textPrimary: Color(0xFFFFFFFF), // Branco puro (texto principal)
    textSecondary: Color(0xFFB0B0B0), // Cinza claro (texto secundário)
    textTertiary: Color(0xFF757575), // Cinza-600 (texto terciário)
    iconPrimary: Color(0xFF64B5F6), // Azul claro-300 (ícones primários)
    iconSecondary: Color(0xFF9E9E9E), // Cinza claro-500 (ícones secundários)
    buttonPrimary: Color(0xFF64B5F6), // Azul claro-300 (botão primário)
    buttonPrimaryText: Color(0xFF121212), // Preto quase puro (texto do botão primário)
    buttonSecondary: Color(0xFF616161), // Cinza-700 (botão secundário)
    buttonSecondaryText: Color(0xFFFFFFFF), // Branco puro (texto do botão secundário)
    buttonDanger: Color(0xFFE57373), // Vermelho claro-300 (botão de perigo)
    buttonDangerText: Color(0xFF121212), // Preto quase puro (texto do botão de perigo)
    shadowColor: Color(0x66000000), // Preto com ~40% de opacidade (sombras)
    divider: Color(0xFF424242), // Cinza-800 (divisores)
    glassOverlay: Color(0x1A000000), // Preto com ~10% de opacidade (overlay de vidro)
    chartBackground: Color(0xFF2D2D2D), // Cinza escuro (fundo dos gráficos)
  );
}

