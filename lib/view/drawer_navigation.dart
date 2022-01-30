import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parkang_admin/shared/shared_code.dart';
import 'package:parkang_admin/view/admins.dart';
import 'package:parkang_admin/view/login.dart';
import 'package:parkang_admin/view/orders.dart';
import 'package:parkang_admin/view/products.dart';

class DrawerNavigation extends StatefulWidget {
  const DrawerNavigation({Key? key}) : super(key: key);

  @override
  _DrawerNavigationState createState() => _DrawerNavigationState();
}

class _DrawerNavigationState extends State<DrawerNavigation> {
  final List<Widget> _widgets = [
    const Orders(),
    const Products(),
    const Admins()
  ];
  final List<String> _titles = ['O R D E R S', 'P R O D U C T S', 'A D M I N S'];
  int _selectedIndex = 0;
  final String _userName = 'Admin';
  final String _userEmail = 'admin@gmail.com';

  void _switchPage(int index) {
    setState(() {
      _selectedIndex = index;
      Navigator.pop(context);
    });
  }

  void _logout() {
    SharedCode.showConfirmationDialog(context, 'Logout', 'Are you sure?', () => SharedCode.navigatorPushAndRemoveUntil(context, const Login()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgets[_selectedIndex],
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            _drawerHeader(),
            _drawerItem(0, 'Orders', Icons.shopping_bag),
            _drawerItem(1, 'Products', Icons.storefront),
            _drawerItem(2, 'Admins', Icons.person),
            _drawerItem(-1, 'Logout', Icons.exit_to_app),
          ],
        ),
      ),
    );
  }

  Widget _drawerHeader() {
    return UserAccountsDrawerHeader(
      accountName: Text(_userName, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),),
      accountEmail: Text(_userEmail, style: GoogleFonts.poppins(color: Colors.white),),
    );
  }

  Widget _drawerItem(int index, String text, IconData icon) {
    Color color = Colors.grey.shade700;
    if (_selectedIndex == index) {
      color = Theme.of(context).primaryColor;
    }

    return InkWell(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 15.0),
            Text(text, style: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: color)),
          ],
        ),
      ),
      onTap: index != -1 ? () => _switchPage(index) : () => _logout(),
    );
  }
}
