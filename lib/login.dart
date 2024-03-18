import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logging/logging.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  static final Logger log = Logger('LoginScreen');

  void setupAuthListener(BuildContext context) {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      // If the user is signed in then show the next page
      if (user != null) {
        Navigator.popAndPushNamed(context, '/profile');
      }
    });
  }

  Future<void> signInWithGoogle() async {
    // Create a new provider
    GoogleAuthProvider googleProvider = GoogleAuthProvider();

    googleProvider.addScope('email');
    googleProvider.setCustomParameters({
      'login_hint': 'user@example.com',
    });

    // Once signed in, return the UserCredential
    // return await FirebaseAuth.instance.signInWithPopup(googleProvider);

    // Or use signInWithRedirect
    return await FirebaseAuth.instance.signInWithRedirect(googleProvider);
  }

  Future<UserCredential> signInWithApple() async {
    final appleProvider = AppleAuthProvider();

    return await FirebaseAuth.instance.signInWithPopup(appleProvider);
  }

  @override
  Widget build(BuildContext context) {
    setupAuthListener(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.black54,
          ),
        ),
      ),
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Sign in with Google button
            SignInButton(
              Buttons.Google,
              onPressed: signInWithGoogle,
            ),
            SignInButton(
              Buttons.Apple,
              onPressed: signInWithApple,
            ),
            const SizedBox(
              width: 400,
              child: Card(
                child: LoginForm(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextButton(
                onPressed: () {
                  Navigator.popAndPushNamed(context, '/signup');
                },
                child: const Text("Don't have an account? Sign up"),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final Logger log = Logger("_LoginFormState");
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  double _formProgress = 0;

  void _completeLogin() {
    try {
      final _ = FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailTextController.text,
          password: _passwordTextController.text);
      Navigator.popAndPushNamed(context, '/welcome');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        log.warning('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        log.warning('Wrong password provided for that user.');
      }
    }
  }

  void _updateFormProgress() {
    var progress = 0.0;
    final controllers = [_emailTextController, _passwordTextController];

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
          TextButton(
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
            onPressed: _formProgress == 1 ? _completeLogin : null,
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }
}
