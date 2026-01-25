import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/web.dart';
import 'package:progress_pals/core/theme/app_colors.dart';
import 'package:progress_pals/data/datasources/local/database_service.dart';
import 'package:progress_pals/data/models/friend_model.dart';
import 'package:progress_pals/presentation/widgets/app_button.dart';

class AddFriendScreen extends StatefulWidget {
  final FriendModel? friend;

  const AddFriendScreen({super.key, this.friend});

  @override
  State<AddFriendScreen> createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends State<AddFriendScreen> {
  final DatabaseService _databaseService = DatabaseService();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  final _formKey = GlobalKey<FormState>();
  FriendModel? _editingFriend;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();

    // Check if we're editing a friend
    if (widget.friend != null) {
      _editingFriend = widget.friend;
      _nameController.text = widget.friend!.name;
      _emailController.text = widget.friend!.email;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      final User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        Logger().e("Error: No user logged in!");
        return;
      }

      if (_editingFriend != null) {
        // Update existing friend
        final updatedFriend = FriendModel(
          id: _editingFriend!.id,
          userId: _editingFriend!.userId,
          name: _nameController.text,
          email: _emailController.text,
          addedDate: _editingFriend!.addedDate,
        );
        await _databaseService.updateFriend(updatedFriend);
        Logger().i('Friend updated: ${updatedFriend.name}');
      } else {
        // Create new friend
        final friend = FriendModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          userId: currentUser.uid,
          email: _emailController.text,
          name: _nameController.text,
          addedDate: DateTime.now(),
        );
        await _databaseService.insertFriend(friend);
        Logger().i('Friend created: ${friend.name}');
      }

      if (mounted) {
        Navigator.pop(context, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          _editingFriend != null ? 'Edit Friend' : 'Add New Friend',
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name Field
                _buildFormLabel('Friend\'s Name'),
                const SizedBox(height: 8),
                _buildTextFormField(
                  controller: _nameController,
                  hintText: 'e.g., John Doe',
                  icon: Icons.person_outline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    if (value.length < 2) {
                      return 'Name must be at least 2 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Email Field
                _buildFormLabel('Friend\'s Email'),
                const SizedBox(height: 8),
                _buildTextFormField(
                  controller: _emailController,
                  hintText: 'e.g., john@example.com',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email';
                    }
                    if (!RegExp(
                      r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
                    ).hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                // Submit Button
                AppButton(
                  text: _editingFriend != null ? 'Update Friend' : 'Add Friend',
                  onPressed: _handleSubmit,
                ),
                const SizedBox(height: 16),

                // Cancel Button
                AppButton(
                  text: 'Cancel',
                  type: ButtonType.outline,
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: AppColors.textDisabled),
        prefixIcon: Icon(icon, color: AppColors.primary),
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.divider, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.divider, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        errorStyle: const TextStyle(
          color: AppColors.error,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      style: const TextStyle(color: AppColors.textPrimary, fontSize: 16),
    );
  }
}
