import 'package:flutter/material.dart';
import 'package:logger/web.dart';
import 'package:progress_pals/core/theme/app_colors.dart';
import 'package:progress_pals/presentation/viewmodels/home_viewmodel.dart';
import 'package:progress_pals/presentation/widgets/date_bubble.dart';
import 'package:provider/provider.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HomeViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: const Text("Today", style: TextStyle(color: Colors.black, fontSize: 32, fontWeight: FontWeight.bold)),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Logger().i("Add a habit");
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(180),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(viewModel.weekDays.length, (index) {
                return DateBubble(
                  label: viewModel.weekDays[index],
                  isSelected: index == viewModel.currentDayIndex,
                );
              }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(100.0),
            child: Center(child: Text("Home")),
          ),
        ],
      ),
    );
  }
}
