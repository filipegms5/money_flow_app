
class Endpoint{
  static String get baseURL => 'http://10.0.2.2:8000';
  static String get transacoes => '/transacoes';
  static String get transacoesQtd => '/transacoes/qtd';
  static String get periodo => '/periodo';
  static String get usuario => '/usuario';
  static String get qrCode => '/scan';
  static String get createUser => '/signup';
  static String get loginUser => '/login';
  static String get logoutUser => '/usuarios/logout';
  static String get formasPagamento => '/formas-pagamento';
  static String get estabelecimentos => '/estabelecimentos';
  static String get categorias => '/categorias';
  static String get gastosCategoriasUltimoMes => '/transacoes/gastos-categorias/ultimo-mes';


  static String get metasFinanceiras => '/metas-financeiras';
  static String get metaAtiva => '/metas-financeiras/ativa';
  static String transacoesDaMeta(int id) => '/metas-financeiras/$id/transacoes';
}