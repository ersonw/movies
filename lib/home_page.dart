import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies/index_page.dart';
import 'package:movies/my_prfile.dart';
import 'package:movies/news_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final songsTabKey = GlobalKey();

  Widget _buildHomePage(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const [
          // BottomNavigationBarItem(
          //   label: IndexPage.title,
          //   icon: IndexPage.iosIcon,
          // ),
          // BottomNavigationBarItem(
          //   label: NewsTab.title,
          //   icon: NewsTab.iosIcon,
          // ),
          // BottomNavigationBarItem(
          //   label: IndexPage.title,
          //   icon: IndexPage.iosIcon,
          // ),
          // BottomNavigationBarItem(
          //   label: NewsTab.title,
          //   icon: NewsTab.iosIcon,
          // ),
          BottomNavigationBarItem(
              icon: MyProfile.icon,
              label: MyProfile.title
          ),
          BottomNavigationBarItem(
            label: NewsTab.title,
            icon: NewsTab.iosIcon,
          ),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 1:
            return CupertinoTabView(
              // defaultTitle: IndexPage.title,
              builder: (context) => IndexPage(key: songsTabKey),
            );
          // case 1:
          //   return CupertinoTabView(
          //     defaultTitle: NewsTab.title,
          //     builder: (context) => const NewsTab(),
          //   );
          // case 2:
          //   return CupertinoTabView(
          //     defaultTitle: NewsTab.title,
          //     builder: (context) => const NewsTab(),
          //   );
          // case 3:
          //   return CupertinoTabView(
          //     defaultTitle: NewsTab.title,
          //     builder: (context) => const NewsTab(),
          //   );
          case 0:
            return CupertinoTabView(
              // defaultTitle: MyProfile.title,
              builder: (context) => const MyProfile(),
            );
          default:
            assert(false, 'Unexpected tab');
            return const SizedBox.shrink();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildHomePage(context);
  }
}
