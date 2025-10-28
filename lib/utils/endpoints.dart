
class Endpoint{
  static String get baseURL => 'http://10.0.2.2:8000';
  static String get transacoes => '/transacoes';
  static String get usuario => '/usuario';
  static String get qrCode => '/scan';
  static String get createUser => '/signup';
  static String get loginUser => '/login';
  static String get formasPagamento => '/formas-pagamento';
  static String get estabelecimentos => '/estabelecimentos';
}