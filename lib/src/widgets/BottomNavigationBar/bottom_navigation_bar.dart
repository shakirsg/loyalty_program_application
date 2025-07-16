import 'package:flutter/material.dart';
import '../../themes/light_color.dart';
import './background_curve_painter.dart';

class BottomNavBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  BottomNavBarState createState() => BottomNavBarState();
}

class BottomNavBarState extends State<BottomNavBar>
    with TickerProviderStateMixin {
  late AnimationController _xController;
  late AnimationController _yController;

  @override
  void initState() {
    super.initState();
    _xController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _yController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    Listenable.merge([_xController, _yController]).addListener(() {
      setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _xController.value =
        _indexToPosition(widget.currentIndex) /
        MediaQuery.of(context).size.width;
    _yController.value = 1.0;
  }

  double _indexToPosition(int index) {
    const buttonCount = 4.0;
    final appWidth = MediaQuery.of(context).size.width;
    final buttonsWidth = _getButtonContainerWidth();
    final startX = (appWidth - buttonsWidth) / 2;
    return startX +
        index.toDouble() * buttonsWidth / buttonCount +
        buttonsWidth / (buttonCount * 2.0);
  }

  @override
  void dispose() {
    _xController.dispose();
    _yController.dispose();
    super.dispose();
  }

  Widget _buildNavItem({
    required IconData icon,
    required bool isSelected,
    required int index,
  }) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(50),
        onTap: () {
          // print('I am selected');
          _handlePressed(index);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          alignment: isSelected ? Alignment.topCenter : Alignment.center,
          child: AnimatedContainer(
            height: isSelected ? 40 : 20,
            duration: const Duration(milliseconds: 200),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? LightColor.orange : Colors.white,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: isSelected ? const Color(0xfffeece2) : Colors.white,
                  blurRadius: 10,
                  spreadRadius: 5,
                  // offset: const Offset(5, 5),
                ),
              ],
              shape: BoxShape.circle,
            ),
            child: Opacity(
              opacity: isSelected ? _yController.value : 1,
              child: Icon(
                icon,
                color: isSelected
                    ? LightColor.background
                    : Theme.of(context).iconTheme.color,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackground() {
    final inCurve = ElasticOutCurve(0.38);
    final width = MediaQuery.of(context).size.width;
    return CustomPaint(
      painter: BackgroundCurvePainter(
        _xController.value * width,
        Tween<double>(
          begin: Curves.easeInExpo.transform(_yController.value),
          end: inCurve.transform(_yController.value),
        ).transform(_yController.velocity.sign * 0.5 + 0.5),
        Theme.of(context).colorScheme.surface,
        // const Color.fromARGB(255, 241, 216, 216)
      ),
    );
  }

  double _getButtonContainerWidth() {
    double width = MediaQuery.of(context).size.width;
    if (width > 400.0) {
      width = 400.0;
    }
    return width;
  }

  void _handlePressed(int index) {
    if (widget.currentIndex == index || _xController.isAnimating) return;
    widget.onTap(index); // Call the onTap callback for the parent widget
    setState(() {
      // Update the index if a different one is selected
    });

    _yController.value = 1.0;
    _xController.animateTo(
      _indexToPosition(index) / MediaQuery.of(context).size.width,
      duration: const Duration(milliseconds: 350),
    );
    Future.delayed(const Duration(milliseconds: 300), () {
      _yController.animateTo(1.0, duration: const Duration(milliseconds: 700));
    });
    _yController.animateTo(0.0, duration: const Duration(milliseconds: 200));
  }

  @override
  Widget build(BuildContext context) {
    final appSize = MediaQuery.of(context).size;
    const height = 60.0;
    return SizedBox(
      width: appSize.width,
      height: height,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            bottom: 0,
            width: appSize.width,
            height: height - 10 + 10,
            child: _buildBackground(),
          ),
          Positioned(
            left: (appSize.width - _getButtonContainerWidth()) / 2,
            top: 0,
            width: _getButtonContainerWidth(),
            height: height,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _buildNavItem(
                  icon: Icons.home_outlined,
                  isSelected: widget.currentIndex == 0,
                  index: 0,
                ),
                _buildNavItem(
                  icon: Icons.card_giftcard_outlined,
                  isSelected: widget.currentIndex == 1,
                  index: 1,
                ),
                _buildNavItem(
                  icon: Icons.qr_code_outlined,
                  isSelected: widget.currentIndex == 2,
                  index: 2,
                ),
                _buildNavItem(
                  icon: Icons.person_outlined,
                  isSelected: widget.currentIndex == 3,
                  index: 3,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
