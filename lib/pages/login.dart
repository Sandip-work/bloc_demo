import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/blocs.dart';
import '../services/services.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: SafeArea(
          minimum: const EdgeInsets.all(16),
          child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
              final authBloc = BlocProvider.of<AuthenticationBloc>(context);
              if (state is AuthenticationNotAuthenticated) {
                return _AuthForm();
              }
              if (state is AuthenticationFailure) {
                return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(state.message),
                        ElevatedButton(
                          onPressed: () {
                            authBloc.add(AppLoaded());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                          child: const Text('Retry'),
                        )
                      ],
                    ));
              }
              // return splash screen
              return const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              );
            },
          )),
    );
  }
}

class _AuthForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = RepositoryProvider.of<AuthenticationService>(context);
    final authBloc = BlocProvider.of<AuthenticationBloc>(context);

    return Container(
      alignment: Alignment.center,
      child: BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(authBloc, authService),
        child: _SignInForm(),
      ),
    );
  }
}

class _SignInForm extends StatefulWidget {
  @override
  __SignInFormState createState() => __SignInFormState();
}

class __SignInFormState extends State<_SignInForm> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  bool _autoValidate = false;

  @override
  Widget build(BuildContext context) {
    final loginBloc = BlocProvider.of<LoginBloc>(context);

    onLoginButtonPressed() {
      if (_key.currentState!.validate()) {
        loginBloc.add(LoginInWithEmailButtonPressed(email: _emailController.text, password: _passwordController.text));
      } else {
        setState(() {
          _autoValidate = true;
        });
      }
    }

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginFailure) {
          _showError(state.error);
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          if (state is LoginLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Form(
            key: _key,
            autovalidateMode: _autoValidate ? AutovalidateMode.always : AutovalidateMode.disabled,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Email address',
                      filled: true,
                      isDense: true,
                    ),
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    validator: (value) {
                      if (value == null) {
                        return 'Email is required.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      filled: true,
                      isDense: true,
                    ),
                    obscureText: true,
                    controller: _passwordController,
                    validator: (value) {
                      if (value == null) {
                        return 'Password is required.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(borderRadius:  BorderRadius.circular(8.0)),
                    ),
                    onPressed: state is LoginLoading ? () {} : onLoginButtonPressed,

                    child: const Text('LOG IN'),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showError(String error) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(error),
      backgroundColor: Theme.of(context).errorColor,
    ));
  }
}