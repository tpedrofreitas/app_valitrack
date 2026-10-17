import 'package:flutter/material.dart';

void main() {
  runApp(const ValitrackApp());
}

class ValitrackApp extends StatelessWidget {
  const ValitrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ValiStock',
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
  final _userController = TextEditingController(text: 'admin');
  final _passwordController = TextEditingController(text: '123456');
  final _formKey = GlobalKey<FormState>();

  void _login() {
    final user = _userController.text.trim();
    final password = _passwordController.text.trim();

    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      return;
    }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F9),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF1E8E76,
                              ).withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(
                              Icons.lock_outline_rounded,
                              size: 36,
                              color: Color(0xFF1E8E76),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'ValiStock',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF172A35),
                            ),
                          ),
                        ],
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
                      decoration: const InputDecoration(
                        hintText: 'Digite seu usuário',
                        prefixIcon: Icon(Icons.person_outline_rounded),
                        border: OutlineInputBorder(),
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
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _login(),
                      decoration: const InputDecoration(
                        hintText: 'Digite sua senha',
                        prefixIcon: Icon(Icons.lock_outline_rounded),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Informe a senha';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () => _login(),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: const Color(0xFF1E8E76),
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
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Product {
  Product({
    required this.name,
    required this.code,
    required this.category,
    required this.stock,
    required this.minimum,
    required this.validityDays,
  });

  final String name;
  final String code;
  final String category;
  int stock;
  final int minimum;
  final int validityDays;

  String get status {
    if (stock <= minimum) {
      return 'Baixo';
    }
    return 'Normal';
  }
}

enum MovementType { entry, exit }

class InventoryMovement {
  InventoryMovement({
    required this.type,
    required this.productName,
    required this.quantity,
    required this.reason,
    required this.date,
    this.supplier,
    this.lot,
  });

  final MovementType type;
  final String productName;
  final int quantity;
  final String reason;
  final DateTime date;
  final String? supplier;
  final String? lot;
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;

  final List<Product> _products = [
    Product(
      name: 'Ração Premium',
      code: 'RP-101',
      category: 'Pet',
      stock: 180,
      minimum: 50,
      validityDays: 36,
    ),
    Product(
      name: 'Limpeza Multiuso',
      code: 'LM-205',
      category: 'Limpeza',
      stock: 42,
      minimum: 60,
      validityDays: 12,
    ),
    Product(
      name: 'Óleo Lubrificante',
      code: 'OL-330',
      category: 'Manutenção',
      stock: 96,
      minimum: 30,
      validityDays: 58,
    ),
    Product(
      name: 'Sacos de areia',
      code: 'SA-080',
      category: 'Construção',
      stock: 300,
      minimum: 90,
      validityDays: 90,
    ),
  ];

  final List<InventoryMovement> _movements = [
    InventoryMovement(
      type: MovementType.entry,
      productName: 'Ração Premium',
      quantity: 120,
      reason: 'Compra de fornecedor',
      date: DateTime(2026, 10, 14),
      supplier: 'PetMarket Ltda',
      lot: 'RP-204',
    ),
    InventoryMovement(
      type: MovementType.exit,
      productName: 'Ração Premium',
      quantity: 28,
      reason: 'Venda',
      date: DateTime(2026, 10, 14),
    ),
    InventoryMovement(
      type: MovementType.entry,
      productName: 'Óleo Lubrificante',
      quantity: 80,
      reason: 'Reabastecimento',
      date: DateTime(2026, 10, 12),
      supplier: 'AutoMax',
      lot: 'OL-112',
    ),
  ];

  List<Widget> get _pages => [
    DashboardPage(
      products: _products,
      movements: _movements,
      onAdd: _showQuickAddDialog,
    ),
    ProdutosPage(
      products: _products,
      onAdd: _showAddProductDialog,
      onDelete: _deleteProduct,
    ),
    ValidadePage(products: _products),
    EstoquePage(products: _products),
  ];

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _addProduct(Product product) {
    setState(() {
      _products.add(product);
    });
    _showSnack('Produto cadastrado com sucesso');
  }

  void _deleteProduct(String productName) {
    final index = _products.indexWhere((p) => p.name == productName);
    if (index == -1) return;

    setState(() {
      _products.removeAt(index);
    });
    _showSnack('Produto removido');
  }

  Future<void> _showAddProductDialog() async {
    final nameController = TextEditingController();
    final codeController = TextEditingController();
    final categoryController = TextEditingController();
    final stockController = TextEditingController(text: '0');
    final minimumController = TextEditingController(text: '0');
    final validityController = TextEditingController(text: '30');

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Cadastrar produto'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nome do produto',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: codeController,
                  decoration: const InputDecoration(labelText: 'Código'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: categoryController,
                  decoration: const InputDecoration(labelText: 'Categoria'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: stockController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Quantidade inicial',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: minimumController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Estoque mínimo',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: validityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Prazo de validade (dias)',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                final name = nameController.text.trim();
                final code = codeController.text.trim();
                final category = categoryController.text.trim();
                final stock = int.tryParse(stockController.text) ?? 0;
                final minimum = int.tryParse(minimumController.text) ?? 0;
                final validityDays =
                    int.tryParse(validityController.text) ?? 30;

                if (name.isEmpty || code.isEmpty || category.isEmpty) {
                  _showSnack('Preencha todos os campos obrigatórios');
                  return;
                }

                _addProduct(
                  Product(
                    name: name,
                    code: code,
                    category: category,
                    stock: stock,
                    minimum: minimum,
                    validityDays: validityDays,
                  ),
                );
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showQuickAddDialog() async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Nova ação'),
          content: const Text('Escolha a ação que deseja registrar.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _showAddProductDialog();
              },
              child: const Text('Produto'),
            ),
          ],
        );
      },
    );
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('ValiStock'),
        actions: [
          IconButton(
            onPressed: _showLogoutDialog,
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Sair',
          ),
        ],
      ),
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFF1E8E76).withValues(alpha: 0.12),
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

class DashboardPage extends StatelessWidget {
  const DashboardPage({
    super.key,
    required this.products,
    required this.movements,
    required this.onAdd,
  });

  final List<Product> products;
  final List<InventoryMovement> movements;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final totalProducts = products.length;
    final alerts = products.where((p) => p.stock <= p.minimum).length;
    final expiredProducts = products.where((p) => p.stock == 0).length;
    final closestValidity = products.isEmpty
        ? 0
        : products.map((p) => p.validityDays).reduce((a, b) => a < b ? a : b);

    final metrics = [
      _MetricCard(
        title: 'Produtos',
        value: '$totalProducts',
        subtitle: 'ativos no catálogo',
        color: const Color(0xFF1E8E76),
      ),
      _MetricCard(
        title: 'Vencidos',
        value: '$expiredProducts',
        subtitle: 'itens sem estoque',
        color: const Color(0xFFEF4444),
      ),
      _MetricCard(
        title: 'Validade',
        value: '$closestValidity dias',
        subtitle: 'prazo mais próximo',
        color: const Color(0xFF3B82F6),
      ),
      _MetricCard(
        title: 'Alerta',
        value: '$alerts',
        subtitle: 'itens em atenção',
        color: const Color(0xFFF59E0B),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('ValiStock'),
        actions: [
          IconButton(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Você tem 3 notificações novas')),
            ),
            icon: const Icon(Icons.notifications_none_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF123C3A), Color(0xFF1E8E76)],
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
                        label: 'Estoque saudável',
                        onTap: () => _showInfo(context, 'Estoque saudável'),
                      ),
                      _Pill(
                        label: 'Alertas ativos',
                        onTap: () => _showInfo(context, 'Alertas ativos'),
                      ),
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
                color: Color(0xFF172A35),
              ),
            ),
            const SizedBox(height: 14),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: metrics,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onAdd,
        backgroundColor: const Color(0xFF1E8E76),
        child: const Icon(Icons.add_rounded),
      ),
    );
  }

  void _showInfo(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
}

class ProdutosPage extends StatelessWidget {
  const ProdutosPage({
    super.key,
    required this.products,
    required this.onAdd,
    required this.onDelete,
  });

  final List<Product> products;
  final VoidCallback onAdd;
  final ValueChanged<String> onDelete;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Produtos')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Catálogo de produtos',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Color(0xFF172A35),
            ),
          ),
          const SizedBox(height: 16),
          ...products.map(
            (product) => _ProductCard(
              name: product.name,
              code: product.code,
              category: product.category,
              stock: product.stock,
              minimum: product.minimum,
              status: product.status,
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Produto ${product.name} selecionado')),
              ),
              onDelete: () => onDelete(product.name),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onAdd,
        backgroundColor: const Color(0xFF1E8E76),
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}

class EstoquePage extends StatelessWidget {
  const EstoquePage({super.key, required this.products});

  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Estoque')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Controle de estoque e alertas',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Color(0xFF172A35),
            ),
          ),
          const SizedBox(height: 16),
          ...products.map(
            (product) => _StockCard(
              name: product.name,
              available: product.stock,
              minimum: product.minimum,
              status: product.status,
              validity: product.stock <= product.minimum
                  ? 'Atenção: estoque baixo'
                  : 'Disponível',
            ),
          ),
        ],
      ),
    );
  }
}

class ValidadePage extends StatelessWidget {
  const ValidadePage({super.key, required this.products});

  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Validade')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Prazo de validade',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Color(0xFF172A35),
            ),
          ),
          const SizedBox(height: 16),
          ...products.map(
            (product) => _ValidadeCard(
              name: product.name,
              days: product.validityDays,
              stock: product.stock,
            ),
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const _Pill({required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap ?? () {},
      child: Container(
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$title: $value'))),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
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
              Text(
                value,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF172A35),
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
              Text(
                subtitle,
                style: const TextStyle(fontSize: 12, color: Color(0xFF60717B)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final String name;
  final String code;
  final String category;
  final int stock;
  final int minimum;
  final String status;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _ProductCard({
    required this.name,
    required this.code,
    required this.category,
    required this.stock,
    required this.minimum,
    required this.status,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final color = status == 'Baixo'
        ? const Color(0xFFF59E0B)
        : const Color(0xFF1E8E76);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
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
                        color: Color(0xFF172A35),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$category • $code',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF60717B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Disponível: $stock • Mínimo: $minimum',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF60717B),
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
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      color: Color(0xFFEF4444),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StockCard extends StatelessWidget {
  final String name;
  final int available;
  final int minimum;
  final String status;
  final String validity;

  const _StockCard({
    required this.name,
    required this.available,
    required this.minimum,
    required this.status,
    required this.validity,
  });

  @override
  Widget build(BuildContext context) {
    final color = status == 'Baixo'
        ? const Color(0xFFF59E0B)
        : const Color(0xFF1E8E76);

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
                    color: Color(0xFF172A35),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Disponível: $available • Mínimo: $minimum',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF60717B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  validity,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF60717B),
                  ),
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
  final String name;
  final int days;
  final int stock;

  const _ValidadeCard({
    required this.name,
    required this.days,
    required this.stock,
  });

  @override
  Widget build(BuildContext context) {
    final color = days <= 15
        ? const Color(0xFFEF4444)
        : days <= 45
        ? const Color(0xFFF59E0B)
        : const Color(0xFF1E8E76);

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
                  name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF172A35),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Estoque: $stock unidades',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF60717B),
                  ),
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
              '$days dias',
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
