import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../services/bd_service.dart';
import 'package:intl/intl.dart';

class StatistiquesPage extends StatefulWidget {
  const StatistiquesPage({super.key});

  @override
  State<StatistiquesPage> createState() => _StatistiquesPageState();
}

class _StatistiquesPageState extends State<StatistiquesPage> {
  final BDService _bdService = BDService();
  Map<String, double> paiementsParMois = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _chargerDonnees();
  }

  Future<void> _chargerDonnees() async {
    try {
      final db = await _bdService.database;
      final paiements = await db.query('paiements');
      // print('Nombre de paiements récupérés : ${paiements.length}');

      final formatMois = DateFormat('MMM'); // Ex: Jan, Feb...

      Map<String, double> resume = {};
      for (var p in paiements) {
        final dateStr = p['date'] as String?;
        final montantNum = p['montant'];
        if (dateStr == null || montantNum == null) continue;

        final date = DateTime.tryParse(dateStr);
        if (date != null) {
          final mois = formatMois.format(date);
          resume[mois] = (resume[mois] ?? 0) + (montantNum as num).toDouble();
        }
      }

      if (!mounted) return;
      setState(() {
        paiementsParMois = resume;
        _loading = false;
      });
    } catch (e, stacktrace) {
      if (mounted) {
        setState(() {
          _loading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors du chargement des statistiques: $e'),
          ),
        );
      }
    }
  }

  List<BarChartGroupData> _genererBarGroups() {
    final moisOrdres = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return moisOrdres.asMap().entries.map((entry) {
      final index = entry.key;
      final mois = entry.value;
      final montant = paiementsParMois[mois] ?? 0;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: montant,
            width: 16,
            color: montant > 0 ? Colors.blueAccent : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(6),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: 1000, // hauteur max arbitraire pour uniformiser
              color: Colors.grey.shade200,
            ),
          ),
        ],
      );
    }).toList();
  }

  Widget _moisTitle(double value, TitleMeta meta) {
    const moisAbr = [
      'J',
      'F',
      'M',
      'A',
      'M',
      'J',
      'J',
      'A',
      'S',
      'O',
      'N',
      'D',
    ];
    if (value >= 0 && value < moisAbr.length) {
      return SideTitleWidget(
        child: Text(
          moisAbr[value.toInt()],
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
        meta: meta, // <-- obligatoire maintenant
      );
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Statistiques des paiements')),
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: BarChart(
                  BarChartData(
                    maxY:
                        (paiementsParMois.values.isNotEmpty)
                            ? (paiementsParMois.values.reduce(
                                  (a, b) => a > b ? a : b,
                                ) *
                                1.2)
                            : 100,
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: _moisTitle,
                          reservedSize: 30,
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 100,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value.toInt().toString(),
                              style: const TextStyle(fontSize: 10),
                            );
                          },
                        ),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    gridData: FlGridData(
                      show: true,
                      horizontalInterval: 100,
                      getDrawingHorizontalLine:
                          (value) => FlLine(
                            color: Colors.grey.shade300,
                            strokeWidth: 1,
                          ),
                    ),
                    barGroups: _genererBarGroups(),
                  ),
                ),
              ),
    );
  }
}
