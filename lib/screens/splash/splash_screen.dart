import 'package:flutter/material.dart';
import 'package:todo_app/screens/signin/signin_screen.dart';
import 'package:todo_app/screens/signup/signup_screen.dart';
import 'package:todo_app/screens/splash/splash_pages/splash_one.dart';
import 'package:todo_app/screens/splash/splash_pages/splash_three.dart';
import 'package:todo_app/screens/splash/splash_pages/splash_two.dart';
import 'package:todo_app/widgets/components/activy_logo/activy_logo.dart';
import 'package:todo_app/widgets/components/button/button_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final PageController _splashController = PageController(initialPage: 0);

  int _activeSplash = 0;

  final List<Widget> _splashPages = [
    const SplashOne(),
    const SplashTwo(),
    const SplashThree(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      primary: false,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 24,
            ),
            const ActivyLogo(),
            Expanded(
              child: PageView.builder(
                controller: _splashController,
                onPageChanged: (page) {
                  setState(() {
                    _activeSplash = page;
                  });
                },
                itemCount: _splashPages.length,
                itemBuilder: (context, index) {
                  return _splashPages[index % _splashPages.length];
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List<Widget>.generate(
                _splashPages.length,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: InkWell(
                    onTap: () {
                      _splashController.animateToPage(index,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeIn);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      height: 8,
                      width: _activeSplash == index ? 18 : 8,
                      decoration: BoxDecoration(
                          color: _activeSplash == index
                              ? Colors.amber
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(100)),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              child: Column(
                children: [
                  Button(
                    loading: false,
                    title: "Let's create an account!",
                    onPress: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpScreen(),
                          ));
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account?"),
                      const SizedBox(
                        width: 4,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignInScreen(),
                              ));
                        },
                        child: Text(
                          "Sign in",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.surfaceTint),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
