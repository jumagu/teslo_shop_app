import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/modules/auth/auth.dart';
import 'package:teslo_shop/modules/shared/shared.dart';

class SideMenu extends ConsumerStatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const SideMenu({super.key, required this.scaffoldKey});

  @override
  ConsumerState<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends ConsumerState<SideMenu> {
  int navDrawerIndex = 0;
  static const double paddingX = 16;
  static const double paddingY = 10;

  @override
  Widget build(BuildContext context) {
    final hasNotch = MediaQuery.of(context).viewPadding.top > 35;
    final textStyles = Theme.of(context).textTheme;

    return NavigationDrawer(
      elevation: 1,
      selectedIndex: navDrawerIndex,
      tilePadding: const EdgeInsets.symmetric(horizontal: paddingX),
      onDestinationSelected: (value) {
        setState(() {
          navDrawerIndex = value;
        });

        // final menuItem = appMenuItems[value];
        // context.push( menuItem.link );
        widget.scaffoldKey.currentState?.closeDrawer();
      },
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            paddingX,
            hasNotch ? 0 : 16,
            paddingX,
            0,
          ),
          child: Text('Teslo Shop', style: textStyles.titleMedium),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: paddingX),
          child: Text(
            'User: ${ref.watch(authNotifierProvider).user?.fullName.split(' ').first ?? ''}',
            style: textStyles.bodyLarge,
          ),
        ),

        const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: paddingX,
            vertical: paddingY,
          ),
          child: Divider(),
        ),

        const NavigationDrawerDestination(
          icon: Icon(Icons.checkroom_outlined),
          label: Text('Products'),
        ),

        const NavigationDrawerDestination(
          enabled: false,
          icon: Icon(Icons.inventory_2_outlined),
          label: Text('Orders'),
        ),

        const NavigationDrawerDestination(
          enabled: false,
          icon: Icon(Icons.people_alt_outlined),
          label: Text('Customers'),
        ),

        const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: paddingX,
            vertical: paddingY,
          ),
          child: Divider(),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: paddingX),
          child: CustomFilledButton(
            text: 'Log Out',
            onPressed: () => {
              ref.read(authNotifierProvider.notifier).startLogout(),
            },
          ),
        ),
      ],
    );
  }
}
