import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:selling_project/controller/product_controller.dart';

class ProductAddWidget extends StatelessWidget {
  ProductAddWidget({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
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
                    'Add New Product',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      productCtrl.clearForm();
                      Get.back();
                    },
                  )
                ],
              ),
              const Divider(),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => _showImagePickerModal(context),
                child: Obx(() {
                  final file = productCtrl.pickedImageFile.value;
                  return Container(
                    height: 140,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: file != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(file, fit: BoxFit.cover),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.add_a_photo_outlined, size: 40, color: Colors.grey),
                              SizedBox(height: 8),
                              Text('Tap to select product image', style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                  );
                }),
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: productCtrl.productNameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Product Name *',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: productCtrl.costPriceCtrl,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Cost Price (\$)*',
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: productCtrl.salePriceCtrl,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Sale Price (\$)*',
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: productCtrl.quantityCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Stock Quantity',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),

              Obx(() => DropdownButtonFormField<String>(
                    initialValue: productCtrl.selectedCategoryId.value,
                    hint: const Text('Select Category'),
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                    items: productCtrl.categoryCtrl.category.map((cat) {
                      return DropdownMenuItem(value: cat.id, child: Text(cat.name));
                    }).toList(),
                    onChanged: (val) => productCtrl.selectedCategoryId.value = val,
                  )),
              const SizedBox(height: 12),

              Obx(() => DropdownButtonFormField<String>(
                    initialValue: productCtrl.selectedBrandId.value,
                    hint: const Text('Select Brand'),
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                    items: productCtrl.brandCtrl.brands.map((b) {
                      return DropdownMenuItem(value: b.id, child: Text(b.name));
                    }).toList(),
                    onChanged: (val) => productCtrl.selectedBrandId.value = val,
                  )),
              const SizedBox(height: 12),

              Obx(() => DropdownButtonFormField<String>(
                    initialValue: productCtrl.selectedSupplierId.value,
                    hint: const Text('Select Supplier'),
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                    items: productCtrl.supplierCtrl.suppliers.map((sup) {
                      return DropdownMenuItem(value: sup.id, child: Text(sup.name));
                    }).toList(),
                    onChanged: (val) => productCtrl.selectedSupplierId.value = val,
                  )),
              const SizedBox(height: 12),

              TextFormField(
                controller: productCtrl.descriptionCtrl,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: Obx(() => ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4F46E5),
                      ),
                      onPressed: productCtrl.loading.value ? null : () => productCtrl.submitSave(),
                      child: productCtrl.loading.value
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : const Text('Save Product', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}