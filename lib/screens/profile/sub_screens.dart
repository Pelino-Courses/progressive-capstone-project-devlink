import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/auth_service.dart';
import '../../theme/app_theme.dart';
import '../../theme/theme_provider.dart';
import '../../utils/app_localizations.dart';

// ─── CART SCREEN ───
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: Text(loc.get('shopping_cart'))),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.shopping_cart_outlined, size: 80, color: Theme.of(context).colorScheme.onSurfaceVariant.withAlpha((0.5 * 255).round())),
          const SizedBox(height: 16),
          Text(loc.get('cart_empty'), style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(loc.get('browse_items_add_to_cart'), style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
          const SizedBox(height: 24),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 40),
            child: ElevatedButton(onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
            }, child: Text(loc.get('browse_items')))),
        ]),
      ),
    );
  }
}

// ─── EDIT PROFILE SCREEN (with photo upload) ───
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _campusController = TextEditingController();
  bool _isSaving = false;
  String? _avatarUrl;
  Uint8List? _newAvatarBytes;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    _nameController.text = user.displayName ?? '';
    final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    if (doc.exists) {
      final data = doc.data()!;
      setState(() {
        _phoneController.text = data['phone'] ?? '';
        _campusController.text = data['campus'] ?? '';
        _avatarUrl = data['avatarUrl'];
      });
    }
  }

  Future<void> _pickProfilePhoto() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70, maxWidth: 500);
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() => _newAvatarBytes = bytes);
    }
  }

  Future<String?> _uploadAvatar(Uint8List bytes) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final ref = FirebaseStorage.instance.ref().child('avatars/$uid.jpg');
    await ref.putData(bytes, SettableMetadata(contentType: 'image/jpeg'));
    return await ref.getDownloadURL();
  }

  Future<void> _saveProfile() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isSaving = true);
    try {
      final user = FirebaseAuth.instance.currentUser!;

      String? avatarUrl = _avatarUrl;
      if (_newAvatarBytes != null) {
        avatarUrl = await _uploadAvatar(_newAvatarBytes!);
      }

      await user.updateDisplayName(_nameController.text.trim());
      if (avatarUrl != null) await user.updatePhotoURL(avatarUrl);

      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'fullName': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'campus': _campusController.text.trim(),
        'avatarUrl': avatarUrl ?? '',
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).get('profile_updated')), backgroundColor: AppTheme.primary));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: AppTheme.error));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: Text(loc.get('edit_profile'))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(key: _formKey, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(child: Stack(children: [
            CircleAvatar(radius: 50, backgroundColor: AppTheme.primaryContainer,
              backgroundImage: _newAvatarBytes != null ? MemoryImage(_newAvatarBytes!)
                  : (_avatarUrl != null && _avatarUrl!.isNotEmpty ? NetworkImage(_avatarUrl!) as ImageProvider : null),
              child: (_newAvatarBytes == null && (_avatarUrl == null || _avatarUrl!.isEmpty))
                  ? Text((user?.displayName ?? 'U')[0].toUpperCase(),
                      style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w700, color: AppTheme.primary))
                  : null),
            Positioned(bottom: 0, right: 0,
              child: MouseRegion(cursor: SystemMouseCursors.click,
                child: GestureDetector(onTap: _pickProfilePhoto,
                  child: const CircleAvatar(radius: 18, backgroundColor: AppTheme.primary,
                      child: Icon(Icons.camera_alt, size: 18, color: AppTheme.onPrimary))))),
          ])),
          const SizedBox(height: 24),
          Text(loc.get('full_name'), style: const TextStyle(fontWeight: FontWeight.w600)), const SizedBox(height: 6),
          TextFormField(controller: _nameController, decoration: const InputDecoration(hintText: 'Your full name'),
              validator: (v) => (v == null || v.isEmpty) ? 'Name is required' : null),
          const SizedBox(height: 16),
          Text(loc.get('phone'), style: const TextStyle(fontWeight: FontWeight.w600)), const SizedBox(height: 6),
          TextFormField(controller: _phoneController, keyboardType: TextInputType.phone, decoration: const InputDecoration(hintText: '+250...')),
          const SizedBox(height: 16),
          Text(loc.get('campus'), style: const TextStyle(fontWeight: FontWeight.w600)), const SizedBox(height: 6),
          TextFormField(controller: _campusController, decoration: const InputDecoration(hintText: 'e.g., UR Huye Campus')),
          const SizedBox(height: 32),
          _isSaving ? const Center(child: CircularProgressIndicator())
              : ElevatedButton(onPressed: _saveProfile, child: Text(loc.get('save_changes'))),
        ])),
      ),
    );
  }
}

// ─── ADDRESSES SCREEN (functional) ───
class AddressesScreen extends StatefulWidget {
  const AddressesScreen({super.key});

  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  final _addressController = TextEditingController();

  void _addAddress() {
    final loc = AppLocalizations.of(context);
    showDialog(context: context, builder: (ctx) => AlertDialog(
      title: Text(loc.get('add_address')),
      content: TextField(controller: _addressController, decoration: InputDecoration(hintText: 'e.g., Hostel A, Room 12, UR Huye'),
          maxLines: 2),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: Text(loc.get('cancel'))),
        ElevatedButton(onPressed: () async {
          if (_addressController.text.trim().isEmpty) return;
          final uid = FirebaseAuth.instance.currentUser?.uid;
          if (uid == null) return;
          await FirebaseFirestore.instance.collection('users').doc(uid).collection('addresses').add({
            'address': _addressController.text.trim(),
            'createdAt': FieldValue.serverTimestamp(),
          });
          _addressController.clear();
          if (ctx.mounted) Navigator.pop(ctx);
        }, child: const Text('Save')),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('My Addresses')),
      floatingActionButton: FloatingActionButton(backgroundColor: AppTheme.primary, onPressed: _addAddress,
          child: const Icon(Icons.add, color: AppTheme.onPrimary)),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(uid).collection('addresses').orderBy('createdAt', descending: true).snapshots(),
        builder: (context, snapshot) {
          final loc = AppLocalizations.of(context);
          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) {
            return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.location_off_outlined, size: 80, color: Theme.of(context).colorScheme.onSurfaceVariant.withAlpha((0.5 * 255).round())),
              const SizedBox(height: 16), Text(loc.get('no_addresses_saved'), style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 8), Text(loc.get('tap_to_add_address'), style: Theme.of(context).textTheme.bodyMedium),
            ]));
          }
          return ListView.builder(itemCount: docs.length, itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;
            return ListTile(
              leading: const Icon(Icons.location_on, color: AppTheme.primary),
              title: Text(data['address'] ?? ''),
              trailing: IconButton(icon: const Icon(Icons.delete_outline, color: AppTheme.error),
                  onPressed: () => docs[index].reference.delete()),
            );
          });
        },
      ),
    );
  }
}

// ─── PURCHASE HISTORY SCREEN (fixed: Start Shopping → Home) ───
class PurchaseHistoryScreen extends StatelessWidget {
  const PurchaseHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('Purchase History')),
      body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.receipt_long_outlined, size: 80, color: Theme.of(context).colorScheme.onSurfaceVariant.withAlpha((0.5 * 255).round())),
        const SizedBox(height: 16), Text('No purchase history', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 8), Text('Your completed purchases will appear here', style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 24),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 40),
          child: ElevatedButton(onPressed: () {
            // FIX #7: Navigate to home screen, not back to profile
            Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
          }, child: const Text('Start Shopping'))),
      ])),
    );
  }
}

// ─── SETTINGS SCREEN (with working dark mode, language, delete account) ───
class SettingsScreen extends StatefulWidget {
  final ThemeProvider themeProvider;
  final LocaleProvider localeProvider;

  const SettingsScreen({super.key, required this.themeProvider, required this.localeProvider});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = true;
  bool _locationAccess = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(children: [
        Padding(padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text('General', style: TextStyle(fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.primary))),
        SwitchListTile(title: const Text('Push Notifications'), subtitle: const Text('Receive alerts for messages'),
            value: _notifications, activeThumbColor: AppTheme.primary, onChanged: (v) => setState(() => _notifications = v)),
        // FIX #2: Working dark mode
        SwitchListTile(title: const Text('Dark Mode'), subtitle: const Text('Switch to dark theme'),
            value: widget.themeProvider.isDarkMode, activeThumbColor: AppTheme.primary,
            onChanged: (v) => widget.themeProvider.toggleDarkMode(v)),
        SwitchListTile(title: const Text('Location Access'), subtitle: const Text('Allow app to access your location'),
            value: _locationAccess, activeThumbColor: AppTheme.primary, onChanged: (v) => setState(() => _locationAccess = v)),
        const Divider(),
        // FIX #3: Working language selector
        Padding(padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text('Language', style: TextStyle(fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.primary))),
        ListTile(
          leading: const Icon(Icons.language, color: AppTheme.primary),
          title: const Text('App Language'),
          subtitle: Text(widget.localeProvider.languageName),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showLanguagePicker(),
        ),
        const Divider(),
        Padding(padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text('Account', style: TextStyle(fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.primary))),
        ListTile(leading: const Icon(Icons.lock_outline, color: AppTheme.primary), title: const Text('Change Password'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              final email = FirebaseAuth.instance.currentUser?.email;
              if (email != null) {
                final messenger = ScaffoldMessenger.of(context);
                await AuthService().resetPassword(email);
                if (!mounted) return;
                messenger.showSnackBar(SnackBar(content: Text('Reset email sent to $email'), backgroundColor: AppTheme.primary));
              }
            }),
        // FIX #4: Working privacy policy
        ListTile(leading: const Icon(Icons.privacy_tip_outlined, color: AppTheme.primary), title: const Text('Privacy Policy'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()))),
        const Divider(),
        // FIX #8: Working delete account
        Padding(padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text('Danger Zone', style: TextStyle(fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.error))),
        ListTile(leading: Icon(Icons.delete_forever, color: Theme.of(context).colorScheme.error),
            title: Text('Delete Account', style: TextStyle(color: Theme.of(context).colorScheme.error)),
            onTap: () => _showDeleteConfirmation()),
        const SizedBox(height: 24),
        Center(child: Text('PreLoved Market v1.0.0', style: Theme.of(context).textTheme.labelSmall)),
        const SizedBox(height: 24),
      ]),
    );
  }

  void _showLanguagePicker() {
    showDialog(context: context, builder: (ctx) => SimpleDialog(
      title: const Text('Choose Language'),
      children: [
        _langOption(ctx, 'English', const Locale('en')),
        _langOption(ctx, 'Français', const Locale('fr')),
        _langOption(ctx, 'Kinyarwanda', const Locale('rw')),
      ],
    ));
  }

  Widget _langOption(BuildContext ctx, String name, Locale locale) {
    final isSelected = widget.localeProvider.locale.languageCode == locale.languageCode;
    return SimpleDialogOption(
      onPressed: () { widget.localeProvider.setLocale(locale); Navigator.pop(ctx); },
      child: Row(children: [
        Icon(isSelected ? Icons.radio_button_checked : Icons.radio_button_off, color: AppTheme.primary),
        const SizedBox(width: 12), Text(name, style: TextStyle(fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400)),
      ]),
    );
  }

  void _showDeleteConfirmation() {
    final passwordController = TextEditingController();
    showDialog(context: context, builder: (ctx) => AlertDialog(
      title: const Text('Delete Account Permanently?'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        const Text('This action is permanent. All your data, listings, and messages will be deleted forever.'),
        const SizedBox(height: 16),
        TextField(controller: passwordController, obscureText: true,
            decoration: const InputDecoration(hintText: 'Enter your password to confirm', border: OutlineInputBorder())),
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error),
          onPressed: () async {
            final localContext = context;
            final navigator = Navigator.of(localContext);
            final messenger = ScaffoldMessenger.of(localContext);
            try {
              final user = FirebaseAuth.instance.currentUser!;
              final credential = EmailAuthProvider.credential(email: user.email!, password: passwordController.text);
              await user.reauthenticateWithCredential(credential);

              // Delete user data from Firestore
              await FirebaseFirestore.instance.collection('users').doc(user.uid).delete();
              // Delete the account
              await user.delete();

              if (!ctx.mounted) return;
              Navigator.pop(ctx);
              if (!mounted) return;
              navigator.pushNamedAndRemoveUntil('/login', (route) => false);
            } catch (e) {
              if (ctx.mounted) {
                Navigator.pop(ctx);
                messenger.showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: AppTheme.error));
              }
            }
          },
          child: const Text('Delete Forever'),
        ),
      ],
    ));
  }
}

// ─── PRIVACY POLICY SCREEN ───
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Privacy Policy', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text('Last updated: May 2026', style: Theme.of(context).textTheme.labelSmall),
          const SizedBox(height: 24),
          _section('1. Information We Collect',
              'We collect information you provide directly: your name, email address, campus location, phone number, and profile photo. '
              'We also collect information about your listings, including product photos, descriptions, and pricing. '
              'Chat messages between buyers and sellers are stored to facilitate transactions.'),
          _section('2. How We Use Your Information',
              'Your information is used to: create and manage your account, display your listings to other users, '
              'enable communication between buyers and sellers, improve our services, and send important notifications about your account and transactions.'),
          _section('3. Information Sharing',
              'We do not sell your personal information. Your profile name and campus are visible to other users when you list items. '
              'Chat messages are only visible to the participants. We may share information if required by law or to protect safety.'),
          _section('4. Data Storage',
              'Your data is stored securely using Firebase services (Google Cloud). Data is encrypted in transit and at rest. '
              'We retain your data as long as your account is active. You can request deletion at any time through Settings.'),
          _section('5. Your Rights',
              'You have the right to: access your personal data, correct inaccurate information, delete your account and all associated data, '
              'and opt out of non-essential communications. To exercise these rights, go to Settings or contact our support team.'),
          _section('6. Photos and Images',
              'Product photos you upload are stored in our cloud storage and visible to all users. Profile photos are optional. '
              'You can delete your listings and their associated photos at any time.'),
          _section('7. Campus Safety',
              'We recommend meeting in public areas on campus for transactions. Never share your room number or personal address in listings. '
              'Use the in-app chat for all communication. Report suspicious users through the app.'),
          _section('8. Contact Us',
              'For privacy questions or concerns, contact us at:\n\n'
              'Email: privacy@prelovedmarket.rw\nPhone: +250 788 000 000\n\n'
              'University of Rwanda, Huye Campus'),
          const SizedBox(height: 40),
        ]),
      ),
    );
  }

  Widget _section(String title, String body) {
    return Padding(padding: const EdgeInsets.only(bottom: 20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
      const SizedBox(height: 8),
      Text(body, style: const TextStyle(height: 1.6, fontSize: 14)),
    ]));
  }
}

// ─── HELP & SUPPORT SCREEN ───
class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('Help & Support')),
      body: ListView(children: [
        Padding(padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text('Frequently Asked Questions', style: TextStyle(fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.primary))),
        _faqTile('How do I list an item for sale?', 'Tap the + Sell button. Fill in details, upload photos, and tap POST.'),
        _faqTile('How do I message a seller?', 'Open any listing and tap MESSAGE SELLER at the bottom.'),
        _faqTile('Is my transaction secure?', 'We recommend meeting on campus in public areas. Use in-app chat for all communication.'),
        _faqTile('How do I change my password?', 'Go to Profile > Settings > Change Password. A reset link will be sent to your email.'),
        _faqTile('Can I return an item?', 'Returns are arranged between buyer and seller via chat. Inspect items before completing transactions.'),
        _faqTile('How do I delete my account?', 'Go to Profile > Settings > Delete Account. This action is permanent.'),
        const Divider(),
        Padding(padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text('Contact Us', style: TextStyle(fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.primary))),
        const ListTile(leading: Icon(Icons.email_outlined, color: AppTheme.primary), title: Text('Email Support'), subtitle: Text('support@prelovedmarket.rw')),
        const ListTile(leading: Icon(Icons.phone_outlined, color: AppTheme.primary), title: Text('Phone Support'), subtitle: Text('+250 788 000 000')),
        const ListTile(leading: Icon(Icons.access_time, color: AppTheme.primary), title: Text('Working Hours'), subtitle: Text('Mon-Fri, 9:00 AM - 5:00 PM')),
        const SizedBox(height: 24),
      ]),
    );
  }

  static Widget _faqTile(String q, String a) => ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(horizontal: 16),
      title: Text(q, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
      children: [Padding(padding: const EdgeInsets.fromLTRB(16, 0, 16, 16), child: Text(a, style: const TextStyle(height: 1.5)))]);
}