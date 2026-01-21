import 'package:flutter/material.dart';
import 'package:progress_pals/core/theme/app_colors.dart';
import 'package:rive/rive.dart';

class CustomNavigationBar extends StatefulWidget {
  const CustomNavigationBar({super.key});

  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  late File file;
  late RiveWidgetController controller;
  StateMachine? stateMachine;
  NumberInput? selectedIndexInput;
  
  int selectedIndex = 0;
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    initRive();
  }

  void initRive() async {
    file = (await File.asset(
      "assets/rive/icons.riv",
      riveFactory: Factory.rive,
    ))!;
    controller = RiveWidgetController(file);
    setState(() => isInitialized = true);
  }

  @override
  void dispose() {
    file.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.dark,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppColors.dark.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          child: RiveWidget(
            controller: RiveWidgetController(
              file,
              artboardSelector: ArtboardSelector.byName("HOME"),
              stateMachineSelector: StateMachineSelector.byName(
                "HOME_interactivity",
              ),
            ),
            fit: RiveDefaults.fit,
          ),
        ),
      ),
    );

    // return RiveWidget(controller: RiveWidgetController(file, artboardSelector: ArtboardSelector.byName("HOME")), fit: RiveDefaults.fit, );
  }
}
