import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yuva_raithu_app/features/marketplace/presentation/marketplace_providers.dart';

class AddProductScreen extends ConsumerStatefulWidget {
  const AddProductScreen({super.key});

  @override
  ConsumerState<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends ConsumerState<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final _descController = TextEditingController();
  final _usageController = TextEditingController();
  final _benefitsController = TextEditingController();
  final _imageUrlController = TextEditingController();

  String _selectedCategory = 'FERTILIZERS';
  final List<String> _categories = ['SEEDS', 'FERTILIZERS', 'PESTICIDES', 'EQUIPMENT'];

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _descController.dispose();
    _usageController.dispose();
    _benefitsController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final repository = ref.read(marketplaceRepositoryProvider);
      await repository.addProduct(
        name: _nameController.text.trim(),
        brand: _brandController.text.trim(),
        price: double.parse(_priceController.text.trim()),
        category: _selectedCategory,
        availableStock: int.parse(_stockController.text.trim()),
        description: _descController.text.trim(),
        usageInstructions: _usageController.text.trim(),
        benefits: _benefitsController.text.trim(),
        imageUrls: _imageUrlController.text.isNotEmpty ? [_imageUrlController.text.trim()] : [],
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product added successfully!')),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add product: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5FFF5),
      appBar: AppBar(
        title: const Text('Add New Product', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF2E7D32),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSectionTitle('Basic Details'),
              _buildTextField(_nameController, 'Product Name', Icons.inventory),
              _buildTextField(_brandController, 'Brand Name', Icons.branding_watermark),
              Row(
                children: [
                  Expanded(child: _buildTextField(_priceController, 'Price (₹)', Icons.currency_rupee, isNumber: true)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTextField(_stockController, 'Stock Available', Icons.inventory_2, isNumber: true)),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Category',
                  prefixIcon: const Icon(Icons.category, color: Color(0xFF2E7D32)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                items: _categories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
                onChanged: (val) => setState(() => _selectedCategory = val!),
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('Additional Information'),
              _buildTextField(_descController, 'Description', Icons.description, maxLines: 3, isRequired: false),
              _buildTextField(_usageController, 'Usage Instructions', Icons.integration_instructions, maxLines: 2, isRequired: false),
              _buildTextField(_benefitsController, 'Benefits', Icons.thumb_up, maxLines: 2, isRequired: false),
              const SizedBox(height: 24),
              _buildSectionTitle('Images'),
              _buildTextField(_imageUrlController, 'Image URL', Icons.image, isRequired: false),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: const Color(0xFF2E7D32),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Add Product', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2E7D32)),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon,
      {bool isNumber = false, int maxLines = 1, bool isRequired = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: const Color(0xFF2E7D32)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.white,
        ),
        validator: isRequired
            ? (value) {
                if (value == null || value.trim().isEmpty) return 'Please enter $label';
                if (isNumber && double.tryParse(value) == null) return 'Please enter a valid number';
                return null;
              }
            : null,
      ),
    );
  }
}
