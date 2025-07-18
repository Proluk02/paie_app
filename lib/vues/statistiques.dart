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
      print('Nombre de paiements récupérés : ${paiements.length}');

      final formatMois = DateFormat('MMM');

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
      print('Résumé paiements par mois : $resume');

      if (!mounted) return;
      setState(() {
        paiementsParMois = resume;
        _loading = false;
      });
    } catch (e, stacktrace) {
      print('Erreur lors du chargement des données: $e');
      print(stacktrace);
      if (mounted) {
        setState(() {
          _loading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors du chargement des statistiques')),
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
            color: montant > 0 ? Colors.blue : Colors.grey,
          ),
        ],
      );
    }).toList();
  }

  Widget _moisTitle(double value, TitleMeta meta) {
    final mois = ['J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'];
    if (value >= 0 && value < mois.length) {
      return Text(mois[value.toInt()], style: const TextStyle(fontSize: 10));
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Statistiques')),
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: BarChart(
                  BarChartData(
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: _moisTitle,
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: true),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups: _genererBarGroups(),
                  ),
                ),
              ),
    );
  }
}
