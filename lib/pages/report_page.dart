import 'package:coa_progress_tracking_app/pages/emotion_viewer_page.dart';
import 'package:coa_progress_tracking_app/pages/health_page.dart';
import 'package:coa_progress_tracking_app/pages/progress_page.dart';
import 'package:coa_progress_tracking_app/utilities/app_bar_wrapper.dart';
import 'package:flutter/material.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {

  @override
  Widget build(BuildContext context) {

    return const DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBarWrapper(
            title: "Reports",
            fontSize: 25,
            bottom: TabBar(
              tabs: [
                Tab(text: "Progress",),
                Tab(text: "Emotions",),
                Tab(text: "Health"),
              ],
              labelColor: Color(0xFFEADDC8),
            ),
          ),
          body: TabBarView(
            children: [
              // Show the Progress and Health pages for the tabs
              ProgressPage(),
              EmotionViewerPage(),
              HealthPage(),
            ],
          ),
        ));
  }
}