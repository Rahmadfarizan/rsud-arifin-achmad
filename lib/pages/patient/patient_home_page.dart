import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_rsud_arifin_achmad/business_logic/register_mcu_bloc.dart';
import 'package:test_rsud_arifin_achmad/models/registration_mcu_model.dart';
import 'package:test_rsud_arifin_achmad/pages/login/login_page.dart';
import 'package:test_rsud_arifin_achmad/pages/patient/registration_mcu_detail_page.dart';
import 'package:test_rsud_arifin_achmad/pages/patient/registration_mcu_page.dart';

class PatientHomePage extends StatefulWidget {
  const PatientHomePage({super.key});

  @override
  State<PatientHomePage> createState() => _PatientHomePageState();
}

class _PatientHomePageState extends State<PatientHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RegistrationBloc>().add(LoadRegistrationsEvent());
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log('Navigated to Patient Home');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Home'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          labelColor: Colors.white,
          dividerColor: Colors.white,
          indicatorColor: Colors.white,
          unselectedLabelColor: Colors.white.withOpacity(0.5),
          controller: _tabController,
          tabs: const [
            Tab(text: 'Pending'),
            Tab(text: 'Approved'),
            Tab(text: 'Rejected'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              bool? confirmLogout = await _showLogoutDialog(context);
              if (confirmLogout == true && context.mounted) {
                log('Logging out...');

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => LoginPage()),
                );
              }
            },
          ),
        ],
      ),
      body: BlocBuilder<RegistrationBloc, RegistrationState>(
        builder: (context, state) {
          if (state is RegistrationLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is RegistrationLoaded) {
            return TabBarView(
              controller: _tabController,
              children: [
                _buildRegistrationList(List.from(state.registrations
                    .where((reg) => reg.status == 'Pending'))),
                _buildRegistrationList(List.from(state.registrations
                    .where((reg) => reg.status == 'Approved'))),
                _buildRegistrationList(List.from(state.registrations
                    .where((reg) => reg.status == 'Rejected'))),
              ],
            );
          } else if (state is RegistrationError) {
            return Center(
                child: Text(
              'Error: ${state.message}',
              textAlign: TextAlign.center,
            ));
          }
          return const Center(child: Text('No registrations available.'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        onPressed: () async {
          log('Navigating to Registration Form');
          Navigator.push<RegisterMCUModel>(
            context,
            MaterialPageRoute(builder: (_) => RegistrationForm()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<bool?> _showLogoutDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Log Out'),
              IconButton(
                onPressed: () => Navigator.of(context).pop(false),
                icon: const Icon(
                  Icons.close,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text(
                  'Log Out',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRegistrationList(List<RegisterMCUModel> registrations) {
    return registrations.isEmpty
        ? const Center(child: Text('No registrations found'))
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: registrations.length,
            itemBuilder: (context, index) {
              final registration = registrations[index];
              log('Displaying registration: ${registration.toJson()}');
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(
                    registration.type ?? '-',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    'Date: ${registration.date} - Status: ${registration.status}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                    color: Colors.blueGrey,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegistrationDetailPage(
                          registration: registration,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
  }
}
