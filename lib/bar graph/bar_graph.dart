import "package:expense_tracker/bar%20graph/individual_bar.dart";
import "package:fl_chart/fl_chart.dart";
import "package:flutter/material.dart";

class MyBargraph extends StatefulWidget {
  final List<double> monthlySummary;
  final int startMonth;
  const MyBargraph(
      {super.key, required this.monthlySummary, required this.startMonth});

  @override
  State<MyBargraph> createState() => _MyBargraphState();
}

class _MyBargraphState extends State<MyBargraph> {
  List<IndividuaBar> barData = [];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => scrollToEnd);
  }

  void initializeBarData() {
    barData = List.generate(
      widget.monthlySummary.length,
      (index) => IndividuaBar(x: index, y: widget.monthlySummary[index]),
    );
  }

// calculate max for upper limit of graph
  double calculateMax() {
    double max = 500;
    widget.monthlySummary.sort();
    max = widget.monthlySummary.last * 1.05;
    if (max < 500) {
      return 500;
    }
    return max;
  }

// scroll controller to make sure it scrolls to the end
  final ScrollController _scrollController = ScrollController();
  void scrollToEnd() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 1), curve: Curves.bounceIn);
  }

  @override
  Widget build(BuildContext context) {
    initializeBarData();
    double barWidth = 20;
    double spaceBetweenBars = 15;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: _scrollController,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: SizedBox(
          width: barWidth * barData.length +
              spaceBetweenBars * (barData.length - 1),
          child: BarChart(
            BarChartData(
              minY: 0,
              maxY: calculateMax(),
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              titlesData: const FlTitlesData(
                show: true,
                topTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: getBottomTitles,
                    reservedSize: 24,
                  ),
                ),
              ),
              barGroups: barData
                  .map(
                    (data) => BarChartGroupData(
                      x: data.x,
                      barRods: [
                        BarChartRodData(
                            toY: data.y,
                            width: barWidth,
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.grey,
                            backDrawRodData: BackgroundBarChartRodData(
                                show: true,
                                toY: calculateMax(),
                                color: Colors.white
                            )
                        )
                      ],
                    ),
                  )
                  .toList(),
              alignment: BarChartAlignment.center,
              groupsSpace: spaceBetweenBars,
            ),
          ),
        ),
      ),
    );
  }
}

Widget getBottomTitles(double value, TitleMeta meta) {
  const texxtstyle = TextStyle(
    color: Colors.grey,
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );
  String text;
  switch (value.toInt() % 12) {
    case 0:
      text = 'A';
      break;
    case 1:
      text = 'B';
      break;
    case 2:
      text = 'C';
      break;
    case 3:
      text = 'D';
      break;
    case 4:
      text = 'E';
      break;
    case 5:
      text = 'F';
      break;
    case 6:
      text = 'G';
      break;
    case 7:
      text = 'H';
      break;
    case 8:
      text = 'K';
      break;
    case 9:
      text = 'L';
      break;
    case 10:
      text = 'M';
      break;
    case 11:
      text = 'N';
      break;

    default:
      text = '';
      break;
  }
  return SideTitleWidget(
      child: Text(
        text,
        style: texxtstyle,
      ),
      axisSide: meta.axisSide);
}
