import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:selling_project/controller/product_controller.dart';

class ProductEditWidget extends StatelessWidget {
  ProductEditWidget({super.key});

  final ProductController productCtrl = Get.find<ProductController>();

  void _showImagePickerModal(BuildContext context) {
    Get.bottomSheet(
      Container(
        color: Colors.white,
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Get.back();
                productCtrl.pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a Photo'),
              onTap: () {
                Get.back();
                productCtrl.pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, top: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF004D7F)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 16,
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Form(
          key: productCtrl.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Edit Product',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () {
                      productCtrl.clearForm();
                      Get.back();
                    },
                  )
                ],
              ),
              const Divider(height: 1),
              const SizedBox(height: 12),

              GestureDetector(
                onTap: () => _showImagePickerModal(context),
                child: Obx(() {
                  final file = productCtrl.pickedImageFile.value;
                  final imageUrl = productCtrl.imageCtrl.text.trim();

                  return Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Builder(
                        builder: (context) {
                          if (file != null) {
                            return Image.file(file, fit: BoxFit.cover);
                          }
                          if (imageUrl.isNotEmpty && Uri.tryParse(imageUrl)?.hasAbsolutePath == true) {
                            return Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _buildPlaceholder(),
                            );
                          }
                          return _buildPlaceholder();
                        },
                      ),
                    ),
                  );
                }),
              ),

              _buildFieldLabel('Product Name'),
              TextFormField(
                controller: productCtrl.productNameCtrl,
                decoration: _inputDecoration('e.g Industrial Drill Press'),
                validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
              ),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFieldLabel('Cost Price'),
                        TextFormField(
                          controller: productCtrl.costPriceCtrl,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: _inputDecoration('\$ 0.00'),
                          validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFieldLabel('Sale Price'),
                        TextFormField(
                          controller: productCtrl.salePriceCtrl,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: _inputDecoration('\$ 0.00'),
                          validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              _buildFieldLabel('Quantity'),
              TextFormField(
                controller: productCtrl.quantityCtrl,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration('10'),
              ),

              _buildFieldLabel('Brand'),
              Obx(() => DropdownButtonFormField<String>(
                    initialValue: productCtrl.selectedBrandId.value,
                    hint: Text('Select Brand', style: TextStyle(color: Colors.grey.shade400, fontSize: 13)),
                    decoration: _inputDecoration(''),
                    items: productCtrl.brandCtrl.brands.map((brand) {
                      return DropdownMenuItem(value: brand.id, child: Text(brand.name, style: const TextStyle(fontSize: 13)));
                    }).toList(),
                    onChanged: (val) => productCtrl.selectedBrandId.value = val,
                  )),

              _buildFieldLabel('Supplier'),
              Obx(() => DropdownButtonFormField<String>(
                    initialValue: productCtrl.selectedSupplierId.value,
                    hint: Text('Select Supplier', style: TextStyle(color: Colors.grey.shade400, fontSize: 13)),
                    decoration: _inputDecoration(''),
                    items: productCtrl.supplierCtrl.suppliers.map((sup) {
                      return DropdownMenuItem(value: sup.id, child: Text(sup.name, style: const TextStyle(fontSize: 13)));
                    }).toList(),
                    onChanged: (val) => productCtrl.selectedSupplierId.value = val,
                  )),

              _buildFieldLabel('Description'),
              TextFormField(
                controller: productCtrl.descriptionCtrl,
                maxLines: 3,
                decoration: _inputDecoration('Enter product specifications and details...'),
              ),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: Obx(() => ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF004D7F),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: productCtrl.loading.value ? null : () => productCtrl.submitUpdate(),
                      child: productCtrl.loading.value
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : const Text(
                              'Update Product',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.add_a_photo_outlined, size: 36, color: Colors.grey.shade400),
        const SizedBox(height: 6),
        Text('Tap to select product image', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
      ],
    );
  }
}