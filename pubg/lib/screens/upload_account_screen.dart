import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UploadAccountScreen extends StatefulWidget {
  const UploadAccountScreen({Key? key}) : super(key: key);

  @override
  State<UploadAccountScreen> createState() => _UploadAccountScreenState();
}

class _UploadAccountScreenState extends State<UploadAccountScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _kdController = TextEditingController();
  final TextEditingController _matchesController = TextEditingController();
  final TextEditingController _skinsController = TextEditingController();

  String _selectedTier = 'Bronze';
  final List<String> _tiers = [
    'Bronze',
    'Silver',
    'Gold',
    'Platinum',
    'Diamond',
    'Crown',
    'Ace',
    'Conqueror',
  ];

  final List<XFile> _images = [];
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _kdController.dispose();
    _matchesController.dispose();
    _skinsController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    try {
      final pickedFiles = await _picker.pickMultiImage();
      if (pickedFiles != null) {
        setState(() {
          _images.addAll(pickedFiles);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error picking images: $e')));
    }
  }

  Future<void> _uploadAccount() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isUploading = true);

    try {
      // Upload images to Supabase storage
      List<String> imageUrls = [];
      for (var image in _images) {
        final fileBytes = await image.readAsBytes();
        final fileName =
            '${DateTime.now().millisecondsSinceEpoch}_${image.name}';
        await Supabase.instance.client.storage
            .from('accounts-images')
            .uploadBinary(fileName, fileBytes);
        final url = Supabase.instance.client.storage
            .from('accounts-images')
            .getPublicUrl(fileName);
        imageUrls.add(url);
      }

      // Insert account data into Supabase with proper type conversions
      await Supabase.instance.client.from('accounts').insert({
        'title': _titleController.text,
        'description': _descriptionController.text,
        'price': int.tryParse(_priceController.text) ?? 0, // BIGINT
        'tier': _selectedTier,
        'kd': double.tryParse(_kdController.text) ?? 0, // numeric/float
        'matches': int.tryParse(_matchesController.text) ?? 0,
        'skins': int.tryParse(_skinsController.text) ?? 0,
        'images': imageUrls, // array of strings
        'seller_name': 'Current User', // replace with actual user
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account uploaded successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Clear form
      _formKey.currentState!.reset();
      setState(() {
        _images.clear();
        _selectedTier = 'Bronze';
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Upload failed: $e')));
    }

    setState(() => _isUploading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sell Account',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image Picker
              GestureDetector(
                onTap: _pickImages,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[800]!, width: 2),
                  ),
                  child: _images.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.add_photo_alternate,
                              size: 60,
                              color: Colors.orange,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Add Screenshots/Videos',
                              style: TextStyle(color: Colors.grey[400]),
                            ),
                          ],
                        )
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _images.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.file(
                                File(_images[index].path),
                                width: 120,
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        ),
                ),
              ),
              const SizedBox(height: 24),

              // Title
              _buildTextField(
                _titleController,
                'Account Title',
                'e.g., Conqueror Account - S28',
              ),
              const SizedBox(height: 16),

              // Tier dropdown
              const Text(
                'Tier',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedTier,
                dropdownColor: Colors.grey[900],
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[900],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                items: _tiers
                    .map(
                      (tier) =>
                          DropdownMenuItem(value: tier, child: Text(tier)),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _selectedTier = value!),
              ),
              const SizedBox(height: 16),

              // Stats row
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      _kdController,
                      'K/D Ratio',
                      '5.2',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      _matchesController,
                      'Matches',
                      '1200',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Skins
              _buildTextField(
                _skinsController,
                'Number of Skins',
                '50',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              // Description
              _buildTextField(
                _descriptionController,
                'Description',
                'Describe your account...',
                maxLines: 4,
              ),
              const SizedBox(height: 16),

              // Price
              _buildTextField(
                _priceController,
                'Price (Rs)',
                '5000',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 32),

              // Upload button
              ElevatedButton(
                onPressed: _isUploading ? null : _uploadAccount,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isUploading
                    ? const CircularProgressIndicator(color: Colors.black)
                    : const Text(
                        'Upload Account',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    String hint, {
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 16)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[600]),
            filled: true,
            fillColor: Colors.grey[900],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) return 'Required';
            return null;
          },
        ),
      ],
    );
  }
}
