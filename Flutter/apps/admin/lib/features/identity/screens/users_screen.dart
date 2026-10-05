import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../dashboard/models/admin_models.dart';
import '../api/identity_api.dart';

/// Staff users: list + create + set roles.
class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _roles = TextEditingController(text: 'ROLE_CASHIER');
  List<ManagedUser> _users = const <ManagedUser>[];
  String? _message;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _password.dispose();
    _roles.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final users = await GetIt.instance<IdentityApi>().users();
      setState(() {
        _users = users;
        _message = null;
      });
    } on Exception catch (e) {
      setState(() => _message = e.toString());
    }
  }

  Future<void> _create() async {
    try {
      await GetIt.instance<IdentityApi>().createUser(
        fullName: _name.text.trim(),
        phone: _phone.text.trim(),
        password: _password.text,
        roles: _roles.text
            .split(',')
            .map((r) => r.trim())
            .where((r) => r.isNotEmpty)
            .toList(),
      );
      setState(() => _message = 'Created');
      await _load();
    } on Exception catch (e) {
      setState(() => _message = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Full name'),
            ),
            TextField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Phone'),
            ),
            TextField(
              controller: _password,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            TextField(
              controller: _roles,
              decoration: const InputDecoration(
                labelText: 'Roles (comma separated)',
              ),
            ),
            ElevatedButton(
              onPressed: _create,
              child: const Text('Create user'),
            ),
            if (_message != null) Text(_message!),
            Expanded(
              child: ListView.builder(
                itemCount: _users.length,
                itemBuilder: (context, i) {
                  final u = _users[i];
                  return ListTile(
                    title: Text(u.fullName),
                    subtitle: Text('${u.phone} • ${u.roles.join(', ')}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
