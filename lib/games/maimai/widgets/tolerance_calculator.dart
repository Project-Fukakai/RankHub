import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rank_hub/games/maimai/models/maimai_notes.dart';

/// 容错计算器组件
class ToleranceCalculator extends StatefulWidget {
  final MaimaiNotes notes;

  const ToleranceCalculator({super.key, required this.notes});

  @override
  State<ToleranceCalculator> createState() => _ToleranceCalculatorState();
}

class _ToleranceCalculatorState extends State<ToleranceCalculator> {
  final TextEditingController _targetController = TextEditingController();
  double? _targetAchievement;

  // 计算结果
  int? _tapGreatCount;
  double? _break50Equivalent;
  double? _break2000Equivalent;

  @override
  void dispose() {
    _targetController.dispose();
    super.dispose();
  }

  /// 计算总权重
  double _calculateTotalWeight() {
    return widget.notes.tap.toDouble() +
        widget.notes.touch.toDouble() +
        2 * widget.notes.hold.toDouble() +
        3 * widget.notes.slide.toDouble() +
        5 * widget.notes.breakNote.toDouble();
  }

  /// 计算单个TAP GREAT的分数损失
  double _calculateTapGreatLoss() {
    final totalWeight = _calculateTotalWeight();
    final x = 1 / totalWeight;

    // TAP CRITICAL得分
    final tapCritical = 1 * x * 100;
    // TAP GREAT得分 (0.8倍权重)
    final tapGreat = 0.8 * x * 100;

    // 单个TAP GREAT相比CRITICAL的损失
    return tapCritical - tapGreat;
  }

  /// 计算BREAK 50落(PERFECT-1)相当于多少个TAP GREAT
  double _calculateBreak50Equivalent() {
    final totalWeight = _calculateTotalWeight();
    final x = 1 / totalWeight;
    final y = widget.notes.breakNote > 0 ? 1 / widget.notes.breakNote : 0.0;

    // BREAK CRITICAL得分
    final breakCritical = 5 * x * 100 + y;
    // BREAK PERFECT最高档(50落)得分
    final breakPerfect50 = 5 * x * 100 + 0.75 * y;

    // BREAK 50落相比CRITICAL的损失
    final break50Loss = breakCritical - breakPerfect50;

    // 单个TAP GREAT的损失
    final tapGreatLoss = _calculateTapGreatLoss();

    // BREAK 50落相当于多少个TAP GREAT
    return tapGreatLoss > 0 ? break50Loss / tapGreatLoss : 0.0;
  }

  /// 计算BREAK 粉2000(GREAT-1,即2000分档)相当于多少个TAP GREAT
  double _calculateBreak2000Equivalent() {
    final totalWeight = _calculateTotalWeight();
    final x = 1 / totalWeight;
    final y = widget.notes.breakNote > 0 ? 1 / widget.notes.breakNote : 0.0;

    // BREAK CRITICAL得分
    final breakCritical = 5 * x * 100 + y;
    // BREAK GREAT最高档(粉2000,即4倍权重)得分
    final breakGreat2000 = 4 * x * 100 + 0.4 * y;

    // BREAK 粉2000相比CRITICAL的损失
    final break2000Loss = breakCritical - breakGreat2000;

    // 单个TAP GREAT的损失
    final tapGreatLoss = _calculateTapGreatLoss();

    // BREAK 粉2000相当于多少个TAP GREAT
    return tapGreatLoss > 0 ? break2000Loss / tapGreatLoss : 0.0;
  }

  /// 计算容错
  void _calculate() {
    // 失去焦点
    FocusScope.of(context).unfocus();

    final target = double.tryParse(_targetController.text);
    if (target == null || target <= 0 || target > 101) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请输入有效的达成率(0-101%)')));
      return;
    }

    setState(() {
      _targetAchievement = target;

      // 100%减去目标达成率,得到允许的总损失
      final allowedLoss = 101.0 - target;

      // 单个TAP GREAT的损失
      final tapGreatLoss = _calculateTapGreatLoss();

      // 计算可以打多少个TAP GREAT
      _tapGreatCount = tapGreatLoss > 0
          ? (allowedLoss / tapGreatLoss).floor()
          : 0;

      // BREAK 50落相当于多少个TAP GREAT
      _break50Equivalent = _calculateBreak50Equivalent();

      // BREAK 粉2000相当于多少个TAP GREAT
      _break2000Equivalent = _calculateBreak2000Equivalent();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {
        // 点击其他区域时失去焦点
        FocusScope.of(context).unfocus();
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // 标题
              Row(
                children: [
                  Icon(
                    Icons.calculate_outlined,
                    color: colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '容错计算器',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 输入框
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _targetController,
                      decoration: InputDecoration(
                        labelText: '目标达成率',
                        hintText: '例如: 100.5',
                        suffixText: '%',
                        border: const OutlineInputBorder(),
                        isDense: true,
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d*'),
                        ),
                      ],
                      onSubmitted: (_) => _calculate(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  FilledButton(onPressed: _calculate, child: const Text('计算')),
                ],
              ),
              const SizedBox(height: 12),

              // 常用达成率快捷选择
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildQuickChip('100.5', colorScheme),
                  _buildQuickChip('100.0', colorScheme),
                  _buildQuickChip('99.5', colorScheme),
                  _buildQuickChip('99.0', colorScheme),
                ],
              ),

              // 计算结果
              if (_targetAchievement != null) ...[
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 12),

                // 目标达成率
                _buildResultItem(
                  icon: Icons.flag,
                  label: '目标达成率',
                  value: '${_targetAchievement!.toStringAsFixed(4)}%',
                  color: colorScheme.primary,
                ),
                const SizedBox(height: 12),

                // TAP GREAT容错
                _buildResultItem(
                  icon: Icons.touch_app,
                  label: 'TAP GREAT 容错',
                  value: '$_tapGreatCount 个',
                  color: Colors.pink,
                  subtitle: '相当于可以打 $_tapGreatCount 个 TAP GREAT',
                ),
                const SizedBox(height: 12),

                // BREAK 50落等价
                if (widget.notes.breakNote > 0) ...[
                  _buildResultItem(
                    icon: Icons.star_half,
                    label: 'BREAK 50落 (PERFECT-1)',
                    value:
                        '≈ ${_break50Equivalent!.toStringAsFixed(2)} 个 TAP GREAT',
                    color: Colors.orange.shade800,
                    subtitle:
                        '1个BREAK 50落相当于 ${_break50Equivalent!.toStringAsFixed(2)} 个TAP GREAT的损失',
                  ),
                  const SizedBox(height: 12),

                  // BREAK 粉2000等价
                  _buildResultItem(
                    icon: Icons.star_border,
                    label: 'BREAK 粉2000 (GREAT-1)',
                    value:
                        '≈ ${_break2000Equivalent!.toStringAsFixed(2)} 个 TAP GREAT',
                    color: Colors.pink,
                    subtitle:
                        '1个BREAK 粉2000相当于 ${_break2000Equivalent!.toStringAsFixed(2)} 个TAP GREAT的损失',
                  ),
                ],

                // 说明文字
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 16,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '说明',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '• 计算基于全部打出CRITICAL的理想状态\n'
                        '• BREAK 50落: PERFECT档最高分(2550分/50落)\n'
                        '• BREAK 粉2000: GREAT档最高分(2000分)\n'
                        '• 实际游玩中可能存在其他类型的失误',
                        style: TextStyle(
                          fontSize: 11,
                          color: colorScheme.onSurfaceVariant,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// 构建结果项
  Widget _buildResultItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    String? subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  /// 构建快捷选择chip
  Widget _buildQuickChip(String value, ColorScheme colorScheme) {
    final isSelected = _targetController.text == value;

    return ActionChip(
      label: Text('$value%'),
      onPressed: () {
        _targetController.text = value;
        _calculate();
      },
      backgroundColor: isSelected
          ? colorScheme.primaryContainer
          : colorScheme.surfaceContainerHighest,
      labelStyle: TextStyle(
        color: isSelected
            ? colorScheme.onPrimaryContainer
            : colorScheme.onSurface,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      side: isSelected
          ? BorderSide(color: colorScheme.primary, width: 1.5)
          : null,
    );
  }
}
