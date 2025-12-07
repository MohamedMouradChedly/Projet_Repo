import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  final String email; // non-editable login email
  final String currentName;
  final String currentEmail;

  const EditProfilePage({
    super.key,
    required this.email,
    required this.currentName,
    required this.currentEmail,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  String _phone = '';
  String _password = '';

  @override
  void initState() {
    super.initState();
    _name = widget.currentName;
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // TODO: Update backend / Firebase / Provider

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil mis à jour')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF7F7CFF),
              Color(0xFFA77BFF),
              Color(0xFFD77BFF),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // --- Top Bar ---
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.arrow_back, color: Colors.white),
                                onPressed: () => Navigator.pop(context),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Modifier mon profil',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),

                          // --- Form ---
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                // Name
                                TextFormField(
                                  initialValue: _name,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    labelText: 'Nom',
                                    labelStyle: const TextStyle(color: Colors.white70),
                                    prefixIcon:
                                    const Icon(Icons.person, color: Colors.white70),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(color: Colors.white54),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(color: Colors.white),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  validator: (value) =>
                                  (value == null || value.isEmpty)
                                      ? 'Veuillez entrer votre nom'
                                      : null,
                                  onSaved: (value) => _name = value ?? '',
                                ),
                                const SizedBox(height: 16),

                                // Email (read-only)
                                TextFormField(
                                  initialValue: widget.email,
                                  readOnly: true,
                                  style: const TextStyle(color: Colors.white70),
                                  decoration: InputDecoration(
                                    labelText: 'Email (non modifiable)',
                                    labelStyle: const TextStyle(color: Colors.white70),
                                    prefixIcon:
                                    const Icon(Icons.email, color: Colors.white70),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                      const BorderSide(color: Colors.white54),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Phone
                                TextFormField(
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    labelText: 'Numéro de téléphone',
                                    labelStyle: const TextStyle(color: Colors.white70),
                                    prefixIcon:
                                    const Icon(Icons.phone, color: Colors.white70),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                      const BorderSide(color: Colors.white54),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(color: Colors.white),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  keyboardType: TextInputType.phone,
                                  onSaved: (value) => _phone = value ?? '',
                                ),
                                const SizedBox(height: 16),

                                // Password
                                TextFormField(
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    labelText: 'Mot de passe',
                                    labelStyle: const TextStyle(color: Colors.white70),
                                    prefixIcon:
                                    const Icon(Icons.lock, color: Colors.white70),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                      const BorderSide(color: Colors.white54),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(color: Colors.white),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  obscureText: true,
                                  onSaved: (value) => _password = value ?? '',
                                ),
                                const SizedBox(height: 32),

                                // Save button
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                      Colors.white.withOpacity(0.25),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: _saveProfile,
                                    child: const Text(
                                      'Enregistrer',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Fills remaining space to avoid white bottom
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
