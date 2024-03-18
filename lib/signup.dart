import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logging/logging.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: const Center(
        child: SizedBox(
          width: 400,
          child: Card(
            child: SignUpForm(),
          ),
        ),
      ),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Welcome!',
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final Logger log = Logger('_SignUpFormState');

  final _firstNameTextController = TextEditingController();
  final _lastNameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  double _formProgress = 0;

  void _completeSignUp() {
    try {
      final _ = FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailTextController.text,
        password: _passwordTextController.text,
      );
      Navigator.popAndPushNamed(context, '/welcome');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        log.warning('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        log.warning('The account already exists for that email.');
      } else if (e.code == 'invalid-email') {
        log.warning('The email provided is invalid.');
      } else if (e.code == "operation-not-allowed") {
        log.warning('Email/password accounts are not enabled.');
      } else {
        log.severe(e.code);
      }
    } catch (e, s) {
      log.info(s);
      log.severe(e);
    }
  }

  void _updateFormProgress() {
    var progress = 0.0;
    final controllers = [
      _firstNameTextController,
      _lastNameTextController,
      _emailTextController,
      _passwordTextController,
    ];

    for (final controller in controllers) {
      if (controller.value.text.isNotEmpty) {
        progress += 1 / controllers.length;
      }
    }

    setState(() {
      _formProgress = progress;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      onChanged: _updateFormProgress,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LinearProgressIndicator(value: _formProgress),
          Text('Sign up', style: Theme.of(context).textTheme.headlineMedium),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _firstNameTextController,
              decoration: const InputDecoration(hintText: 'First name'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _lastNameTextController,
              decoration: const InputDecoration(hintText: 'Last name'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _emailTextController,
              decoration: const InputDecoration(hintText: 'Email'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _passwordTextController,
              decoration: const InputDecoration(hintText: 'Password'),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.resolveWith((states) {
                  return states.contains(MaterialState.disabled)
                      ? null
                      : Colors.white;
                }),
                backgroundColor: MaterialStateProperty.resolveWith((states) {
                  return states.contains(MaterialState.disabled)
                      ? null
                      : Colors.blue;
                }),
              ),
              onPressed: _formProgress == 1 ? _completeSignUp : null,
              child: const Text('Sign up'),
            ),
          ),
        ],
      ),
    );
  }
}
