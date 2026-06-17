import 'package:flutter/material.dart';
import '../../../models/product_model.dart';

/// Example Firestore filter by selected category:
/// ```dart
/// FirebaseFirestore.instance
///   .collection('products')
///   .where('categoryId', isEqualTo: selectedCategoryId)
///   .snapshots();
/// ```
class AddProductWidget extends StatefulWidget {
  final void Function(ProductModel)? onSaved;
  final List<dynamic>? categories; // list of category objects or maps with `id` and `name`
  final String? initialCategoryId;

  const AddProductWidget({Key? key, this.onSaved, this.categories, this.initialCategoryId}) : super(key: key);

  @override
  State<AddProductWidget> createState() => _AddProductWidgetState();
}

class _AddProductWidgetState extends State<AddProductWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _categoryCtrl = TextEditingController();
  String? _selectedCategoryId;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    _categoryCtrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _selectedCategoryId = widget.initialCategoryId;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameCtrl.text.trim();
    final price = double.tryParse(_priceCtrl.text.trim()) ?? 0.0;
    final categoryId = _selectedCategoryId ?? _categoryCtrl.text.trim();

    final product = ProductModel(
      id: null,
      name: name,
      price: price,
      categoryId: categoryId,
    );

    widget.onSaved?.call(product);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Product saved')),
    );
  }

  @override
  Widget build(BuildContext context) {
    // build a safe list of dropdown items from provided categories
    final dropdownItems = <DropdownMenuItem<String>>[];
    for (final category in (widget.categories ?? [])) {
      String? id;
      String name = '';
      if (category is Map) {
        id = category['id']?.toString();
        name = category['name']?.toString() ?? '';
      } else {
        try {
          id = category.id?.toString();
          name = category.name?.toString() ?? '';
        } catch (_) {}
      }
      if (id != null) dropdownItems.add(DropdownMenuItem<String>(value: id, child: Text(name)));
    }

    // if initial selected id is not present in items, clear it to avoid mismatches
    if (_selectedCategoryId != null && !dropdownItems.any((e) => e.value == _selectedCategoryId)) {
      _selectedCategoryId = null;
    }

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _nameCtrl,
            decoration: const InputDecoration(labelText: 'Name'),
            validator: (v) => v == null || v.trim().isEmpty ? 'Enter name' : null,
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _priceCtrl,
            decoration: const InputDecoration(labelText: 'Price'),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Enter price';
              if (double.tryParse(v.trim()) == null) return 'Invalid number';
              return null;
            },
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedCategoryId,
            decoration: const InputDecoration(labelText: 'Category'),
            isExpanded: true,
            hint: const Text('Select category'),
            items: dropdownItems,
            onChanged: (value) => setState(() => _selectedCategoryId = value),
            validator: (v) => v == null || v.isEmpty ? 'Select category' : null,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _submit,
            child: const Text('Save Product'),
          ),
        ],
      ),
    );
  }
}