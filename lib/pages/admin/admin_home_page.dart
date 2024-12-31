import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_rsud_arifin_achmad/business_logic/register_mcu_bloc.dart';
import 'package:test_rsud_arifin_achmad/pages/login/login_page.dart';
import 'package:test_rsud_arifin_achmad/pages/patient/registration_mcu_detail_page.dart';
import 'package:test_rsud_arifin_achmad/pages/patient/widgets/registration_action_widget.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage>
    with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RegistrationBloc>().add(LoadRegistrationsEvent());
    });
  }


  @override
  Widget build(BuildContext context) {
    return
        
        

        BlocBuilder<RegistrationBloc, RegistrationState>(
            builder: (context, state) {
      return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Admin Home'),
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
            elevation: 0,
            bottom: TabBar(
              labelColor: Colors.white,
              dividerColor: Colors.white,
              indicatorColor: Colors.white,
              unselectedLabelColor: Colors.white.withOpacity(0.5),
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
                  final confirmLogout = await _showLogoutDialog(context);
                  if (confirmLogout == true) {
                    if (context.mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => LoginPage()),
                      );
                    }
                  }
                },
              ),
            ],
          ),
          body: const TabBarView(
            children: [
              StatusListView(status: 'Pending'),
              StatusListView(status: 'Approved'),
              StatusListView(status: 'Rejected'),
            ],
          ),
        ),
      );
    });
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
              )
            ],
          ),
          content: const Text('Are you sure you want to log out?'),
          actions: <Widget>[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
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
}

class StatusListView extends StatelessWidget {
  final String status;

  const StatusListView({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationBloc, RegistrationState>(
      builder: (context, state) {
        if (state is RegistrationLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is RegistrationLoaded) {
          final registrations =
              state.registrations.where((r) => r.status == status).toList();
          for (int i = 0; i < registrations.length; i++) {
            log(registrations[i].toJson().toString());
          }

          if (registrations.isEmpty) {
            return Center(child: Text('No $status registrations available.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: registrations.length,
            itemBuilder: (context, index) {
              final registration = registrations[index];
              return Column(
                children: [
                  InkWell(
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
                    child: SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 6,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  registration.name ?? '-',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${registration.type} - ${registration.date}',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                const SizedBox(height: 8),
                                if (status == 'Pending')
                                  RegistrationActions(
                                    registration: registration,
                                    onStatusChanged: (newStatus) {
                                      context.read<RegistrationBloc>().add(
                                            UpdateRegistrationStatusEvent(
                                                registration, newStatus),
                                          );
                                    },
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
