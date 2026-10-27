import 'package:flutter/material.dart';
import 'package:app_valitrack/valitrack_api.dart';

void main() {
  runApp(const ValitrackApp());
}

class ValitrackApp extends StatelessWidget {
  const ValitrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ValiTrack',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF1E8E76),
        scaffoldBackgroundColor: const Color(0xFFF5F7FB),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF172A35),
          elevation: 0,
        ),
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _userController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _userController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final user = _userController.text.trim();
    final password = _passwordController.text.trim();

    if (user == 'admin' && password == '123456') {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const AppShell()));
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Usuário ou senha inválidos'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  InputDecoration _decoration({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon),
      suffixIcon: suffix,
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFD5DDE3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF1E8E76), width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F172A), Color(0xFF1E8E76)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(28),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Center(
                            child: Container(
                              width: 84,
                              height: 84,
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFF1E8E76,
                                ).withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: const Icon(
                                Icons.inventory_2_rounded,
                                size: 40,
                                color: Color(0xFF1E8E76),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Center(
                            child: Text(
                              'ValiTrack',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF172A35),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Center(
                            child: Text(
                              'Acesse sua conta',
                              style: TextStyle(
                                fontSize: 15,
                                color: Color(0xFF60717B),
                              ),
                            ),
                          ),
                          const SizedBox(height: 28),
                          const Text(
                            'Usuário',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF172A35),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _userController,
                            textInputAction: TextInputAction.next,
                            decoration: _decoration(
                              hint: 'Digite seu usuário',
                              icon: Icons.person_outline_rounded,
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Informe o usuário';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Senha',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF172A35),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _login(),
                            decoration: _decoration(
                              hint: 'Digite sua senha',
                              icon: Icons.lock_outline_rounded,
                              suffix: IconButton(
                                onPressed: () => setState(
                                  () => _obscurePassword = !_obscurePassword,
                                ),
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Informe a senha';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          FilledButton(
                            onPressed: _login,
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: const Color(0xFF1E8E76),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: const Text(
                              'Entrar',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

const _kGreen = Color(0xFF1E8E76);
const _kDark = Color(0xFF172A35);
const _kMuted = Color(0xFF60717B);
const _kAmber = Color(0xFFF59E0B);
const _kRed = Color(0xFFEF4444);

/// Lote com saldo, já com os dias até o vencimento calculados.
class LoteInfo {
  LoteInfo({
    required this.produtoNome,
    required this.lote,
    required this.data,
    required this.dias,
  });

  final String produtoNome;
  final LoteEstoque lote;
  final DateTime? data;
  final int? dias;

  bool get vencido => dias != null && dias! < 0;
}

String _errorMessage(Object error) {
  if (error is ApiException) return error.message;
  if (error is TypeError || error is FormatException) {
    return 'A API retornou uma resposta inesperada.';
  }
  return 'Não foi possível conectar com a API.';
}

String _formatDate(DateTime d) {
  final day = d.day.toString().padLeft(2, '0');
  final month = d.month.toString().padLeft(2, '0');
  return '$day/$month/${d.year}';
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final _api = ValitrackApiService();

  int _selectedIndex = 0;

  bool _loading = true;
  bool _lotesLoading = false;
  String? _error;

  List<Produto> _produtos = [];
  List<EstoqueResumo> _estoque = [];
  List<Categoria> _categorias = [];
  List<Fornecedor> _fornecedores = [];
  List<LoteInfo> _lotes = [];

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  Future<void> _loadAll() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final results = await Future.wait<dynamic>([
        _api.getProdutos(),
        _api.getEstoqueGeral(),
        _api.getCategorias(),
        _api.getFornecedores().catchError((_) => <Fornecedor>[]),
      ]);

      if (!mounted) return;
      setState(() {
        _produtos = results[0] as List<Produto>;
        _estoque = results[1] as List<EstoqueResumo>;
        _categorias = results[2] as List<Categoria>;
        _fornecedores = results[3] as List<Fornecedor>;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = _errorMessage(e);
      });
      return;
    }

    await _loadLotes();
  }

  /// A validade só existe por lote, então busca o detalhe de cada produto.
  Future<void> _loadLotes() async {
    if (!mounted) return;
    setState(() => _lotesLoading = true);

    final detalhes = <int, EstoqueDetalhado>{};
    const batchSize = 4;

    // Busca em pequenos grupos para não sobrecarregar o servidor local.
    for (var i = 0; i < _produtos.length; i += batchSize) {
      final batch = _produtos.skip(i).take(batchSize).toList();

      await Future.wait(
        batch.map((p) async {
          try {
            detalhes[p.id] = await _api.getEstoqueDetalhado(p.id);
          } catch (_) {
            // Ignora falha de um produto e segue com os demais.
          }
        }),
      );

      if (!mounted) return;
      setState(() => _lotes = _buildLotes(detalhes));
    }

    if (!mounted) return;
    setState(() => _lotesLoading = false);
  }

  List<LoteInfo> _buildLotes(Map<int, EstoqueDetalhado> detalhes) {
    final now = DateTime.now();
    final today = DateTime.utc(now.year, now.month, now.day);
    final list = <LoteInfo>[];

    for (final produto in _produtos) {
      final detalhe = detalhes[produto.id];
      if (detalhe == null) continue;

      for (final lote in detalhe.lotes) {
        if (lote.saldoDisponivel <= 0) continue;

        final parsed = DateTime.tryParse(lote.dataValidade);
        DateTime? data;
        int? dias;
        if (parsed != null) {
          data = DateTime.utc(parsed.year, parsed.month, parsed.day);
          dias = data.difference(today).inDays;
        }

        list.add(
          LoteInfo(
            produtoNome: produto.nome,
            lote: lote,
            data: data,
            dias: dias,
          ),
        );
      }
    }

    list.sort((a, b) {
      final da = a.dias;
      final db = b.dias;
      if (da == null && db == null) return 0;
      if (da == null) return 1;
      if (db == null) return -1;
      return da.compareTo(db);
    });

    return list;
  }

  void _showSnack(String message, {SnackBarAction? action}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        duration: Duration(seconds: action == null ? 4 : 8),
        action: action,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Future<void> _showAddProductDialog() async {
    if (_categorias.isEmpty) {
      _showSnack(
        _loading
            ? 'Aguarde o carregamento dos dados.'
            : 'Cadastre uma categoria na API antes de adicionar produtos.',
      );
      return;
    }

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _ProductFormDialog(
        categorias: _categorias,
        fornecedores: _fornecedores,
        onSubmit: _createProduct,
      ),
    );
  }

  /// Cria o produto e, se informado, o lote com a validade.
  /// Retorna a mensagem de erro, ou null se o produto foi criado.
  Future<String?> _createProduct(
    Map<String, dynamic> payload,
    Map<String, dynamic>? lote,
  ) async {
    final Produto produto;
    try {
      produto = await _api.createProduto(payload);
    } catch (e) {
      return _errorMessage(e);
    }

    String? loteError;
    if (lote != null) {
      try {
        await _api.createLote(produto.id, lote);
      } catch (e) {
        loteError = _errorMessage(e);
      }
    }

    if (mounted) {
      final addLoteAction = SnackBarAction(
        label: 'Adicionar lote',
        onPressed: () {
          if (mounted) _showAddLoteDialog(produto);
        },
      );

      if (lote == null) {
        _showSnack('Produto cadastrado com sucesso', action: addLoteAction);
      } else if (loteError == null) {
        _showSnack('Produto e lote cadastrados com sucesso');
      } else {
        _showSnack(
          'Produto cadastrado, mas o lote não foi salvo: $loteError',
          action: addLoteAction,
        );
      }
      _loadAll();
    }
    return null;
  }

  Future<void> _showAddLoteDialog(Produto produto) async {
    if (_fornecedores.isEmpty) {
      _showSnack('Cadastre um fornecedor na API antes de adicionar lotes.');
      return;
    }

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _LoteFormDialog(
        produto: produto,
        fornecedores: _fornecedores,
        onSubmit: (payload) => _createLote(produto, payload),
      ),
    );
  }

  /// Retorna a mensagem de erro, ou null se deu certo.
  Future<String?> _createLote(
    Produto produto,
    Map<String, dynamic> payload,
  ) async {
    try {
      await _api.createLote(produto.id, payload);
    } catch (e) {
      return _errorMessage(e);
    }

    if (mounted) {
      _showSnack('Lote cadastrado com sucesso');
      _loadAll();
    }
    return null;
  }

  Future<void> _deleteProduct(Produto produto) async {
    try {
      await _api.deleteProduto(produto.id);
    } catch (e) {
      if (mounted) _showSnack(_errorMessage(e));
      return;
    }

    if (!mounted) return;
    _showSnack('Produto removido');
    await _loadAll();
  }

  Future<void> _showLogoutDialog() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Sair'),
          content: const Text('Deseja voltar para a tela de login?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Sair'),
            ),
          ],
        );
      },
    );

    if (shouldLogout == true) {
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final estoqueById = {for (final e in _estoque) e.id: e};

    final pages = <Widget>[
      DashboardPage(
        produtos: _produtos,
        estoque: _estoque,
        lotes: _lotes,
        loading: _loading,
        lotesLoading: _lotesLoading,
        error: _error,
        onRefresh: _loadAll,
        onAdd: _showAddProductDialog,
        onLogout: _showLogoutDialog,
      ),
      ProdutosPage(
        produtos: _produtos,
        estoqueById: estoqueById,
        loading: _loading,
        error: _error,
        onRefresh: _loadAll,
        onAdd: _showAddProductDialog,
        onDelete: _deleteProduct,
        onAddLote: _showAddLoteDialog,
      ),
      ValidadePage(
        lotes: _lotes,
        hasProducts: _produtos.isNotEmpty,
        loading: _loading,
        lotesLoading: _lotesLoading,
        error: _error,
        onRefresh: _loadAll,
      ),
      EstoquePage(
        estoque: _estoque,
        loading: _loading,
        error: _error,
        onRefresh: _loadAll,
      ),
    ];

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        backgroundColor: Colors.white,
        indicatorColor: _kGreen.withValues(alpha: 0.12),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard_rounded),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2_rounded),
            label: 'Produtos',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_today_outlined),
            selectedIcon: Icon(Icons.calendar_today_rounded),
            label: 'Validade',
          ),
          NavigationDestination(
            icon: Icon(Icons.storage_outlined),
            selectedIcon: Icon(Icons.storage_rounded),
            label: 'Estoque',
          ),
        ],
      ),
    );
  }
}
//parte 2
// ---------------------------------------------------------------------------
// Formulário de cadastro de produto (com lote e validade opcionais)
// ---------------------------------------------------------------------------

class _ProductFormDialog extends StatefulWidget {
  const _ProductFormDialog({
    required this.categorias,
    required this.fornecedores,
    required this.onSubmit,
  });

  final List<Categoria> categorias;
  final List<Fornecedor> fornecedores;
  final Future<String?> Function(
    Map<String, dynamic> produto,
    Map<String, dynamic>? lote,
  )
  onSubmit;

  @override
  State<_ProductFormDialog> createState() => _ProductFormDialogState();
}

class _ProductFormDialogState extends State<_ProductFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _codigoController = TextEditingController();
  final _fabricanteController = TextEditingController();
  final _unidadeController = TextEditingController(text: 'UND');
  final _minimoController = TextEditingController(text: '0');

  final _loteController = TextEditingController();
  final _quantidadeController = TextEditingController();
  final _fabricacaoController = TextEditingController();
  final _validadeController = TextEditingController();

  // Categoria e fornecedor não aparecem na tela: o app usa o primeiro da lista.
  int? _categoriaId;
  int? _fornecedorId;
  DateTime? _fabricacao;
  DateTime? _validade;
  bool _addLote = false;
  bool _saving = false;
  String? _error;

  bool get _canAddLote => widget.fornecedores.isNotEmpty;

  @override
  void initState() {
    super.initState();
    if (widget.categorias.isNotEmpty) {
      _categoriaId = widget.categorias.first.id;
    }
    if (widget.fornecedores.isNotEmpty) {
      _fornecedorId = widget.fornecedores.first.id;
    }
    _addLote = _canAddLote;
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _codigoController.dispose();
    _fabricanteController.dispose();
    _unidadeController.dispose();
    _minimoController.dispose();
    _loteController.dispose();
    _quantidadeController.dispose();
    _fabricacaoController.dispose();
    _validadeController.dispose();
    super.dispose();
  }

  String? _required(String? value, String message) {
    if (value == null || value.trim().isEmpty) return message;
    return null;
  }

  String _iso(DateTime d) {
    final month = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '${d.year}-$month-$day';
  }

  Future<void> _pickFabricacao() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _fabricacao ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked == null) return;
    setState(() {
      _fabricacao = picked;
      _fabricacaoController.text = _formatDate(picked);
    });
  }

  Future<void> _pickValidade() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _validade ?? _fabricacao ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked == null) return;
    setState(() {
      _validade = picked;
      _validadeController.text = _formatDate(picked);
    });
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    Map<String, dynamic>? lote;
    if (_addLote) {
      final fabricacao = _fabricacao;
      final validade = _validade;
      if (fabricacao == null || validade == null) return;

      lote = <String, dynamic>{
        'numero_lote': _loteController.text.trim(),
        'quantidade': int.parse(_quantidadeController.text.trim()),
        'data_fabricacao': _iso(fabricacao),
        'data_validade': _iso(validade),
        'fornecedor_id': _fornecedorId,
      };
    }

    setState(() {
      _saving = true;
      _error = null;
    });

    final produto = <String, dynamic>{
      'nome': _nomeController.text.trim(),
      'codigo_barras': _codigoController.text.trim(),
      'fabricante': _fabricanteController.text.trim(),
      'unidade_medida': _unidadeController.text.trim(),
      'categoria_id': _categoriaId,
      'estoque_minimo': int.tryParse(_minimoController.text.trim()) ?? 0,
    };

    final error = await widget.onSubmit(produto, lote);
    if (!mounted) return;

    if (error == null) {
      Navigator.of(context).pop();
    } else {
      setState(() {
        _saving = false;
        _error = error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Cadastrar produto'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nomeController,
                maxLength: 150,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Nome do produto',
                  counterText: '',
                ),
                validator: (v) => _required(v, 'Informe o nome'),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _codigoController,
                maxLength: 50,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Código de barras',
                  counterText: '',
                ),
                validator: (v) => _required(v, 'Informe o código de barras'),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _fabricanteController,
                maxLength: 100,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Fabricante',
                  counterText: '',
                ),
                validator: (v) => _required(v, 'Informe o fabricante'),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _unidadeController,
                maxLength: 20,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Unidade de medida',
                  counterText: '',
                ),
                validator: (v) => _required(v, 'Informe a unidade'),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _minimoController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Estoque mínimo'),
                validator: (v) {
                  final text = v?.trim() ?? '';
                  if (text.isEmpty) return null;
                  final n = int.tryParse(text);
                  if (n == null || n < 0) return 'Informe um número válido';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              const Divider(height: 1),
              if (_canAddLote)
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    'Cadastrar lote com validade',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                  subtitle: const Text(
                    'Entrada de estoque deste produto',
                    style: TextStyle(fontSize: 12),
                  ),
                  value: _addLote,
                  onChanged: _saving
                      ? null
                      : (v) => setState(() => _addLote = v),
                )
              else
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    'Cadastre um fornecedor na API para informar a validade.',
                    style: TextStyle(fontSize: 12, color: _kMuted),
                  ),
                ),
              if (_addLote) ...[
                TextFormField(
                  controller: _loteController,
                  maxLength: 50,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Número do lote',
                    counterText: '',
                  ),
                  validator: (v) => _required(v, 'Informe o número do lote'),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _quantidadeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Quantidade inicial',
                  ),
                  validator: (v) {
                    final n = int.tryParse(v?.trim() ?? '');
                    if (n == null || n < 1) {
                      return 'Informe uma quantidade válida';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _fabricacaoController,
                  readOnly: true,
                  onTap: _pickFabricacao,
                  decoration: const InputDecoration(
                    labelText: 'Data de fabricação',
                    suffixIcon: Icon(Icons.calendar_today_rounded, size: 18),
                  ),
                  validator: (_) => _fabricacao == null
                      ? 'Informe a data de fabricação'
                      : null,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _validadeController,
                  readOnly: true,
                  onTap: _pickValidade,
                  decoration: const InputDecoration(
                    labelText: 'Data de validade',
                    suffixIcon: Icon(Icons.calendar_today_rounded, size: 18),
                  ),
                  validator: (_) {
                    final validade = _validade;
                    final fabricacao = _fabricacao;
                    if (validade == null) return 'Informe a data de validade';
                    if (fabricacao != null && validade.isBefore(fabricacao)) {
                      return 'Anterior à data de fabricação';
                    }
                    return null;
                  },
                ),
              ],
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(
                  _error!,
                  style: const TextStyle(color: _kRed, fontSize: 13),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: _saving ? null : _submit,
          child: _saving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text('Salvar'),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Formulário de cadastro de lote (entrada de estoque com validade)
// ---------------------------------------------------------------------------

class _LoteFormDialog extends StatefulWidget {
  const _LoteFormDialog({
    required this.produto,
    required this.fornecedores,
    required this.onSubmit,
  });

  final Produto produto;
  final List<Fornecedor> fornecedores;
  final Future<String?> Function(Map<String, dynamic> payload) onSubmit;

  @override
  State<_LoteFormDialog> createState() => _LoteFormDialogState();
}

class _LoteFormDialogState extends State<_LoteFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _loteController = TextEditingController();
  final _quantidadeController = TextEditingController();
  final _fabricacaoController = TextEditingController();
  final _validadeController = TextEditingController();

  DateTime? _fabricacao;
  DateTime? _validade;
  int? _fornecedorId;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (widget.fornecedores.isNotEmpty) {
      _fornecedorId = widget.fornecedores.first.id;
    }
  }

  @override
  void dispose() {
    _loteController.dispose();
    _quantidadeController.dispose();
    _fabricacaoController.dispose();
    _validadeController.dispose();
    super.dispose();
  }

  String _iso(DateTime d) {
    final month = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '${d.year}-$month-$day';
  }

  Future<void> _pickFabricacao() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _fabricacao ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked == null) return;
    setState(() {
      _fabricacao = picked;
      _fabricacaoController.text = _formatDate(picked);
    });
  }

  Future<void> _pickValidade() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _validade ?? _fabricacao ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked == null) return;
    setState(() {
      _validade = picked;
      _validadeController.text = _formatDate(picked);
    });
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final fabricacao = _fabricacao;
    final validade = _validade;
    if (fabricacao == null || validade == null) return;

    setState(() {
      _saving = true;
      _error = null;
    });

    final payload = <String, dynamic>{
      'numero_lote': _loteController.text.trim(),
      'quantidade': int.parse(_quantidadeController.text.trim()),
      'data_fabricacao': _iso(fabricacao),
      'data_validade': _iso(validade),
      'fornecedor_id': _fornecedorId,
    };

    final error = await widget.onSubmit(payload);
    if (!mounted) return;

    if (error == null) {
      Navigator.of(context).pop();
    } else {
      setState(() {
        _saving = false;
        _error = error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Adicionar lote'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.produto.nome,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: _kDark,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _loteController,
                maxLength: 50,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Número do lote',
                  counterText: '',
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Informe o número do lote'
                    : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _quantidadeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Quantidade'),
                validator: (v) {
                  final n = int.tryParse(v?.trim() ?? '');
                  if (n == null || n < 1)
                    return 'Informe uma quantidade válida';
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _fabricacaoController,
                readOnly: true,
                onTap: _pickFabricacao,
                decoration: const InputDecoration(
                  labelText: 'Data de fabricação',
                  suffixIcon: Icon(Icons.calendar_today_rounded, size: 18),
                ),
                validator: (_) =>
                    _fabricacao == null ? 'Informe a data de fabricação' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _validadeController,
                readOnly: true,
                onTap: _pickValidade,
                decoration: const InputDecoration(
                  labelText: 'Data de validade',
                  suffixIcon: Icon(Icons.calendar_today_rounded, size: 18),
                ),
                validator: (_) {
                  final validade = _validade;
                  final fabricacao = _fabricacao;
                  if (validade == null) return 'Informe a data de validade';
                  if (fabricacao != null && validade.isBefore(fabricacao)) {
                    return 'Anterior à data de fabricação';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<int>(
                initialValue: _fornecedorId,
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'Fornecedor'),
                items: widget.fornecedores
                    .map(
                      (f) => DropdownMenuItem<int>(
                        value: f.id,
                        child: Text(f.nome, overflow: TextOverflow.ellipsis),
                      ),
                    )
                    .toList(),
                onChanged: _saving
                    ? null
                    : (value) => setState(() => _fornecedorId = value),
                validator: (v) => v == null ? 'Selecione o fornecedor' : null,
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(
                  _error!,
                  style: const TextStyle(color: _kRed, fontSize: 13),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: _saving ? null : _submit,
          child: _saving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text('Salvar'),
        ),
      ],
    );
  }
}
//parte 3
// ---------------------------------------------------------------------------
// Páginas
// ---------------------------------------------------------------------------

class DashboardPage extends StatelessWidget {
  const DashboardPage({
    super.key,
    required this.produtos,
    required this.estoque,
    required this.lotes,
    required this.loading,
    required this.lotesLoading,
    required this.error,
    required this.onRefresh,
    required this.onAdd,
    required this.onLogout,
  });

  final List<Produto> produtos;
  final List<EstoqueResumo> estoque;
  final List<LoteInfo> lotes;
  final bool loading;
  final bool lotesLoading;
  final String? error;
  final Future<void> Function() onRefresh;
  final VoidCallback onAdd;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final alerts = estoque.where((e) => e.abaixoDoMinimo).length;
    final expired = lotes.where((l) => l.vencido).length;
    final upcoming = lotes
        .where((l) => l.dias != null && l.dias! >= 0)
        .map((l) => l.dias!)
        .toList();
    final closest = upcoming.isEmpty
        ? null
        : upcoming.reduce((a, b) => a < b ? a : b);

    final metrics = [
      _MetricCard(
        title: 'Produtos',
        value: '${produtos.length}',
        subtitle: 'ativos no catálogo',
        color: _kGreen,
      ),
      _MetricCard(
        title: 'Vencidos',
        value: lotesLoading ? '...' : '$expired',
        subtitle: 'lotes vencidos',
        color: _kRed,
      ),
      _MetricCard(
        title: 'Validade',
        value: lotesLoading
            ? '...'
            : closest == null
            ? '—'
            : '$closest dias',
        subtitle: 'prazo mais próximo',
        color: const Color(0xFF3B82F6),
      ),
      _MetricCard(
        title: 'Alerta',
        value: '$alerts',
        subtitle: 'abaixo do mínimo',
        color: _kAmber,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('ValiTrack'),
        actions: [
          IconButton(
            onPressed: loading ? null : () => onRefresh(),
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Atualizar',
          ),
          IconButton(
            onPressed: onLogout,
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Sair',
          ),
        ],
      ),
      body: SafeArea(
        child: _PageBody(
          loading: loading,
          error: error,
          hasData: produtos.isNotEmpty,
          onRefresh: onRefresh,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF123C3A), _kGreen],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Olá, gestor',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Controle de estoque em tempo real',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Acompanhe validade, alertas e produtos em um único painel.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _Pill(
                        label: alerts == 0
                            ? 'Estoque saudável'
                            : '$alerts item(ns) abaixo do mínimo',
                      ),
                      _Pill(label: '${lotes.length} lote(s) com saldo'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'Resumo operacional',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: _kDark,
              ),
            ),
            const SizedBox(height: 14),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.9,
              children: metrics,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        onPressed: onAdd,
        backgroundColor: _kGreen,
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}

class ProdutosPage extends StatelessWidget {
  const ProdutosPage({
    super.key,
    required this.produtos,
    required this.estoqueById,
    required this.loading,
    required this.error,
    required this.onRefresh,
    required this.onAdd,
    required this.onDelete,
    required this.onAddLote,
  });

  final List<Produto> produtos;
  final Map<int, EstoqueResumo> estoqueById;
  final bool loading;
  final String? error;
  final Future<void> Function() onRefresh;
  final VoidCallback onAdd;
  final Future<void> Function(Produto produto) onDelete;
  final void Function(Produto produto) onAddLote;

  Future<void> _confirmDelete(BuildContext context, Produto produto) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Excluir produto'),
          content: Text('Deseja excluir "${produto.nome}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: _kRed),
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await onDelete(produto);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Produtos')),
      body: _PageBody(
        loading: loading,
        error: error,
        hasData: produtos.isNotEmpty,
        onRefresh: onRefresh,
        children: [
          const Text(
            'Catálogo de produtos',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: _kDark,
            ),
          ),
          const SizedBox(height: 16),
          if (produtos.isEmpty)
            const _EmptyMessage('Nenhum produto cadastrado.')
          else
            ...produtos.map((produto) {
              final resumo = estoqueById[produto.id];
              final categoria =
                  produto.categoria?.nome ?? resumo?.categoria ?? '';
              final below = resumo?.abaixoDoMinimo ?? false;

              return _ProductCard(
                name: produto.nome,
                subtitle: categoria.isEmpty
                    ? produto.codigoBarras
                    : '$categoria • ${produto.codigoBarras}',
                manufacturer:
                    '${produto.fabricante} • ${produto.unidadeMedida}',
                stock: resumo?.estoqueDisponivel ?? 0,
                minimum: produto.estoqueMinimo,
                status: below ? 'Baixo' : 'Normal',
                onDelete: () => _confirmDelete(context, produto),
                onAddLote: () => onAddLote(produto),
              );
            }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        onPressed: onAdd,
        backgroundColor: _kGreen,
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}

class EstoquePage extends StatelessWidget {
  const EstoquePage({
    super.key,
    required this.estoque,
    required this.loading,
    required this.error,
    required this.onRefresh,
  });

  final List<EstoqueResumo> estoque;
  final bool loading;
  final String? error;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Estoque')),
      body: _PageBody(
        loading: loading,
        error: error,
        hasData: estoque.isNotEmpty,
        onRefresh: onRefresh,
        children: [
          const Text(
            'Controle de estoque e alertas',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: _kDark,
            ),
          ),
          const SizedBox(height: 16),
          if (estoque.isEmpty)
            const _EmptyMessage('Nenhum item em estoque.')
          else
            ...estoque.map(
              (item) => _StockCard(
                name: item.nome,
                category: item.categoria,
                available: item.estoqueDisponivel,
                minimum: item.estoqueMinimo,
                status: item.abaixoDoMinimo ? 'Baixo' : 'Normal',
                note: item.abaixoDoMinimo
                    ? 'Atenção: estoque abaixo do mínimo'
                    : 'Disponível',
              ),
            ),
        ],
      ),
    );
  }
}

class ValidadePage extends StatelessWidget {
  const ValidadePage({
    super.key,
    required this.lotes,
    required this.hasProducts,
    required this.loading,
    required this.lotesLoading,
    required this.error,
    required this.onRefresh,
  });

  final List<LoteInfo> lotes;
  final bool hasProducts;
  final bool loading;
  final bool lotesLoading;
  final String? error;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Validade')),
      body: _PageBody(
        loading: loading,
        error: error,
        hasData: hasProducts,
        onRefresh: onRefresh,
        children: [
          const Text(
            'Prazo de validade',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: _kDark,
            ),
          ),
          const SizedBox(height: 16),
          if (lotesLoading && lotes.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (lotes.isEmpty)
            const _EmptyMessage('Nenhum lote com saldo disponível.')
          else
            ...lotes.map((info) => _ValidadeCard(info: info)),
        ],
      ),
    );
  }
}
//parte 4
// ---------------------------------------------------------------------------
// Componentes de apoio
// ---------------------------------------------------------------------------

/// Corpo padrão das páginas: carregando, erro, ou lista com puxar-para-atualizar.
class _PageBody extends StatelessWidget {
  const _PageBody({
    required this.loading,
    required this.error,
    required this.hasData,
    required this.onRefresh,
    required this.children,
  });

  final bool loading;
  final String? error;
  final bool hasData;
  final Future<void> Function() onRefresh;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final message = error;

    if (loading && !hasData) {
      return const Center(child: CircularProgressIndicator());
    }

    if (message != null && !hasData) {
      return _ErrorView(message: message, onRetry: () => onRefresh());
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        children: [
          if (message != null) _ErrorBanner(message: message),
          ...children,
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_rounded, size: 56, color: _kMuted),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, color: _kDark),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onRetry,
              style: FilledButton.styleFrom(backgroundColor: _kGreen),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _kRed.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded, color: _kRed, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(fontSize: 13, color: _kRed),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyMessage extends StatelessWidget {
  const _EmptyMessage(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Center(
        child: Text(text, style: const TextStyle(fontSize: 14, color: _kMuted)),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;

  const _Pill({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final Color color;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.trending_up_rounded, color: color),
          ),
          const SizedBox(height: 18),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: _kDark,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF253C49),
            ),
          ),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(fontSize: 12, color: _kMuted)),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final String name;
  final String subtitle;
  final String manufacturer;
  final int stock;
  final int minimum;
  final String status;
  final VoidCallback onDelete;
  final VoidCallback onAddLote;

  const _ProductCard({
    required this.name,
    required this.subtitle,
    required this.manufacturer,
    required this.stock,
    required this.minimum,
    required this.status,
    required this.onDelete,
    required this.onAddLote,
  });

  @override
  Widget build(BuildContext context) {
    final color = status == 'Baixo' ? _kAmber : _kGreen;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(Icons.inventory_2_rounded, color: color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: _kDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: _kMuted),
                ),
                const SizedBox(height: 2),
                Text(
                  manufacturer,
                  style: const TextStyle(fontSize: 12, color: _kMuted),
                ),
                const SizedBox(height: 8),
                Text(
                  'Disponível: $stock • Mínimo: $minimum',
                  style: const TextStyle(fontSize: 12, color: _kMuted),
                ),
                const SizedBox(height: 4),
                TextButton.icon(
                  onPressed: onAddLote,
                  style: TextButton.styleFrom(
                    foregroundColor: _kGreen,
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 32),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  icon: const Icon(Icons.add_box_outlined, size: 18),
                  label: const Text(
                    'Adicionar lote',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              IconButton(
                onPressed: onDelete,
                tooltip: 'Excluir',
                icon: const Icon(Icons.delete_outline_rounded, color: _kRed),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StockCard extends StatelessWidget {
  final String name;
  final String category;
  final int available;
  final int minimum;
  final String status;
  final String note;

  const _StockCard({
    required this.name,
    required this.category,
    required this.available,
    required this.minimum,
    required this.status,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    final color = status == 'Baixo' ? _kAmber : _kGreen;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.storage_rounded, color: color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: _kDark,
                  ),
                ),
                if (category.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    category,
                    style: const TextStyle(fontSize: 12, color: _kMuted),
                  ),
                ],
                const SizedBox(height: 4),
                Text(
                  'Disponível: $available • Mínimo: $minimum',
                  style: const TextStyle(fontSize: 12, color: _kMuted),
                ),
                const SizedBox(height: 4),
                Text(
                  note,
                  style: const TextStyle(fontSize: 12, color: _kMuted),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ValidadeCard extends StatelessWidget {
  final LoteInfo info;

  const _ValidadeCard({required this.info});

  @override
  Widget build(BuildContext context) {
    final dias = info.dias;

    final color = dias == null
        ? _kMuted
        : dias <= 15
        ? _kRed
        : dias <= 45
        ? _kAmber
        : _kGreen;

    final chip = dias == null
        ? (info.lote.textoValidade.isEmpty ? '—' : info.lote.textoValidade)
        : dias < 0
        ? 'Vencido'
        : dias == 0
        ? 'Vence hoje'
        : '$dias dias';

    final data = info.data;
    final dateText = data != null
        ? _formatDate(data)
        : info.lote.dataValidade.isEmpty
        ? '—'
        : info.lote.dataValidade;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.calendar_today_rounded, color: color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  info.produtoNome,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: _kDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Lote ${info.lote.numeroLote} • ${info.lote.saldoDisponivel} un.',
                  style: const TextStyle(fontSize: 12, color: _kMuted),
                ),
                const SizedBox(height: 2),
                Text(
                  'Validade: $dateText',
                  style: const TextStyle(fontSize: 12, color: _kMuted),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              chip,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
