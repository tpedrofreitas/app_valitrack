import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiConfig {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8000/api',
  );

  static String buildUrl(String endpoint) {
    final trimmed = endpoint.trim();
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }

    final normalized = trimmed.startsWith('/') ? trimmed : '/$trimmed';
    return '$baseUrl$normalized';
  }
}

class ApiException implements Exception {
  ApiException(this.message, [this.statusCode]);

  final String message;
  final int? statusCode;

  @override
  String toString() =>
      'ApiException(statusCode: $statusCode, message: $message)';
}

class ApiClient {
  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<dynamic> get(String endpoint) async {
    final response = await _client
        .get(
          Uri.parse(ApiConfig.buildUrl(endpoint)),
          headers: {'Accept': 'application/json'},
        )
        .timeout(
          const Duration(seconds: 10),
          onTimeout: () => throw ApiException(
            'Tempo limite excedido ao conectar com a API.',
            408,
          ),
        );
    return _handleResponse(response);
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    final response = await _client
        .post(
          Uri.parse(ApiConfig.buildUrl(endpoint)),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          body: jsonEncode(body),
        )
        .timeout(
          const Duration(seconds: 10),
          onTimeout: () => throw ApiException(
            'Tempo limite excedido ao conectar com a API.',
            408,
          ),
        );
    return _handleResponse(response);
  }

  Future<dynamic> put(String endpoint, Map<String, dynamic> body) async {
    final response = await _client
        .put(
          Uri.parse(ApiConfig.buildUrl(endpoint)),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          body: jsonEncode(body),
        )
        .timeout(
          const Duration(seconds: 10),
          onTimeout: () => throw ApiException(
            'Tempo limite excedido ao conectar com a API.',
            408,
          ),
        );
    return _handleResponse(response);
  }

  Future<dynamic> delete(String endpoint) async {
    final response = await _client
        .delete(
          Uri.parse(ApiConfig.buildUrl(endpoint)),
          headers: {'Accept': 'application/json'},
        )
        .timeout(
          const Duration(seconds: 10),
          onTimeout: () => throw ApiException(
            'Tempo limite excedido ao conectar com a API.',
            408,
          ),
        );
    return _handleResponse(response);
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return null;
      }

      try {
        return jsonDecode(response.body);
      } on FormatException {
        return response.body;
      }
    }

    dynamic decoded;
    try {
      decoded = jsonDecode(response.body);
    } on FormatException {
      decoded = null;
    }

    final message = _extractErrorMessage(decoded, response.body);
    throw ApiException(message, response.statusCode);
  }

  String _extractErrorMessage(dynamic decoded, String body) {
    if (decoded is Map<String, dynamic>) {
      if (decoded['message'] != null) {
        return decoded['message'].toString();
      }
      if (decoded['errors'] is Map) {
        final errors = decoded['errors'] as Map;
        final firstError = errors.values.first;
        if (firstError is List && firstError.isNotEmpty) {
          return firstError.first.toString();
        }
      }
    }

    if (decoded is Map) {
      final message = decoded['message'];
      if (message != null) {
        return message.toString();
      }
    }

    return body.isNotEmpty ? body : 'Erro inesperado na API';
  }
}

class Categoria {
  Categoria({required this.id, required this.nome, required this.descricao});

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      id: json['id'] as int? ?? 0,
      nome: json['nome']?.toString() ?? '',
      descricao: json['descricao']?.toString() ?? '',
    );
  }

  final int id;
  final String nome;
  final String descricao;

  Map<String, dynamic> toJson() {
    return {'id': id, 'nome': nome, 'descricao': descricao};
  }
}

class Fornecedor {
  Fornecedor({
    required this.id,
    required this.nome,
    required this.contato,
    required this.telefone,
    required this.email,
    required this.cnpj,
    required this.endereco,
  });

  factory Fornecedor.fromJson(Map<String, dynamic> json) {
    return Fornecedor(
      id: json['id'] as int? ?? 0,
      nome: json['nome']?.toString() ?? '',
      contato: json['contato']?.toString() ?? '',
      telefone: json['telefone']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      cnpj: json['cnpj']?.toString() ?? '',
      endereco: json['endereco']?.toString() ?? '',
    );
  }

  final int id;
  final String nome;
  final String contato;
  final String telefone;
  final String email;
  final String cnpj;
  final String endereco;
}

class Produto {
  Produto({
    required this.id,
    required this.nome,
    required this.codigoBarras,
    required this.fabricante,
    required this.unidadeMedida,
    required this.imagem,
    required this.categoriaId,
    required this.estoqueMinimo,
    this.categoria,
  });

  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      id: json['id'] as int? ?? 0,
      nome: json['nome']?.toString() ?? '',
      codigoBarras: json['codigo_barras']?.toString() ?? '',
      fabricante: json['fabricante']?.toString() ?? '',
      unidadeMedida: json['unidade_medida']?.toString() ?? '',
      imagem: json['imagem']?.toString(),
      categoriaId: json['categoria_id'] as int? ?? 0,
      estoqueMinimo: json['estoque_minimo'] as int? ?? 0,
      categoria: json['categoria'] != null
          ? Categoria.fromJson(json['categoria'] as Map<String, dynamic>)
          : null,
    );
  }

  final int id;
  final String nome;
  final String codigoBarras;
  final String fabricante;
  final String unidadeMedida;
  final String? imagem;
  final int categoriaId;
  final int estoqueMinimo;
  final Categoria? categoria;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'codigo_barras': codigoBarras,
      'fabricante': fabricante,
      'unidade_medida': unidadeMedida,
      'imagem': imagem,
      'categoria_id': categoriaId,
      'estoque_minimo': estoqueMinimo,
    };
  }
}

class LoteEstoque {
  LoteEstoque({
    required this.id,
    required this.numeroLote,
    required this.quantidade,
    required this.saldoDisponivel,
    required this.dataValidade,
    required this.situacaoValidade,
    required this.textoValidade,
    required this.fornecedor,
  });

  factory LoteEstoque.fromJson(Map<String, dynamic> json) {
    return LoteEstoque(
      id: json['id'] as int? ?? 0,
      numeroLote: json['numero_lote']?.toString() ?? '',
      quantidade: json['quantidade'] as int? ?? 0,
      saldoDisponivel: json['saldo_disponivel'] as int? ?? 0,
      dataValidade: json['data_validade']?.toString() ?? '',
      situacaoValidade: json['situacao_validade']?.toString() ?? '',
      textoValidade: json['texto_validade']?.toString() ?? '',
      fornecedor: json['fornecedor']?.toString() ?? '',
    );
  }

  final int id;
  final String numeroLote;
  final int quantidade;
  final int saldoDisponivel;
  final String dataValidade;
  final String situacaoValidade;
  final String textoValidade;
  final String fornecedor;
}

class EstoqueDetalhado {
  EstoqueDetalhado({required this.produto, required this.lotes});

  factory EstoqueDetalhado.fromJson(Map<String, dynamic> json) {
    final productJson = json['produto'] as Map<String, dynamic>? ?? {};
    final lotesJson = json['lotes'] as List<dynamic>? ?? const [];

    return EstoqueDetalhado(
      produto: Produto.fromJson(productJson),
      lotes: lotesJson
          .map((item) => LoteEstoque.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  final Produto produto;
  final List<LoteEstoque> lotes;
}

class EstoqueResumo {
  EstoqueResumo({
    required this.id,
    required this.nome,
    required this.codigoBarras,
    required this.categoria,
    required this.estoqueMinimo,
    required this.estoqueDisponivel,
    required this.abaixoDoMinimo,
  });

  factory EstoqueResumo.fromJson(Map<String, dynamic> json) {
    return EstoqueResumo(
      id: json['id'] as int? ?? 0,
      nome: json['nome']?.toString() ?? '',
      codigoBarras: json['codigo_barras']?.toString() ?? '',
      categoria: json['categoria']?.toString() ?? '',
      estoqueMinimo: json['estoque_minimo'] as int? ?? 0,
      estoqueDisponivel: json['estoque_disponivel'] as int? ?? 0,
      abaixoDoMinimo: json['abaixo_do_minimo'] as bool? ?? false,
    );
  }

  final int id;
  final String nome;
  final String codigoBarras;
  final String categoria;
  final int estoqueMinimo;
  final int estoqueDisponivel;
  final bool abaixoDoMinimo;
}

class ValitrackApiService {
  ValitrackApiService({ApiClient? client}) : _client = client ?? ApiClient();

  final ApiClient _client;

  Future<List<Categoria>> getCategorias() async {
    final response = await _client.get('/categorias');
    if (response == null) return const [];
    final list = response as List<dynamic>;
    return list
        .map((item) => Categoria.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<List<Produto>> getProdutos() async {
    final response = await _client.get('/produtos');
    if (response == null) return const [];
    final list = response as List<dynamic>;
    return list
        .map((item) => Produto.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<List<Fornecedor>> getFornecedores() async {
    final response = await _client.get('/fornecedores');
    if (response == null) return const [];
    final list = response as List<dynamic>;
    return list
        .map((item) => Fornecedor.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<List<EstoqueResumo>> getEstoqueGeral() async {
    final response = await _client.get('/estoque');
    if (response == null) return const [];
    final list = response as List<dynamic>;
    return list
        .map((item) => EstoqueResumo.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<EstoqueDetalhado> getEstoqueDetalhado(int produtoId) async {
    final response = await _client.get('/estoque/$produtoId');
    return EstoqueDetalhado.fromJson(response as Map<String, dynamic>);
  }

  Future<Produto> createProduto(Map<String, dynamic> payload) async {
    final response = await _client.post('/produtos', payload);
    return Produto.fromJson(response as Map<String, dynamic>);
  }

  Future<void> deleteProduto(int id) async {
    await _client.delete('/produtos/$id');
  }
}
