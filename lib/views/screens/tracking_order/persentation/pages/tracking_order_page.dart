// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hp3ki/utils/dio.dart';
import 'package:hp3ki/views/screens/tracking_order/domain/tracking_order_repository.dart';
import 'package:hp3ki/views/screens/tracking_order/persentation/provider/tracking_order_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:timelines/timelines.dart';

class TrackingOrderPage extends StatelessWidget {
  const TrackingOrderPage({super.key, required this.cnote});

  final String cnote;

  static Route go(String cnote) =>
      MaterialPageRoute(builder: (_) => TrackingOrderPage(cnote: cnote));

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider<TrackingOrderProvider>(
          create: (_) => TrackingOrderProvider(
              repo: TrackingOrderRepository(
                  client: DioManager.shared.getClient()),
              cnote: cnote)
            ..fetchTrackingOrder())
    ], child: const TrackingOrderView());
  }
}

class TrackingOrderView extends StatelessWidget {
  const TrackingOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TrackingOrderProvider>(builder: (context, notifier, child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Lacak Barang',
            style: TextStyle(fontSize: 18),
          ),
        ),
        body: SizedBox.expand(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: ProcessTimeLine(
                    tracking: notifier,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 16.0, bottom: 12),
                  child: Text(
                    'Status Pemesanan',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                  ),
                ),
                const Divider(
                  height: 1,
                  thickness: 2,
                ),
                const SizedBox(
                  height: 12,
                ),
                Timeline.tileBuilder(
                  shrinkWrap: true,
                  theme: TimelineThemeData(
                    nodePosition: 0,
                    connectorTheme: const ConnectorThemeData(
                      thickness: 3.0,
                      color: Color(0xffd3d3d3),
                    ),
                    indicatorTheme: const IndicatorThemeData(
                      size: 15.0,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  builder: TimelineTileBuilder.connected(
                    contentsBuilder: (_, __) {
                      final data = notifier.tracking!.history.reversed.toList();
                      final history = data[__];
                      final format = history.date.split(' ');
                      final date = format[0];
                      final time = format[1];
                      final dateParse = date.split('-');
                      final timeParse = time.split(':');

                      final dateTime = DateTime(
                          int.parse(dateParse[2]),
                          int.parse(dateParse[1]),
                          int.parse(
                            dateParse[0],
                          ),
                          int.parse(timeParse[0]),
                          int.parse(timeParse[1]));
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              history.desc,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              DateFormat().format(dateTime),
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    connectorBuilder: (_, index, __) {
                      if (index == 0) {
                        return SolidLineConnector(
                            color: Theme.of(context).colorScheme.primary);
                      } else {
                        return const SolidLineConnector();
                      }
                    },
                    indicatorBuilder: (_, index) {
                      if (index == 0) {
                        return DotIndicator(
                          color: Theme.of(context).colorScheme.primary,
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 10.0,
                          ),
                        );
                      }
                      return const OutlinedDotIndicator(
                        color: Color(0xffbabdc0),
                        backgroundColor: Color(0xffe6e7e9),
                      );
                    },
                    // itemExtentBuilder: (_, __) => kTileHeight,
                    itemCount: notifier.tracking?.history.length ?? 0,
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}

const kTileHeight = 50.0;

const completeColor = Color(0xff5ec792);
const inProgressColor = Color(0xff5ec792);
const todoColor = Color(0xffd1d2d7);

class ProcessTimeLine extends StatefulWidget {
  const ProcessTimeLine({
    Key? key,
    required this.tracking,
  }) : super(key: key);

  final TrackingOrderProvider tracking;

  @override
  State<ProcessTimeLine> createState() => _ProcessTimeLineState();
}

class _ProcessTimeLineState extends State<ProcessTimeLine> {
  Color getColor(int index) {
    if (index == widget.tracking.processIndex) {
      return Theme.of(context).colorScheme.primary;
    } else if (index < widget.tracking.processIndex) {
      return Theme.of(context).colorScheme.primary;
    } else {
      return todoColor;
    }
  }

  String getIcon(int index) {
    if (index == 1) {
      return 'assets/image/icons/shipping-truck.png';
    }
    if (index == 2) {
      return 'assets/image/icons/shipping-receiver.png';
    }
    if (index == 3) {
      return 'assets/image/icons/shipping-box-2.png';
    }
    return 'assets/image/icons/shipping-box.png';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Timeline.tileBuilder(
          theme: TimelineThemeData(
            direction: Axis.horizontal,
            connectorTheme: const ConnectorThemeData(
              space: 30.0,
              thickness: 5.0,
            ),
          ),
          builder: TimelineTileBuilder.connected(
            connectionDirection: ConnectionDirection.before,
            itemExtentBuilder: (_, __) =>
                MediaQuery.of(context).size.width / _processes.length,
            itemCount: _processes.length,
            oppositeContentsBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Image.asset(
                  getIcon(
                    index,
                  ),
                  color: getColor(index),
                  width: 35,
                  height: 35,
                  fit: BoxFit.cover,
                ),
              );
            },
            indicatorBuilder: (_, index) {
              Color color;
              Widget? child;
              if (index == widget.tracking.processIndex) {
                color = Theme.of(context).colorScheme.primary;
                child = const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(
                    strokeWidth: 3.0,
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                );
              } else if (index < widget.tracking.processIndex) {
                color = Theme.of(context).colorScheme.primary;
                child = const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 15.0,
                );
              } else {
                color = todoColor;
              }

              if (index <= widget.tracking.processIndex) {
                return Stack(
                  children: [
                    CustomPaint(
                      size: const Size(30.0, 30.0),
                      painter: _BezierPainter(
                        color: color,
                        drawStart: index > 0,
                        drawEnd: index < widget.tracking.processIndex,
                      ),
                    ),
                    DotIndicator(
                      size: 30.0,
                      color: color,
                      child: child,
                    ),
                  ],
                );
              } else {
                return Stack(
                  children: [
                    CustomPaint(
                      size: const Size(15.0, 15.0),
                      painter: _BezierPainter(
                        color: color,
                        drawEnd: index < _processes.length - 1,
                      ),
                    ),
                    OutlinedDotIndicator(
                      borderWidth: 4.0,
                      color: color,
                    ),
                  ],
                );
              }
            },
            connectorBuilder: (_, index, type) {
              if (index > 0) {
                if (index == widget.tracking.processIndex) {
                  final prevColor = getColor(index - 1);
                  final color = getColor(index);
                  List<Color> gradientColors;
                  if (type == ConnectorType.start) {
                    gradientColors = [
                      Color.lerp(prevColor, color, 0.5)!,
                      color
                    ];
                  } else {
                    gradientColors = [
                      prevColor,
                      Color.lerp(prevColor, color, 0.5)!
                    ];
                  }
                  return DecoratedLineConnector(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: gradientColors,
                      ),
                    ),
                  );
                } else {
                  return SolidLineConnector(
                    color: getColor(index),
                  );
                }
              } else {
                return null;
              }
            },
          )),
    );
  }
}

class _BezierPainter extends CustomPainter {
  const _BezierPainter({
    required this.color,
    this.drawStart = true,
    this.drawEnd = true,
  });

  final Color color;
  final bool drawStart;
  final bool drawEnd;

  Offset _offset(double radius, double angle) {
    return Offset(
      radius * cos(angle) + radius,
      radius * sin(angle) + radius,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color;

    final radius = size.width / 2;

    double angle;
    Offset offset1;
    Offset offset2;

    Path path;

    if (drawStart) {
      angle = 3 * pi / 4;
      offset1 = _offset(radius, angle);
      offset2 = _offset(radius, -angle);
      path = Path()
        ..moveTo(offset1.dx, offset1.dy)
        ..quadraticBezierTo(0.0, size.height / 2, -radius, radius)
        ..quadraticBezierTo(0.0, size.height / 2, offset2.dx, offset2.dy)
        ..close();

      canvas.drawPath(path, paint);
    }
    if (drawEnd) {
      angle = -pi / 4;
      offset1 = _offset(radius, angle);
      offset2 = _offset(radius, -angle);

      path = Path()
        ..moveTo(offset1.dx, offset1.dy)
        ..quadraticBezierTo(
            size.width, size.height / 2, size.width + radius, radius)
        ..quadraticBezierTo(size.width, size.height / 2, offset2.dx, offset2.dy)
        ..close();

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_BezierPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.drawStart != drawStart ||
        oldDelegate.drawEnd != drawEnd;
  }
}

final _processes = [
  'Packaging',
  'Delivery',
  'Delivered',
];
