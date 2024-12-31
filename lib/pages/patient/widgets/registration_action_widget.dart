import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:test_rsud_arifin_achmad/models/registration_mcu_model.dart';

class RegistrationActions extends StatelessWidget {
  final RegisterMCUModel registration;
  final Function(String status) onStatusChanged;

  const RegistrationActions({
    super.key,
    required this.registration,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: _buildActionButton(
            context: context,
            color: Colors.green,
            label: 'Approve',
            status: 'Approved',
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildActionButton(
            context: context,
            color: Colors.red,
            label: 'Reject',
            status: 'Rejected',
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required Color color,
    required String label,
    required String status,
  }) {
    return ElevatedButton(
      onPressed: () => _confirmStatusChange(context, status),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 3,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  void _confirmStatusChange(BuildContext context, String status) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Confirm $status',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.close,
                  color: Colors.grey,
                ),
              )
            ],
          ),
          content: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              'Are you sure you want to mark ${registration.name} as $status?',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
          ),
          actions: <Widget>[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      status == 'Approved' ? Colors.green : Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  _changeStatus(context, status);
                },
                child: Text(
                  status,
                  style: const TextStyle(
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

  void _changeStatus(BuildContext context, String status) {
    log("$status registration: ${registration.name}");

    onStatusChanged(status);

    final String message =
        '${registration.name} has been $status successfully!';

    final snackBar = SnackBar(
      content: Text(
        message,
      ),
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.green.shade700,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(10),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
