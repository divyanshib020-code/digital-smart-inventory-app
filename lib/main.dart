// lib/main.dart
import 'package:flutter/material.dart';

void main() {
  runApp(const InventoryApp());
}

// ---------------- New Color Theme (from your sample)
const Color kBg = Color(0xFFF5F7F9); // neutral light background
const Color kPrimary = Color(0xFF2B8CCA); // medium Blue (primary)
const Color kAccent = Color(0xFF2AA9A9); // Teal (accent)
const Color kAction = Color(0xFFF39C12); // Orange (buttons / highlights)
const Color kYellow = Color(0xFFF7C948); // Golden yellow (sparingly)
const Color kText = Color(0xFF33363A); // dark gray text
const Color kCard = Color(0xFFEAF4FB); // pale card background
const Color kError = Color(0xFFE74C3C); // red for errors / badges

// small responsive helper
const double kFormWidthMin = 320;
const double kFormWidthMax = 760;
double formWidth(BuildContext context) {
  final w = MediaQuery.of(context).size.width * 0.86;
  if (w < kFormWidthMin) return kFormWidthMin;
  if (w > kFormWidthMax) return kFormWidthMax;
  return w;
}

// ---------------- App
class InventoryApp extends StatelessWidget {
  const InventoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData(
      scaffoldBackgroundColor: kBg,
      colorScheme: ColorScheme.fromSeed(seedColor: kPrimary, primary: kPrimary, secondary: kAccent),
      primaryColor: kPrimary,
      appBarTheme: const AppBarTheme(
        backgroundColor: kPrimary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: kCard,
        hintStyle: TextStyle(color: kText.withOpacity(0.65)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: kAction,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: kAction),
      ),
      textTheme: TextTheme(bodyMedium: TextStyle(color: kText)),
    );

    return MaterialApp(
      title: 'Inventory Optimization',
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: const LoginScreen(),
    );
  }
}

// small helper to render logo with errorBuilder (use asset path you already set)
// default size increased so logo appears larger across screens
Widget smallLogo({double size = 56}) {
  return SizedBox(
    width: size,
    height: size,
    child: Image.asset(
      'assets/images/logo.png',
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        // graceful fallback so the UI still shows something recognizable
        return Container(
          decoration: BoxDecoration(
            color: kCard,
            borderRadius: BorderRadius.circular(size / 8),
          ),
          child: Icon(Icons.inventory_2_rounded, color: kPrimary, size: size * 0.6),
        );
      },
    ),
  );
}

// ---------- LOGIN SCREEN ----------
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscure = true;
  String email = '', password = '';

  @override
  Widget build(BuildContext context) {
    final width = formWidth(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 6),
                // login screen uses larger image explicitly (kept large)
                SizedBox(
                  width: 140,
                  height: 140,
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.contain,
                    errorBuilder: (c, e, s) => Container(
                      decoration: BoxDecoration(color: kCard, shape: BoxShape.circle),
                      child: Icon(Icons.inventory_2_rounded, color: kPrimary, size: 64),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'INVENTORY OPTIMIZATION',
                  style: TextStyle(color: kText, fontSize: 22, fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                Container(
                  width: width,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(color: kCard, borderRadius: BorderRadius.circular(14)),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Email (mandatory)
                        _labelWithStar('Email'),
                        const SizedBox(height: 6),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(hintText: 'Enter your email'),
                          onSaved: (v) => email = v?.trim() ?? '',
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return 'Enter email';
                            if (!v.contains('@')) return 'Enter valid email';
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),

                        // Password (mandatory)
                        _labelWithStar('Password'),
                        const SizedBox(height: 6),
                        TextFormField(
                          obscureText: _obscure,
                          decoration: InputDecoration(
                            hintText: 'Enter password',
                            suffixIcon: IconButton(
                              icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility, color: kText.withOpacity(0.7)),
                              onPressed: () => setState(() => _obscure = !_obscure),
                            ),
                          ),
                          onSaved: (v) => password = v ?? '',
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return 'Enter password';
                            if (v.length < 6) return 'Minimum 6 chars';
                            return null;
                          },
                        ),
                        const SizedBox(height: 8),

                        // forgot
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ResetPasswordScreen())),
                            child: const Text('Forgot password?'),
                          ),
                        ),
                        const SizedBox(height: 6),

                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              final f = _formKey.currentState!;
                              if (f.validate()) {
                                f.save();
                                // demo login -> dashboard
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DashboardScreen()));
                              }
                            },
                            child: const Text('Login', style: TextStyle(fontSize: 16)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text("Don't have an account? ", style: TextStyle(color: kText)),
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SignUpScreen())),
                    child: Text('Sign up', style: TextStyle(color: kAction, fontWeight: FontWeight.w700)),
                  ),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// small helper to show label + required star
Widget _labelWithStar(String label) {
  return Row(
    children: [
      Text(label, style: TextStyle(color: kText.withOpacity(0.9), fontWeight: FontWeight.w600)),
      const SizedBox(width: 6),
      Text('*', style: TextStyle(color: kError, fontWeight: FontWeight.bold)),
    ],
  );
}

// ---------- SIGN UP ----------
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '', email = '', password = '';
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final width = formWidth(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimary,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            smallLogo(size: 48),
            const SizedBox(width: 10),
            const Text('Sign Up'),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 20),
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 8),
                Text('Create Account', style: TextStyle(color: kText, fontSize: 22, fontWeight: FontWeight.w700)),
                const SizedBox(height: 18),
                Container(
                  width: width,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: kCard, borderRadius: BorderRadius.circular(12)),
                  child: Form(
                    key: _formKey,
                    child: Column(children: [
                      _labelWithStar('Full Name'),
                      const SizedBox(height: 6),
                      TextFormField(
                        decoration: const InputDecoration(hintText: 'Your full name'),
                        onSaved: (v) => name = v ?? '',
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter full name' : null,
                      ),
                      const SizedBox(height: 12),
                      _labelWithStar('Email'),
                      const SizedBox(height: 6),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(hintText: 'Your email'),
                        onSaved: (v) => email = v ?? '',
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Enter email';
                          if (!v.contains('@')) return 'Enter valid email';
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      _labelWithStar('Password'),
                      const SizedBox(height: 6),
                      TextFormField(
                        obscureText: _obscure,
                        decoration: InputDecoration(
                          hintText: 'Choose a password',
                          suffixIcon: IconButton(icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility, color: kText.withOpacity(0.7)), onPressed: () => setState(() => _obscure = !_obscure)),
                        ),
                        onSaved: (v) => password = v ?? '',
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Enter password';
                          if (v.length < 6) return 'Minimum 6 characters';
                          return null;
                        },
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _submit,
                          child: const Text('Sign Up'),
                        ),
                      ),
                    ]),
                  ),
                ),
                const SizedBox(height: 12),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text('Already have an account? ', style: TextStyle(color: kText)),
                  GestureDetector(onTap: () => Navigator.pop(context), child: Text('Login', style: TextStyle(color: kAction, fontWeight: FontWeight.w700)))
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submit() {
    final f = _formKey.currentState!;
    if (f.validate()) {
      f.save();
      // demo — sign in and go to dashboard
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DashboardScreen()));
    }
  }
}

// ---------- RESET PASSWORD ----------
class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});
  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final width = formWidth(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimary,
        title: Row(children: [smallLogo(size: 48), const SizedBox(width: 8), const Text('Reset Password')]),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Center(
            child: Column(children: [
              const SizedBox(height: 6),
              Text('Reset Password', style: TextStyle(color: kText, fontSize: 22, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              Container(
                width: width,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: kCard, borderRadius: BorderRadius.circular(12)),
                child: Form(
                  key: _formKey,
                  child: Column(children: [
                    Text('Enter your account email. We will send a reset link.', style: TextStyle(color: kText.withOpacity(0.9))),
                    const SizedBox(height: 10),
                    _labelWithStar('Email'),
                    const SizedBox(height: 6),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(hintText: 'Email'),
                      onSaved: (v) => email = v?.trim() ?? '',
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Please enter email';
                        if (!v.contains('@')) return 'Enter a valid email';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: ElevatedButton(
                        onPressed: _loading ? null : _sendReset,
                        child: _loading
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                            : const Text('Send Reset Link'),
                      ),
                    ),
                  ]),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  void _sendReset() async {
    final form = _formKey.currentState!;
    if (!form.validate()) return;
    form.save();
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _loading = false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('A reset link was sent to $email (demo).'), backgroundColor: kAction));
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) Navigator.pop(context);
  }
}

// ---------- Add / Update Product ----------
class AddUpdateProductScreen extends StatefulWidget {
  final Map<String, dynamic>? product;
  const AddUpdateProductScreen({this.product, super.key});

  @override
  State<AddUpdateProductScreen> createState() => _AddUpdateProductScreenState();
}

class _AddUpdateProductScreenState extends State<AddUpdateProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameC;
  late TextEditingController _skuC;
  late TextEditingController _qtyC;
  late TextEditingController _priceC;
  late TextEditingController _reorderC;
  late TextEditingController _descC;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _nameC = TextEditingController(text: p?['name'] ?? '');
    _skuC = TextEditingController(text: p?['sku'] ?? '');
    _qtyC = TextEditingController(text: p != null ? '${p['qty']}' : '');
    _priceC = TextEditingController(text: p != null ? '${p['price']}' : '');
    _reorderC = TextEditingController(text: p != null ? '${p['reorder'] ?? ''}' : '');
    _descC = TextEditingController(text: p?['desc'] ?? '');
  }

  @override
  void dispose() {
    _nameC.dispose();
    _skuC.dispose();
    _qtyC.dispose();
    _priceC.dispose();
    _reorderC.dispose();
    _descC.dispose();
    super.dispose();
  }

  void _saveProduct() async {
    final f = _formKey.currentState!;
    if (!f.validate()) return;
    f.save();
    setState(() => _loading = true);
    final product = <String, dynamic>{
      'name': _nameC.text.trim(),
      'sku': _skuC.text.trim(),
      'qty': int.tryParse(_qtyC.text.trim()) ?? 0,
      'price': (double.tryParse(_priceC.text.trim()) ?? 0).toDouble(),
      'reorder': int.tryParse(_reorderC.text.trim()) ?? 0,
      'desc': _descC.text.trim(),
    };
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() => _loading = false);
    if (mounted) Navigator.pop(context, product);
  }

  @override
  Widget build(BuildContext context) {
    final bool isEdit = widget.product != null;
    final width = formWidth(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimary,
        title: Row(children: [smallLogo(size: 48), const SizedBox(width: 8), Text(isEdit ? 'Update Product' : 'Add Product')]),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Container(
              width: width,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: kCard, borderRadius: BorderRadius.circular(12)),
              child: Form(
                key: _formKey,
                child: Column(children: [
                  _labelWithStar('Product Name'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _nameC,
                    decoration: const InputDecoration(hintText: 'Product Name'),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter product name' : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(controller: _skuC, decoration: const InputDecoration(hintText: 'SKU / Code (optional)')),
                  const SizedBox(height: 10),
                  Row(children: [
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        _labelWithStar('Quantity'),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _qtyC,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(hintText: 'Quantity'),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return 'Enter qty';
                            if (int.tryParse(v.trim()) == null) return 'Enter valid number';
                            return null;
                          },
                        ),
                      ]),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        _labelWithStar('Price'),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _priceC,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: const InputDecoration(hintText: 'Price (₹)'),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return 'Enter price';
                            if (double.tryParse(v.trim()) == null) return 'Enter valid price';
                            return null;
                          },
                        ),
                      ]),
                    ),
                  ]),
                  const SizedBox(height: 10),
                  TextFormField(controller: _reorderC, keyboardType: TextInputType.number, decoration: const InputDecoration(hintText: 'Reorder level (optional)')),
                  const SizedBox(height: 10),
                  TextFormField(controller: _descC, decoration: const InputDecoration(hintText: 'Description (optional)'), maxLines: 3),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(onPressed: _loading ? null : _saveProduct, child: _loading ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : Text(isEdit ? 'Update' : 'Add Product')),
                  ),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------- Inventory List Screen ----------
class InventoryListScreen extends StatefulWidget {
  final List<Map<String, dynamic>> products;
  final void Function(int index) onEdit;
  final void Function(int index) onDelete;

  const InventoryListScreen({required this.products, required this.onEdit, required this.onDelete, super.key});

  @override
  State<InventoryListScreen> createState() => _InventoryListScreenState();
}

class _InventoryListScreenState extends State<InventoryListScreen> {
  String _query = '';
  String _category = 'All';
  String _sortBy = 'None'; // 'qty' or 'price'
  bool _sortAsc = true;

  List<int> get _filteredIndices {
    final q = _query.trim().toLowerCase();
    final List<int> res = [];
    for (var i = 0; i < widget.products.length; i++) {
      final p = widget.products[i];
      final name = (p['name'] ?? '').toString().toLowerCase();
      final sku = (p['sku'] ?? '').toString().toLowerCase();
      final cat = (p['category'] ?? 'Unk').toString();
      if ((_category == 'All' || cat == _category) && (q.isEmpty || name.contains(q) || sku.contains(q))) {
        res.add(i);
      }
    }

    if (_sortBy == 'qty') {
      res.sort((a, b) {
        final av = (widget.products[a]['qty'] as num).toInt();
        final bv = (widget.products[b]['qty'] as num).toInt();
        return _sortAsc ? av.compareTo(bv) : bv.compareTo(av);
      });
    } else if (_sortBy == 'price') {
      res.sort((a, b) {
        final av = (widget.products[a]['price'] as num).toDouble();
        final bv = (widget.products[b]['price'] as num).toDouble();
        return _sortAsc ? av.compareTo(bv) : bv.compareTo(av);
      });
    }

    return res;
  }

  List<String> get _categories {
    final s = <String>{'All'};
    for (final p in widget.products) {
      final c = (p['category'] ?? 'Uncategorized').toString();
      s.add(c);
    }
    return s.toList();
  }

  @override
  Widget build(BuildContext context) {
    final width = formWidth(context);
    final indices = _filteredIndices;

    return Scaffold(
      appBar: AppBar(
        title: Row(children: [smallLogo(size: 48), const SizedBox(width: 8), const Text('Inventory List')]),
        backgroundColor: kPrimary,
      ),
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: width,
            child: Column(children: [
              const SizedBox(height: 12),
              Row(children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    onChanged: (v) => setState(() => _query = v),
                    decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search by name or SKU'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    value: _category,
                    items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                    onChanged: (v) => setState(() => _category = v ?? 'All'),
                    decoration: const InputDecoration(),
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              Row(children: [
                const Text('Sort:'),
                const SizedBox(width: 8),
                ChoiceChip(label: const Text('Qty'), selected: _sortBy == 'qty', onSelected: (s) => setState(() => _sortBy = s ? 'qty' : 'None'), selectedColor: kAction.withOpacity(0.14)),
                const SizedBox(width: 8),
                ChoiceChip(label: const Text('Price'), selected: _sortBy == 'price', onSelected: (s) => setState(() => _sortBy = s ? 'price' : 'None'), selectedColor: kAction.withOpacity(0.14)),
                const SizedBox(width: 12),
                IconButton(icon: Icon(_sortAsc ? Icons.arrow_upward : Icons.arrow_downward, color: kAction), onPressed: () => setState(() => _sortAsc = !_sortAsc)),
                const Spacer(),
                Text('${indices.length} items', style: TextStyle(color: kText)),
              ]),
              const SizedBox(height: 12),
              Expanded(
                child: indices.isEmpty
                    ? Center(child: Text('No items found', style: TextStyle(color: kText)))
                    : ListView.separated(
                        itemCount: indices.length,
                        separatorBuilder: (_, __) => const Divider(height: 8, color: Colors.transparent),
                        itemBuilder: (context, i) {
                          final idx = indices[i];
                          final p = widget.products[idx];
                          final qty = (p['qty'] ?? 0).toString();
                          final price = (p['price'] ?? 0).toString();
                          // new wording: Stock Full, Stock Low, Stock Over
                          final num qnum = p['qty'] ?? 0;
                          final bool isZero = (qnum as num) == 0;
                          final bool isLow = (qnum as num) > 0 && (qnum as num) <= 10;
                          final status = isZero ? 'Stock Over' : (isLow ? 'Stock Low' : 'Stock Full');
                          final statusColor = isZero ? kError : (isLow ? kAction : kAccent);

                          return InkWell(
                            onTap: () => _showDetails(idx, p),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(color: kCard, borderRadius: BorderRadius.circular(10)),
                              child: Row(children: [
                                Expanded(
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                    Text(p['name'] ?? '', style: TextStyle(color: kText, fontWeight: FontWeight.w700)),
                                    const SizedBox(height: 6),
                                    Text('SKU: ${p['sku'] ?? '-'} • ${p['category'] ?? '-'}', style: TextStyle(color: kText.withOpacity(0.8), fontSize: 13)),
                                  ]),
                                ),
                                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                                  Text('₹$price', style: TextStyle(color: kText, fontWeight: FontWeight.w700)),
                                  const SizedBox(height: 6),
                                  Row(children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(color: statusColor.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
                                      child: Text(status, style: TextStyle(color: statusColor, fontWeight: FontWeight.w700)),
                                    ),
                                    const SizedBox(width: 8),
                                    // EDIT ICON color changed to kAction (orange) for contrast
                                    IconButton(icon: Icon(Icons.edit, color: kAction), onPressed: () => widget.onEdit(idx)),
                                    IconButton(icon: Icon(Icons.delete, color: Colors.redAccent), onPressed: () => widget.onDelete(idx)),
                                  ]),
                                ]),
                              ]),
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 12),
            ]),
          ),
        ),
      ),
    );
  }

  void _showDetails(int idx, Map<String, dynamic> p) {
    showModalBottomSheet(
      context: context,
      backgroundColor: kCard,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
      builder: (c) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(p['name'] ?? '', style: TextStyle(color: kText, fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text('SKU: ${p['sku'] ?? '-'}', style: TextStyle(color: kText.withOpacity(0.85))),
            const SizedBox(height: 6),
            Text('Category: ${p['category'] ?? '-'}', style: TextStyle(color: kText.withOpacity(0.85))),
            const SizedBox(height: 6),
            Text('Qty: ${p['qty'] ?? 0}', style: TextStyle(color: kText.withOpacity(0.85))),
            const SizedBox(height: 6),
            Text('Price: ₹${p['price'] ?? 0}', style: TextStyle(color: kText.withOpacity(0.85))),
            if ((p['desc'] ?? '').toString().isNotEmpty) ...[
              const SizedBox(height: 8),
              Text('Description:', style: TextStyle(color: kText.withOpacity(0.85), fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text(p['desc'] ?? '', style: TextStyle(color: kText.withOpacity(0.85))),
            ],
            const SizedBox(height: 12),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  widget.onEdit(idx);
                },
                child: const Text('Edit'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                onPressed: () {
                  Navigator.pop(context);
                  widget.onDelete(idx);
                },
                child: const Text('Delete'),
              ),
            ]),
          ]),
        );
      },
    );
  }
}

// ---------- Reports / Insights Screen ----------
class ReportsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  const ReportsScreen({required this.products, super.key});

  @override
  Widget build(BuildContext context) {
    final int totalProducts = products.length;
    final int totalQuantity = products.fold<int>(0, (s, item) => s + ((item['qty'] as num).toInt()));
    final int totalValue = products.fold<int>(0, (s, item) => s + (((item['qty'] as num) * (item['price'] as num)).toInt()));

    Map<String, dynamic>? highestValueProduct;
    if (products.isNotEmpty) {
      highestValueProduct = products.reduce((curr, next) {
        final currVal = (curr['qty'] as num) * (curr['price'] as num);
        final nextVal = (next['qty'] as num) * (next['price'] as num);
        return currVal >= nextVal ? curr : next;
      });
    }

    final lowStockItems = products.where((item) => (item['qty'] as num) < 5).toList();

    final width = formWidth(context);

    return Scaffold(
      appBar: AppBar(title: Row(children: [smallLogo(size: 48), const SizedBox(width: 8), const Text("Reports / Insights")])),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: SizedBox(
              width: width,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                _buildReportCard(title: "Total Products", value: "$totalProducts"),
                _buildReportCard(title: "Total Stock Quantity", value: "$totalQuantity"),
                // changed value color from blue/black to kAction (orange) for contrast (not blue/black)
                _buildReportCard(title: "Total Inventory Value", value: "₹$totalValue", valueColor: kAction),
                if (highestValueProduct != null)
                  _buildReportCard(
                    title: "Highest Value Product",
                    value: "${highestValueProduct['name']} (₹${(((highestValueProduct['qty'] as num) * (highestValueProduct['price'] as num))).toInt()})",
                    valueColor: kAction,
                  ),
                const SizedBox(height: 14),
                Text('Low Stock Alerts', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: kText)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: kCard, borderRadius: BorderRadius.circular(12)),
                  child: lowStockItems.isEmpty
                      ? Text("No low-stock products.", style: TextStyle(color: kText))
                      : Column(
                          children: lowStockItems.map((item) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                Text(item['name'], style: TextStyle(color: kText, fontWeight: FontWeight.w600)),
                                Text("Qty: ${item['qty']}", style: TextStyle(color: kAction, fontWeight: FontWeight.w700)),
                              ]),
                            );
                          }).toList(),
                        ),
                ),
                const SizedBox(height: 20),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReportCard({required String title, required String value, Color? valueColor}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: kCard, borderRadius: BorderRadius.circular(12)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: TextStyle(color: kText, fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        // use valueColor if provided else default to kText
        Text(value, style: TextStyle(color: valueColor ?? kText, fontSize: 20, fontWeight: FontWeight.bold)),
      ]),
    );
  }
}

// ---------- Profile Screen ----------
class ProfileScreen extends StatelessWidget {
  final bool isAdmin;
  final List<Map<String, dynamic>> users; // list of user maps
  final VoidCallback onLogout;
  final void Function(Map<String, dynamic> user) onAddUser;
  final void Function(int index) onRemoveUser;

  const ProfileScreen({
    required this.isAdmin,
    required this.users,
    required this.onLogout,
    required this.onAddUser,
    required this.onRemoveUser,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final width = formWidth(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimary,
        title: Row(children: [smallLogo(size: 48), const SizedBox(width: 8), const Text('Profile')]),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: onLogout, tooltip: 'Logout'),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: width,
            child: Column(children: [
              const SizedBox(height: 18),
              CircleAvatar(radius: 44, backgroundColor: kCard, child: Icon(Icons.person, color: kPrimary, size: 44)),
              const SizedBox(height: 10),
              Text('Admin (You)', style: TextStyle(color: kText, fontWeight: FontWeight.w800, fontSize: 18)),
              const SizedBox(height: 8),
              Text('admin@company.com', style: TextStyle(color: kText.withOpacity(0.75))),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: kCard, borderRadius: BorderRadius.circular(12)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Team / App Users', style: TextStyle(color: kText, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 10),
                  ...users.asMap().entries.map((e) {
                    final idx = e.key;
                    final u = e.value;
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(u['name'] ?? '-', style: TextStyle(color: kText, fontWeight: FontWeight.w700)),
                      subtitle: Text(u['email'] ?? '-', style: TextStyle(color: kText.withOpacity(0.75))),
                      trailing: isAdmin ? IconButton(icon: const Icon(Icons.remove_circle, color: Colors.redAccent), onPressed: () => onRemoveUser(idx)) : null,
                    );
                  }).toList(),
                  const SizedBox(height: 12),
                  if (isAdmin)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final result = await showDialog<Map<String, dynamic>>(context: context, builder: (ctx) => const _AddUserDialog());
                          if (result != null) onAddUser(result);
                        },
                        icon: const Icon(Icons.person_add),
                        label: const Text('Add User'),
                      ),
                    ),
                ]),
              ),
              const SizedBox(height: 12),
              TextButton.icon(onPressed: onLogout, icon: const Icon(Icons.logout, color: kAction), label: Text('Logout', style: TextStyle(color: kAction))),
            ]),
          ),
        ),
      ),
    );
  }
}

class _AddUserDialog extends StatefulWidget {
  const _AddUserDialog({super.key});
  @override
  State<_AddUserDialog> createState() => _AddUserDialogState();
}
class _AddUserDialogState extends State<_AddUserDialog> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add User'),
      content: Form(
        key: _formKey,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          _labelWithStar('Name'),
          const SizedBox(height: 6),
          TextFormField(controller: _name, decoration: const InputDecoration(hintText: 'Full name'), validator: (v) => v == null || v.trim().isEmpty ? 'Enter name' : null),
          const SizedBox(height: 8),
          _labelWithStar('Email'),
          const SizedBox(height: 6),
          TextFormField(controller: _email, decoration: const InputDecoration(hintText: 'Email'), validator: (v) {
            if (v == null || v.trim().isEmpty) return 'Enter email';
            if (!v.contains('@')) return 'Enter valid email';
            return null;
          }),
        ]),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) return;
            Navigator.pop(context, {'name': _name.text.trim(), 'email': _email.text.trim() });
          },
          child: const Text('Add'),
        )
      ],
    );
  }
}

// ---------- Dashboard (stateful) ----------
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // mock products
  List<Map<String, dynamic>> _products = [
    {'name': 'Product A', 'qty': 50, 'price': 200, 'reorder': 5, 'sku': 'A001', 'desc': '', 'category': 'General'},
    {'name': 'Product B', 'qty': 8, 'price': 500, 'reorder': 10, 'sku': 'B002', 'desc': '', 'category': 'Electronics'},
    {'name': 'Product C', 'qty': 0, 'price': 120, 'reorder': 3, 'sku': 'C003', 'desc': '', 'category': 'Consumable'},
    {'name': 'Product D', 'qty': 15, 'price': 80, 'reorder': 7, 'sku': 'D004', 'desc': '', 'category': 'General'},
  ];

  // mock users for profile screen
  List<Map<String, dynamic>> _users = [
    {'name': 'Rahul', 'email': 'rahul@company.com'},
    {'name': 'Sana', 'email': 'sana@company.com'},
  ];

  // admin flag (you as admin)
  final bool _isAdmin = true;

  // computed helpers
  int get totalProducts => _products.length;
  int get lowStockCount => _products.where((p) => (p['qty'] as int) > 0 && (p['qty'] as int) <= 10).length;
  int get outOfStockCount => _products.where((p) => (p['qty'] as int) == 0).length;
  int get inventoryValue => _products.fold<num>(0, (s, p) => s + (p['qty'] * p['price'])).toInt();

  Future<void> _openAddProduct() async {
    final result = await Navigator.push<Map<String, dynamic>>(context, MaterialPageRoute(builder: (_) => const AddUpdateProductScreen()));
    if (result != null) {
      setState(() => _products.insert(0, result));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Product "${result['name']}" added'), backgroundColor: kAction));
    }
  }

  Future<void> _openEditProduct(int index) async {
    final original = Map<String, dynamic>.from(_products[index]);
    final result = await Navigator.push<Map<String, dynamic>>(context, MaterialPageRoute(builder: (_) => AddUpdateProductScreen(product: original)));
    if (result != null) {
      setState(() => _products[index] = result);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Product "${result['name']}" updated'), backgroundColor: kAction));
    }
  }

  void _deleteProduct(int index) {
    final name = _products[index]['name'];
    setState(() => _products.removeAt(index));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$name deleted'), backgroundColor: kAction));
  }

  // profile actions
  void _openProfile() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen(
      isAdmin: _isAdmin,
      users: _users,
      onLogout: _logout,
      onAddUser: (u) => setState(() => _users.add(u)),
      onRemoveUser: (i) => setState(() => _users.removeAt(i)),
    )));
  }

  void _logout() {
    // pop everything and go to login
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final width = formWidth(context);
    final _productsLocal = _products;
    return Scaffold(
      backgroundColor: Colors.white, // keep dashboard white
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: kPrimary,
        actions: [
          IconButton(icon: const Icon(Icons.person_outline), onPressed: _openProfile),
          IconButton(icon: const Icon(Icons.add), onPressed: _openAddProduct),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: SizedBox(
              width: width,
              child: Column(children: [
                // header
                Row(children: [
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Hello, Manager', style: TextStyle(color: kText, fontSize: 22, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 6),
                      Text('Overview of your inventory', style: TextStyle(color: kText.withOpacity(0.85))),
                    ]),
                  ),
                  smallLogo(size: 72), // increased logo size in dashboard header
                ]),
                const SizedBox(height: 16),
                // summary
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  _SummaryCard(title: 'Total', value: '$totalProducts', color: kPrimary, width: (width - 16) / 3),
                  _SummaryCard(title: 'Low Stock', value: '$lowStockCount', color: kAction, width: (width - 16) / 3),
                  _SummaryCard(title: 'Out', value: '$outOfStockCount', color: kError, width: (width - 16) / 3),
                ]),
                const SizedBox(height: 18),
                // quick actions
                SizedBox(width: width, child: Wrap(spacing: 10, runSpacing: 10, children: [
                  _ActionButton(label: 'Add Product', icon: Icons.add_box_outlined, onTap: _openAddProduct),
                  _ActionButton(label: 'Inventory List', icon: Icons.list_alt, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => InventoryListScreen(products: _products, onEdit: _openEditProduct, onDelete: _deleteProduct)))),
                  _ActionButton(label: 'Reports', icon: Icons.bar_chart, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ReportsScreen(products: _products)))),
                ])),
                const SizedBox(height: 18),
                // quick preview list
                SizedBox(
                  width: width,
                  child: Container(
                    decoration: BoxDecoration(color: kCard, borderRadius: BorderRadius.circular(12)),
                    child: ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _productsLocal.length,
                      separatorBuilder: (_, __) => const Divider(height: 1, color: Colors.transparent),
                      itemBuilder: (context, idx) {
                        final p = _productsLocal[idx];
                        final status = (p['qty'] as int) == 0 ? 'Stock Over' : ((p['qty'] as int) <= 10 ? 'Stock Low' : 'Stock Full');
                        final statusColor = (p['qty'] as int) == 0 ? kError : ((p['qty'] as int) <= 10 ? kAction : kAccent);
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          title: Text(p['name'], style: TextStyle(color: kText, fontWeight: FontWeight.w700)),
                          subtitle: Text('Qty: ${p['qty']}  •  ₹${p['price']}', style: TextStyle(color: kText.withOpacity(0.85))),
                          trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                            Text(status, style: TextStyle(color: statusColor, fontWeight: FontWeight.w700)),
                            const SizedBox(width: 8),
                            IconButton(icon: Icon(Icons.edit, color: kAction), onPressed: () => _openEditProduct(idx)), // changed to kAction
                            IconButton(icon: Icon(Icons.delete, color: Colors.redAccent), onPressed: () => _deleteProduct(idx)),
                          ]),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: width,
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: kCard, borderRadius: BorderRadius.circular(12)),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Inventory Value', style: TextStyle(color: kText, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      Text('₹$inventoryValue', style: TextStyle(color: kText, fontSize: 20, fontWeight: FontWeight.w700)),
                    ]),
                  ),
                ),
                const SizedBox(height: 12),
              ]),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(backgroundColor: kAction, child: const Icon(Icons.add), onPressed: _openAddProduct),
    );
  }
}

// ---------- helper widgets ----------
class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final double width;
  const _SummaryCard({required this.title, required this.value, required this.color, required this.width, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: TextStyle(color: kText.withOpacity(0.8), fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Text(value, style: TextStyle(color: kText, fontSize: 18, fontWeight: FontWeight.w800)),
      ]),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _ActionButton({required this.label, required this.icon, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 18, color: Colors.white),
        label: Text(label, style: const TextStyle(color: Colors.white)),
        style: ElevatedButton.styleFrom(backgroundColor: kPrimary, padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      ),
    );
  }
}

