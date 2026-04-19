import 'package:flutter/material.dart';
import '../models/enums.dart';
import '../theme/app_theme.dart';

/// Add Listing Form Screen — allows sellers to post new items.
/// (D3: Form with GlobalKey<FormState>, validators, form.validate())
/// (D4: 4+ fields with meaningful validation including format/length/pattern)
class AddListingScreen extends StatefulWidget {
  const AddListingScreen({super.key});

  @override
  State<AddListingScreen> createState() => _AddListingScreenState();
}

class _AddListingScreenState extends State<AddListingScreen> {
  // D3: GlobalKey<FormState> for form validation
  final _formKey = GlobalKey<FormState>();

  // A1: Variables with explicit types
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();

  // A1: Nullable variables for dropdown selections
  ProductCategory? _selectedCategory;
  ProductCondition? _selectedCondition;

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _sizeController.dispose();
    super.dispose();
  }

  /// Handles form submission
  void _submitForm() {
    // D3: Calling form.validate() before processing
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      // Form has errors — they will show on each field automatically
      _showSnackBar('Please fix the errors above');
      return;
    }

    // Additional dropdown validation
    if (_selectedCategory == null) {
      _showSnackBar('Please select a category');
      return;
    }
    if (_selectedCondition == null) {
      _showSnackBar('Please select a condition');
      return;
    }

    // All validation passed — show success message
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: AppTheme.primary, size: 28),
            SizedBox(width: 10),
            Text('Listing Posted!'),
          ],
        ),
        content: Text(
          '"${_titleController.text}" has been posted for '
          '${_priceController.text} RWF.',
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext); // Close dialog
              Navigator.pop(context); // D5: Return to previous screen
            },
            child: const Text('Back to Home'),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      // C4: AppBar — Material Design component
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context), // D5: Back navigation
          icon: const Icon(Icons.close),
        ),
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.sell_outlined, size: 20),
            SizedBox(width: 8),
            Text('Sell Item'),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextButton(
              onPressed: _submitForm,
              child: const Text(
                'POST',
                style: TextStyle(
                  color: AppTheme.onPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        // D3: Form widget with GlobalKey
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Photo Upload Area ──
              _buildPhotoUpload(),
              const SizedBox(height: 24),

              // ── Field 1: Title (D4: validation with length check) ──
              _buildFieldLabel('Title'),
              const SizedBox(height: 6),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: 'Item title (e.g., Blue Sneakers)',
                ),
                // D4: Validation with length check
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Title is required';
                  }
                  if (value.length < 3) {
                    return 'Title must be at least 3 characters';
                  }
                  if (value.length > 50) {
                    return 'Title cannot exceed 50 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // ── Field 2: Category Dropdown ──
              _buildFieldLabel('Category'),
              const SizedBox(height: 6),
              DropdownButtonFormField<ProductCategory>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  hintText: 'Select category',
                ),
                items: ProductCategory.values.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category.label),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedCategory = value);
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a category';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // ── Field 3: Size ──
              _buildFieldLabel('Size'),
              const SizedBox(height: 6),
              TextFormField(
                controller: _sizeController,
                decoration: const InputDecoration(
                  hintText: 'e.g., Large (L), 42, M',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Size is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // ── Field 4: Condition Dropdown ──
              _buildFieldLabel('Condition'),
              const SizedBox(height: 6),
              DropdownButtonFormField<ProductCondition>(
                value: _selectedCondition,
                decoration: const InputDecoration(
                  hintText: 'Select condition',
                ),
                items: ProductCondition.values.map((condition) {
                  return DropdownMenuItem(
                    value: condition,
                    child: Text(condition.label),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedCondition = value);
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select item condition';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // ── Field 5: Price (D4: validation with pattern/format check) ──
              _buildFieldLabel('Price (RWF)'),
              const SizedBox(height: 6),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'e.g., 15000',
                ),
                // D4: Validation with format and range check
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Price is required';
                  }
                  // D4: Pattern check — must be a valid number
                  final price = double.tryParse(value);
                  if (price == null) {
                    return 'Please enter a valid number';
                  }
                  if (price <= 0) {
                    return 'Price must be greater than 0';
                  }
                  if (price > 1000000) {
                    return 'Price cannot exceed 1,000,000 RWF';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // ── Field 6: Description (D4: validation with length check) ──
              _buildFieldLabel('Description'),
              const SizedBox(height: 6),
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText:
                      'Describe your item (brand, color, any flaws, reason for selling...)',
                  alignLabelWithHint: true,
                ),
                // D4: Validation with minimum length
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Description is required';
                  }
                  if (value.length < 15) {
                    return 'Description must be at least 15 characters';
                  }
                  if (value.length > 500) {
                    return 'Description cannot exceed 500 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // ── Field 7: Location ──
              _buildFieldLabel('Location'),
              const SizedBox(height: 6),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  hintText: 'Meetup location (e.g., Hostel A, Room 12)',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Location is required';
                  }
                  if (value.length < 5) {
                    return 'Please provide a more specific location';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // ── Submit Button ──
              // C4: ElevatedButton — Material Design component
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('POST LISTING'),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds a section label above form fields
  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
    );
  }

  /// Builds the photo upload placeholder area
  Widget _buildPhotoUpload() {
    return Container(
      width: double.infinity,
      height: 140,
      decoration: BoxDecoration(
        color: AppTheme.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.camera_alt_outlined, color: AppTheme.onPrimary, size: 40),
          const SizedBox(height: 8),
          Text(
            'Upload Photos',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            '(Minimum 2 required)',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppTheme.onPrimary.withOpacity(0.8),
                ),
          ),
        ],
      ),
    );
  }
}