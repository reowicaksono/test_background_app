import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:test_background_service/app/routes/app_routes_name.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  Calender calenderView = Calender.day;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(24),
        child: ListView(
          children: [
            // segmented button
            SegmentedButton<Calender>(
              segments: const <ButtonSegment<Calender>>[
                ButtonSegment<Calender>(
                  value: Calender.day,
                  label: Text('Day'),
                  icon: Icon(Icons.calendar_view_day),
                ),
                ButtonSegment<Calender>(
                  value: Calender.week,
                  label: Text('Week'),
                  icon: Icon(Icons.calendar_view_week),
                ),
                ButtonSegment<Calender>(
                  value: Calender.month,
                  label: Text('Week'),
                  icon: Icon(Icons.calendar_view_month),
                ),
                ButtonSegment<Calender>(
                  value: Calender.year,
                  label: Text('Year'),
                  icon: Icon(Icons.calendar_today),
                ),
              ],
              selected: <Calender>{calenderView},
              onSelectionChanged: (Set<Calender> newSelection) {
                setState(() {
                  calenderView = newSelection.first;
                });
              },
            ),
            // chio
            SizedBox(height: 24),
            SizedBox(
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 4,
                children: [
                  Chip(
                    avatar: CircleAvatar(
                      backgroundImage: NetworkImage(
                        'https://cache.lahelu.com/thumbnail-PKzWM0FJ9-55851',
                      ),
                    ),
                    label: Text('hidup jokowi'),
                  ),
                  Chip(
                    avatar: CircleAvatar(
                      backgroundImage: NetworkImage(
                        'https://cache.lahelu.com/thumbnail-PKzWM0FJ9-55851',
                      ),
                    ),
                    label: Text('hidup blonde'),
                  ),
                  Chip(
                    avatar: CircleAvatar(
                      backgroundImage: NetworkImage(
                        'https://cache.lahelu.com/thumbnail-PKzWM0FJ9-55851',
                      ),
                    ),
                    label: Text('hidup windah batubara'),
                  ),
                  Chip(
                    avatar: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(
                        'https://cache.lahelu.com/thumbnail-PKzWM0FJ9-55851',
                      ),
                      backgroundColor: Colors.black,
                    ),
                    label: Text('hidup sawit'),
                  ),
                ],
              ),
            ),
            // button text
            SizedBox(height: 24),
            TextButton(
              onPressed: () => context.push(AppRoutesName.transaction),
              child: Text(
                "Go to Transaction",
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum Calender { day, week, month, year }
