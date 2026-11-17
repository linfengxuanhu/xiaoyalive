import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  await SystemChrome.setPreferredOrientations(const [DeviceOrientation.portraitUp]);
  runApp(const XiaoyaLiveApp());
}

class XiaoyaLiveApp extends StatelessWidget {
  const XiaoyaLiveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '小雅 Live',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
      home: const CompanionHome(),
    );
  }
}

enum AvatarMood { idle, listening, speaking }

class CompanionHome extends StatefulWidget {
  const CompanionHome({super.key});

  @override
  State<CompanionHome> createState() => _CompanionHomeState();
}

class _CompanionHomeState extends State<CompanionHome>
    with TickerProviderStateMixin {
  late final AnimationController _breath;
  late final AnimationController _glow;
  AvatarMood _mood = AvatarMood.idle;
  bool _showHint = true;

  @override
  void initState() {
    super.initState();
    _breath = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4200),
      lowerBound: 0,
      upperBound: 1,
    )..repeat(reverse: true);
    _glow = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _breath.dispose();
    _glow.dispose();
    super.dispose();
  }

  String get _status => switch (_mood) {
        AvatarMood.idle => '待机中 · 轻触下方按钮体验状态',
        AvatarMood.listening => '倾听演示 · 正在认真听你说话',
        AvatarMood.speaking => '说话演示 · 这是动画预览，并非真实语音',
      };

  void _cycleMood() {
    setState(() {
      _mood = switch (_mood) {
        AvatarMood.idle => AvatarMood.listening,
        AvatarMood.listening => AvatarMood.speaking,
        AvatarMood.speaking => AvatarMood.idle,
      };
      _showHint = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF293447), Color(0xFF111827), Color(0xFF382E3B)],
              ),
            ),
          ),
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _breath,
              builder: (context, child) {
                final scale = 1.015 + (_breath.value * 0.012);
                final dy = (_breath.value - 0.5) * -7;
                return Transform.translate(
                  offset: Offset(0, dy),
                  child: Transform.scale(scale: scale, child: child),
                );
              },
              child: Image.asset(
                'assets/images/xiaoya_portrait.jpg',
                fit: BoxFit.cover,
                alignment: const Alignment(0.0, -0.15),
              ),
            ),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x990B1220), Colors.transparent, Color(0xAA111827)],
                stops: [0, 0.34, 1],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white70, width: 1.5),
                          image: const DecorationImage(
                            image: AssetImage('assets/images/xiaoya_portrait.jpg'),
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter,
                          ),
                        ),
                      ),
                      const SizedBox(width: 11),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Text('小雅', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                              SizedBox(width: 8),
                              Icon(Icons.circle, color: Color(0xFF62D99A), size: 9),
                            ]),
                            Text('Xiaoya Live · V0.1', style: TextStyle(fontSize: 11, color: Colors.white70)),
                          ],
                        ),
                      ),
                      _glassIcon(Icons.settings_outlined, () => _showInfo('设置', 'V0.1 演示版暂不提供设置功能。')),
                      const SizedBox(width: 8),
                      _glassIcon(Icons.more_horiz, () => _showInfo('关于小雅', '这是小雅 Live V0.1：离线人物展示与微动效果原型。')),
                    ],
                  ),
                  const Spacer(),
                  if (_showHint)
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.24),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: const Text('你好呀！\n很高兴见到你。',
                            style: TextStyle(fontSize: 17, height: 1.55, fontWeight: FontWeight.w500)),
                      ),
                    ),
                  const Spacer(),
                  AnimatedBuilder(
                    animation: _glow,
                    builder: (context, _) {
                      final glow = 10 + _glow.value * 15;
                      return GestureDetector(
                        onTap: _cycleMood,
                        child: Column(
                          children: [
                            Container(
                              width: 82,
                              height: 82,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFF536EDC).withOpacity(0.88),
                                border: Border.all(color: Colors.white70, width: 1.4),
                                boxShadow: [
                                  BoxShadow(color: const Color(0xFF7B8CFF).withOpacity(0.45), blurRadius: glow, spreadRadius: 2),
                                ],
                              ),
                              child: Icon(
                                _mood == AvatarMood.listening
                                    ? Icons.hearing_rounded
                                    : _mood == AvatarMood.speaking
                                        ? Icons.graphic_eq_rounded
                                        : Icons.play_arrow_rounded,
                                size: 39,
                              ),
                            ),
                            const SizedBox(height: 9),
                            Text(_mood == AvatarMood.idle ? '体验互动状态' : _mood == AvatarMood.listening ? '倾听状态' : '说话状态',
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  Text(_status, textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white80, fontSize: 12)),
                  const SizedBox(height: 22),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _bottomAction(Icons.photo_library_outlined, '形象', () => _showInfo('人物形象', 'V0.1 使用内置小雅肖像。后续版本增加人物素材管理。')),
                      _bottomAction(Icons.favorite_border, '关于', () => _showInfo('小雅 Live', '先完成数字人外壳，再逐步加入声音驱动和 AI 联动。')),
                      _bottomAction(Icons.refresh_rounded, '重置状态', () => setState(() { _mood = AvatarMood.idle; _showHint = true; })),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _glassIcon(IconData icon, VoidCallback onTap) => ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Material(
            color: Colors.black.withOpacity(0.25),
            child: InkWell(
              onTap: onTap,
              child: SizedBox(width: 42, height: 42, child: Icon(icon, size: 21)),
            ),
          ),
        ),
      );

  Widget _bottomAction(IconData icon, String label, VoidCallback onTap) =>
      InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(children: [
            Icon(icon, size: 23, color: Colors.white),
            const SizedBox(height: 5),
            Text(label, style: const TextStyle(fontSize: 11, color: Colors.white90)),
          ]),
        ),
      );

  void _showInfo(String title, String message) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('知道了'))],
      ),
    );
  }
}
