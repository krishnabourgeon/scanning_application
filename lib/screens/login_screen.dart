// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/auth_provider.dart';
// import '../services/helpers.dart';
// import '../services/provider_helper_class.dart';
// import '../services/validation_helper.dart';
// import '../theme/app_theme.dart';
// import 'dashboard_screen.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   bool _obscure = true;

//   void _submit(AuthProvider auth) {
//     if (!auth.isLoginFormValidated) return;
//     auth.login(
//       onSuccess: () {
//         if (!mounted) return;
//         Navigator.of(context).pushReplacement(
//           MaterialPageRoute(builder: (_) => const DashboardScreen()),
//         );
//       },
//       onFailure: () {
//         if (auth.errorToast != null) Helpers.errorToast(auth.errorToast!);
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final auth = context.watch<AuthProvider>();
//     final isLoading = auth.loaderState == LoaderState.loading;

//     return Scaffold(
//       backgroundColor: AppColors.cream,
//       body: SafeArea(
//         child: Center(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(16),
//                   child: Image.asset(
//                     'assets/images/logo.jpeg',
//                     height: 130,
//                     fit: BoxFit.contain,
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 Text(
//                   'Volunteer Check-in',
//                   textAlign: TextAlign.center,
//                   style: Theme.of(context).textTheme.headlineSmall,
//                 ),
//                 const SizedBox(height: 4),
//                 const Text(
//                   'Sign in to manage event attendance',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(color: AppColors.muted, fontSize: 13),
//                 ),
//                 const SizedBox(height: 32),
//                 TextField(
//                   controller: auth.loginNameController,
//                   textInputAction: TextInputAction.next,
//                   onChanged: (v) => auth.updateValidationMessages(
//                     validationType: ValidationTypes.userName,
//                     validationMessage:
//                         ValidationHelperClass.validateName(v) ?? '',
//                   ),
//                   decoration: InputDecoration(
//                     labelText: 'Username',
//                     prefixIcon: const Icon(Icons.person_outline,
//                         color: AppColors.brown),
//                     errorText: auth.userNameValidationMessage,
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 TextField(
//                   controller: auth.loginPasswordController,
//                   obscureText: _obscure,
//                   textInputAction: TextInputAction.done,
//                   onChanged: (v) => auth.updateValidationMessages(
//                     validationType: ValidationTypes.password,
//                     validationMessage:
//                         ValidationHelperClass.validatePassword(v) ?? '',
//                   ),
//                   onSubmitted: (_) => _submit(auth),
//                   decoration: InputDecoration(
//                     labelText: 'Password',
//                     prefixIcon:
//                         const Icon(Icons.lock_outline, color: AppColors.brown),
//                     errorText: auth.passwordValidationMessage,
//                     suffixIcon: IconButton(
//                       icon: Icon(
//                         _obscure
//                             ? Icons.visibility_off_outlined
//                             : Icons.visibility_outlined,
//                         color: AppColors.muted,
//                       ),
//                       onPressed: () => setState(() => _obscure = !_obscure),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Checkbox(
//                       value: auth.isRememberCredentials,
//                       activeColor: AppColors.brown,
//                       onChanged: (v) =>
//                           auth.updateRememberMeValue(v ?? false),
//                     ),
//                     const Text(
//                       'Remember me',
//                       style: TextStyle(color: AppColors.muted, fontSize: 13),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: (isLoading || !auth.isLoginFormValidated)
//                       ? null
//                       : () => _submit(auth),
//                   child: isLoading
//                       ? const SizedBox(
//                           height: 20,
//                           width: 20,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2.2,
//                             valueColor:
//                                 AlwaysStoppedAnimation<Color>(Colors.white),
//                           ),
//                         )
//                       : const Text('Log In'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }




import 'package:adwaitha_sangamam/providers/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/helpers.dart';
import '../services/provider_helper_class.dart';
import '../services/validation_helper.dart';
import '../theme/app_theme.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscure = true;
  int? _selectedEventId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EventProvider>().getEvents();
    });
  }

  bool _canSubmit(AuthProvider auth) =>
      auth.isLoginFormValidated && _selectedEventId != null;

  void _submit(AuthProvider auth) {
    if (!_canSubmit(auth)) return;
    auth.login(
      eventId: _selectedEventId!,
      onSuccess: () {
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const DashboardScreen()),
        );
      },
      onFailure: () {
        if (auth.errorToast != null) Helpers.errorToast(auth.errorToast!);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final eventProvider = context.watch<EventProvider>();
    final events = eventProvider.eventsList;
    final isLoading = auth.loaderState == LoaderState.loading;
    final eventsLoading = eventProvider.loaderState == LoaderState.loading;
    final eventsError = eventProvider.loaderState == LoaderState.error ||
        eventProvider.loaderState == LoaderState.networkErr;

    // Guard against a stale selection after the list refreshes.
    final selectedId =
        events.any((e) => e.id == _selectedEventId) ? _selectedEventId : null;

    final String hintText = eventsLoading
        ? 'Loading events...'
        : eventsError
            ? 'Failed to load events'
            : events.isEmpty
                ? 'No events available'
                : 'Select event';

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'assets/images/logo.jpeg',
                    height: 130,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Volunteer Check-in',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 4),
                const Text(
                  'Sign in to manage event attendance',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.muted, fontSize: 13),
                ),
                const SizedBox(height: 32),
                DropdownButtonFormField<int>(
                  value: selectedId,
                  isExpanded: true,
                  icon: eventsLoading
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.brown,
                          ),
                        )
                      : eventsError
                          ? GestureDetector(
                              onTap: () =>
                                  context.read<EventProvider>().getEvents(),
                              child: const Icon(Icons.refresh_rounded,
                                  color: AppColors.rust),
                            )
                          : const Icon(Icons.keyboard_arrow_down_rounded,
                              color: AppColors.muted),
                  hint: Text(hintText),
                  items: events
                      .map(
                        (e) => DropdownMenuItem<int>(
                          value: e.id,
                          child: Text(
                            (e.title != null && e.title.trim().isNotEmpty)
                                ? e.title
                                : e.name,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (isLoading || events.isEmpty)
                      ? null
                      : (v) => setState(() => _selectedEventId = v),
                  decoration: const InputDecoration(
                    prefixIcon:
                        Icon(Icons.event_outlined, color: AppColors.brown),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: auth.loginNameController,
                  textInputAction: TextInputAction.next,
                  onChanged: (v) => auth.updateValidationMessages(
                    validationType: ValidationTypes.userName,
                    validationMessage:
                        ValidationHelperClass.validateName(v) ?? '',
                  ),
                  decoration: InputDecoration(
                    labelText: 'Username',
                    prefixIcon: const Icon(Icons.person_outline,
                        color: AppColors.brown),
                    errorText: auth.userNameValidationMessage,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: auth.loginPasswordController,
                  obscureText: _obscure,
                  textInputAction: TextInputAction.done,
                  onChanged: (v) => auth.updateValidationMessages(
                    validationType: ValidationTypes.password,
                    validationMessage:
                        ValidationHelperClass.validatePassword(v) ?? '',
                  ),
                  onSubmitted: (_) => _submit(auth),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon:
                        const Icon(Icons.lock_outline, color: AppColors.brown),
                    errorText: auth.passwordValidationMessage,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscure
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.muted,
                      ),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                // Row(
                //   mainAxisSize: MainAxisSize.min,
                //   children: [
                //     Checkbox(
                //       value: auth.isRememberCredentials,
                //       activeColor: AppColors.brown,
                //       onChanged: (v) =>
                //           auth.updateRememberMeValue(v ?? false),
                //     ),
                //     const Text(
                //       'Remember me',
                //       style: TextStyle(color: AppColors.muted, fontSize: 13),
                //     ),
                //   ],
                // ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: (isLoading || !_canSubmit(auth))
                      ? null
                      : () => _submit(auth),
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('Log In'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}