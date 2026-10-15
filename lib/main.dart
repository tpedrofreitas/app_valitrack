import 'package:flutter/material.dart';

void main() {
  runApp(const ValiStockApp());
}

class ValiStockApp extends StatelessWidget {
  const ValiStockApp({super.key});

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
      home: const AppShell(),
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
  });

  final String name;
  final String code;
  final String category;
  int stock;
  final int minimum;

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
    ),
    Product(
      name: 'Limpeza Multiuso',
      code: 'LM-205',
      category: 'Limpeza',
      stock: 42,
      minimum: 60,
    ),
    Product(
      name: 'Óleo Lubrificante',
      code: 'OL-330',
      category: 'Manutenção',
      stock: 96,
      minimum: 30,
    ),
    Product(
      name: 'Sacos de areia',
      code: 'SA-080',
      category: 'Construção',
      stock: 300,
      minimum: 90,
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
    EntradasPage(
      movements: _movements.where((m) => m.type == MovementType.entry).toList(),
      onAdd: _showAddEntryDialog,
    ),
    SaidasPage(
      movements: _movements.where((m) => m.type == MovementType.exit).toList(),
      onAdd: _showAddExitDialog,
    ),
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

  void _registerEntry(
    String productName,
    int quantity,
    String supplier,
    String lot,
  ) {
    final product = _products.firstWhere(
      (p) => p.name == productName,
      orElse: () => throw StateError('Produto não encontrado'),
    );

    setState(() {
      product.stock += quantity;
      _movements.add(
        InventoryMovement(
          type: MovementType.entry,
          productName: product.name,
          quantity: quantity,
          reason: 'Entrada de estoque',
          date: DateTime.now(),
          supplier: supplier,
          lot: lot,
        ),
      );
    });
    _showSnack('Entrada registrada com sucesso');
  }

  void _registerExit(String productName, int quantity, String reason) {
    final product = _products.firstWhere(
      (p) => p.name == productName,
      orElse: () => throw StateError('Produto não encontrado'),
    );

    if (quantity > product.stock) {
      _showSnack('Quantidade maior que o estoque disponível');
      return;
    }

    setState(() {
      product.stock -= quantity;
      _movements.add(
        InventoryMovement(
          type: MovementType.exit,
          productName: product.name,
          quantity: quantity,
          reason: reason,
          date: DateTime.now(),
        ),
      );
    });
    _showSnack('Saída registrada com sucesso');
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

  Future<void> _showAddEntryDialog() async {
    if (_products.isEmpty) {
      _showSnack('Cadastre um produto antes de registrar uma entrada');
      return;
    }

    String selectedProduct = _products.first.name;
    final quantityController = TextEditingController(text: '1');
    final supplierController = TextEditingController();
    final lotController = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Registrar entrada'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: selectedProduct,
                  decoration: const InputDecoration(labelText: 'Produto'),
                  items: _products
                      .map(
                        (product) => DropdownMenuItem(
                          value: product.name,
                          child: Text(product.name),
                        ),
                      )
                      .toList(),
                  onChanged: (value) =>
                      selectedProduct = value ?? selectedProduct,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Quantidade'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: supplierController,
                  decoration: const InputDecoration(labelText: 'Fornecedor'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: lotController,
                  decoration: const InputDecoration(labelText: 'Lote'),
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
                final quantity = int.tryParse(quantityController.text) ?? 0;
                if (quantity <= 0) {
                  _showSnack('Informe uma quantidade válida');
                  return;
                }

                _registerEntry(
                  selectedProduct,
                  quantity,
                  supplierController.text.trim(),
                  lotController.text.trim(),
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

  Future<void> _showAddExitDialog() async {
    if (_products.isEmpty) {
      _showSnack('Cadastre um produto antes de registrar uma saída');
      return;
    }

    String selectedProduct = _products.first.name;
    final quantityController = TextEditingController(text: '1');
    final reasonController = TextEditingController(text: 'Venda');

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Registrar saída'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: selectedProduct,
                  decoration: const InputDecoration(labelText: 'Produto'),
                  items: _products
                      .map(
                        (product) => DropdownMenuItem(
                          value: product.name,
                          child: Text(product.name),
                        ),
                      )
                      .toList(),
                  onChanged: (value) =>
                      selectedProduct = value ?? selectedProduct,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Quantidade'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: reasonController,
                  decoration: const InputDecoration(labelText: 'Motivo'),
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
                final quantity = int.tryParse(quantityController.text) ?? 0;
                if (quantity <= 0) {
                  _showSnack('Informe uma quantidade válida');
                  return;
                }

                _registerExit(
                  selectedProduct,
                  quantity,
                  reasonController.text.trim().isEmpty
                      ? 'Movimentação'
                      : reasonController.text.trim(),
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
          title: const Text('Nova movimentação'),
          content: const Text('Escolha o tipo de ação que deseja registrar.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _showAddProductDialog();
              },
              child: const Text('Produto'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _showAddEntryDialog();
              },
              child: const Text('Entrada'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _showAddExitDialog();
              },
              child: const Text('Saída'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            icon: Icon(Icons.input_outlined),
            selectedIcon: Icon(Icons.input_rounded),
            label: 'Entradas',
          ),
          NavigationDestination(
            icon: Icon(Icons.output_outlined),
            selectedIcon: Icon(Icons.output_rounded),
            label: 'Saídas',
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
    final totalStock = products.fold<int>(0, (sum, p) => sum + p.stock);
    final alerts = products.where((p) => p.stock <= p.minimum).length;
    final recentMovements = movements.take(3).toList();

    final metrics = [
      _MetricCard(
        title: 'Produtos',
        value: '$totalProducts',
        subtitle: 'ativos no catálogo',
        color: const Color(0xFF1E8E76),
      ),
      _MetricCard(
        title: 'Estoque',
        value: '$totalStock',
        subtitle: 'unidades disponíveis',
        color: const Color(0xFF3B82F6),
      ),
      _MetricCard(
        title: 'Alertas',
        value: '$alerts',
        subtitle: 'itens em atenção',
        color: const Color(0xFFF59E0B),
      ),
      _MetricCard(
        title: 'Movimentos',
        value: '${movements.length}',
        subtitle: 'registros ativos',
        color: const Color(0xFFEF4444),
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
                    'Acompanhe entradas, saídas, validade e alertas em um único painel.',
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
            const SizedBox(height: 24),
            const Text(
              'Movimentações recentes',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF172A35),
              ),
            ),
            const SizedBox(height: 12),
            ...recentMovements.map((movement) {
              final icon = movement.type == MovementType.entry
                  ? Icons.input_rounded
                  : Icons.output_rounded;
              final tint = movement.type == MovementType.entry
                  ? const Color(0xFF1E8E76)
                  : const Color(0xFF3B82F6);
              final prefix = movement.type == MovementType.entry ? '+' : '-';

              return _MovementTile(
                title: movement.type == MovementType.entry
                    ? 'Entrada de ${movement.productName}'
                    : 'Saída de ${movement.productName}',
                subtitle:
                    '${movement.reason} • ${movement.quantity} unidades • ${_formatDate(movement.date)}',
                icon: icon,
                tint: tint,
                amount: '$prefix${movement.quantity}',
                onTap: () => _showInfo(
                  context,
                  movement.type == MovementType.entry
                      ? 'Entrada registrada'
                      : 'Saída registrada',
                ),
              );
            }),
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

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
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

class EntradasPage extends StatelessWidget {
  const EntradasPage({super.key, required this.movements, required this.onAdd});

  final List<InventoryMovement> movements;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Entradas')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Entradas por lote',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Color(0xFF172A35),
            ),
          ),
          const SizedBox(height: 16),
          ...movements.map(
            (entry) => _EntryItem(
              product: entry.productName,
              supplier: entry.supplier ?? 'Fornecedor',
              quantity: entry.quantity,
              lot: entry.lot ?? 'N/D',
              date: _formatDate(entry.date),
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

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}

class SaidasPage extends StatelessWidget {
  const SaidasPage({super.key, required this.movements, required this.onAdd});

  final List<InventoryMovement> movements;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saídas')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Baixas e movimentações',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Color(0xFF172A35),
            ),
          ),
          const SizedBox(height: 16),
          ...movements.map(
            (item) => _ExitItem(
              product: item.productName,
              quantity: item.quantity,
              reason: item.reason,
              date: _formatDate(item.date),
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

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
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

class _MovementTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color tint;
  final String amount;
  final VoidCallback onTap;

  const _MovementTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.tint,
    required this.amount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: tint.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: tint),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF172A35),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF60717B),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                amount,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: tint,
                ),
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

class _EntryItem extends StatelessWidget {
  final String product;
  final String supplier;
  final int quantity;
  final String lot;
  final String date;

  const _EntryItem({
    required this.product,
    required this.supplier,
    required this.quantity,
    required this.lot,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
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
              color: const Color(0xFFE9F8F4),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.input_rounded, color: Color(0xFF1E8E76)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF172A35),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$supplier • Lote $lot',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF60717B),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '+$quantity',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E8E76),
                ),
              ),
              Text(
                date,
                style: const TextStyle(fontSize: 11, color: Color(0xFF60717B)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ExitItem extends StatelessWidget {
  final String product;
  final int quantity;
  final String reason;
  final String date;

  const _ExitItem({
    required this.product,
    required this.quantity,
    required this.reason,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
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
              color: const Color(0xFFEBF3FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.output_rounded, color: Color(0xFF3B82F6)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF172A35),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  reason,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF60717B),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '-$quantity',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF3B82F6),
                ),
              ),
              Text(
                date,
                style: const TextStyle(fontSize: 11, color: Color(0xFF60717B)),
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
