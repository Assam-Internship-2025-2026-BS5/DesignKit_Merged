import 'package:flutter/material.dart';

class Header extends StatefulWidget {
  final String userName;
  final String customerId;
  final List<String>? customerIds;
  final String logoPath;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;
  final ValueChanged<String>? onIdChanged;
  final Color textColor;
  final List<Color> notificationGradient;

  const Header({
    super.key,
    required this.userName,
    required this.customerId,
    this.customerIds,
    required this.logoPath,
    this.onNotificationTap,
    this.onProfileTap,
    this.onIdChanged,
    this.textColor = Colors.black,
    this.notificationGradient = const [Color(0xFFF97316), Color(0xFFFACC15)],
  });

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  late String _selectedId;

  @override
  void initState() {
    super.initState();
    _selectedId = widget.customerId;
  }

  @override
  void didUpdateWidget(Header oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.customerId != widget.customerId) {
      setState(() {
        _selectedId = widget.customerId;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> idList = List<String>.from(widget.customerIds ?? [_selectedId]);
    if (!idList.contains(_selectedId)) {
      idList.insert(0, _selectedId);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo Row
          GestureDetector(
            onTap: () => debugPrint("Logo Tapped"),
            child: SizedBox(
              width: 150,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  widget.logoPath,
                  height: 22,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Text(
                    "BRAND LOGO",
                    style: TextStyle(
                      color: widget.textColor.withOpacity(0.8),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // User Info & Notification Integrated
          GestureDetector(
            onTap: widget.onProfileTap,
            behavior: HitTestBehavior.opaque,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hello,",
                          style: TextStyle(
                            fontSize: 14,
                            color: widget.textColor.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.userName.toUpperCase(),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: widget.textColor,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: widget.onNotificationTap,
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: widget.notificationGradient,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: const Icon(
                          Icons.notifications_none_outlined,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          // ID Dropdown
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedId,
              isDense: true,
              icon: Icon(
                Icons.keyboard_arrow_down,
                size: 16,
                color: widget.textColor.withOpacity(0.54),
              ),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedId = newValue;
                  });
                  if (widget.onIdChanged != null) {
                    widget.onIdChanged!(newValue);
                  }
                }
              },
              items: idList.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    "ID $value",
                    style: TextStyle(
                      fontSize: 13,
                      color: widget.textColor.withOpacity(0.6),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

