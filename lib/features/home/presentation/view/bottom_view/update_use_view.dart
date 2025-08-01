import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:servzz/app/service_locator/service_locator.dart';
import 'package:servzz/common/my_snack_bar.dart';
import 'package:servzz/features/auth/domain/entity/user_entity.dart';
import 'package:servzz/features/auth/domain/use_case/update_user_usecase.dart';
import 'package:servzz/features/home/presentation/view_model/update_viewmodel/update_event.dart';
import 'package:servzz/features/home/presentation/view_model/update_viewmodel/update_state.dart';
import 'package:servzz/features/home/presentation/view_model/update_viewmodel/update_viewmodel.dart';

class UpdateUserView extends StatelessWidget {
  final UserEntity currentUser;

  const UpdateUserView({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => UpdateUserViewModel(
            updateUserUsecase: serviceLocator<UpdateUserUsecase>(),
          )..add(InitializeUserDataEvent(currentUser)),
      child: UpdateUserForm(currentUser: currentUser),
    );
  }
}

class UpdateUserForm extends StatelessWidget {
  final UserEntity currentUser;
  final _formKey = GlobalKey<FormState>();

  UpdateUserForm({super.key, required this.currentUser});

  Future<void> _pickImage(BuildContext context) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (image != null) {
        context.read<UpdateUserViewModel>().add(
          UpdateProfileImageEvent(File(image.path)),
        );
      }
    } catch (e) {
      showMySnackBar(
        context: context,
        message: 'Failed to pick image: $e',
        color: Colors.red,
      );
    }
  }

  void _updateUser(BuildContext context, UpdateUserState state) {
    if (_formKey.currentState!.validate()) {
      final updatedUser = UserEntity(
        userId: currentUser.userId,
        firstName: state.firstName,
        lastName: state.lastName,
        username: state.username,
        email: state.email,
        phone: state.phone,
        role: currentUser.role,
        image: currentUser.image,
      );

      context.read<UpdateUserViewModel>().add(
        SubmitUpdateUserEvent(
          userData: updatedUser,
          profileImage: state.selectedImage,
          context: context,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Profile'),

        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<UpdateUserViewModel, UpdateUserState>(
        listener: (context, state) {
          if (state.isSuccess) {
            showMySnackBar(
              context: context,
              message: 'Profile updated successfully!',
              color: Colors.green,
            );
            Navigator.pop(context, true);
          }

          if (state.hasError) {
            showMySnackBar(
              context: context,
              message: state.error ?? 'Failed to update profile',
              color: Colors.red,
            );
          }
        },
        builder: (context, state) {
          return Center(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isTablet ? 600 : double.infinity,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 32,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Profile image section
                        GestureDetector(
                          onTap: () => _pickImage(context),
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.grey[300],
                                backgroundImage:
                                    state.selectedImage != null
                                        ? FileImage(state.selectedImage!)
                                        : (currentUser.image != null &&
                                            currentUser.image!.isNotEmpty)
                                        ? NetworkImage(
                                          'http://10.0.2.2:5050/${currentUser.image!.replaceAll('\\', '/')}',
                                        )
                                        : null,
                                child:
                                    (state.selectedImage == null &&
                                            (currentUser.image == null ||
                                                currentUser.image!.isEmpty))
                                        ? Icon(
                                          Icons.person,
                                          size: 60,
                                          color: Colors.grey[700],
                                        )
                                        : null,
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    color: Colors.blue,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          'Tap to change profile picture',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Form fields
                        Card(
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        initialValue: state.firstName,
                                        decoration: const InputDecoration(
                                          labelText: 'First Name',
                                          border: OutlineInputBorder(),
                                          prefixIcon: Icon(Icons.person),
                                        ),
                                        onChanged: (value) {
                                          context
                                              .read<UpdateUserViewModel>()
                                              .add(UpdateFirstNameEvent(value));
                                        },
                                        validator: (value) {
                                          if (value == null ||
                                              value.trim().isEmpty) {
                                            return 'First name is required';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: TextFormField(
                                        initialValue: state.lastName,
                                        decoration: const InputDecoration(
                                          labelText: 'Last Name',
                                          border: OutlineInputBorder(),
                                          prefixIcon: Icon(
                                            Icons.person_outline,
                                          ),
                                        ),
                                        onChanged: (value) {
                                          context
                                              .read<UpdateUserViewModel>()
                                              .add(UpdateLastNameEvent(value));
                                        },
                                        validator: (value) {
                                          if (value == null ||
                                              value.trim().isEmpty) {
                                            return 'Last name is required';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 16),

                                TextFormField(
                                  initialValue: state.username,
                                  decoration: const InputDecoration(
                                    labelText: 'Username',
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.alternate_email),
                                  ),
                                  onChanged: (value) {
                                    context.read<UpdateUserViewModel>().add(
                                      UpdateUsernameEvent(value),
                                    );
                                  },
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Username is required';
                                    }
                                    return null;
                                  },
                                ),

                                const SizedBox(height: 16),

                                TextFormField(
                                  initialValue: state.email,
                                  decoration: const InputDecoration(
                                    labelText: 'Email',
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.email),
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  onChanged: (value) {
                                    context.read<UpdateUserViewModel>().add(
                                      UpdateEmailEvent(value),
                                    );
                                  },
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Email is required';
                                    }
                                    if (!RegExp(
                                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                    ).hasMatch(value)) {
                                      return 'Please enter a valid email';
                                    }
                                    return null;
                                  },
                                ),

                                const SizedBox(height: 16),

                                TextFormField(
                                  initialValue: state.phone,
                                  decoration: const InputDecoration(
                                    labelText: 'Phone',
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.phone),
                                  ),
                                  keyboardType: TextInputType.phone,
                                  onChanged: (value) {
                                    context.read<UpdateUserViewModel>().add(
                                      UpdatePhoneEvent(value),
                                    );
                                  },
                                  validator: (value) {
                                    if (value != null &&
                                        value.trim().isNotEmpty) {
                                      if (!RegExp(
                                        r'^\+?[\d\s-()]+$',
                                      ).hasMatch(value)) {
                                        return 'Please enter a valid phone number';
                                      }
                                    }
                                    return null;
                                  },
                                ),

                                const SizedBox(height: 16),

                                // Role display (read-only)
                                TextFormField(
                                  initialValue: currentUser.role ?? 'N/A',
                                  decoration: const InputDecoration(
                                    labelText: 'Role',
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.work),
                                  ),
                                  enabled: false,
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Update button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed:
                                state.isLoading
                                    ? null
                                    : () => _updateUser(context, state),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child:
                                state.isLoading
                                    ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                      ),
                                    )
                                    : const Text(
                                      'Update Profile',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
