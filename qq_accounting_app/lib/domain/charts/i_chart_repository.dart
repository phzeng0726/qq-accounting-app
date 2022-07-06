import 'package:dartz/dartz.dart';

import '../notes/note.dart';
import 'chart_failure.dart';
import 'chart_item.dart';

abstract class IChartRepository {
  Future<Either<ChartFailure, List<ChartItem>>> combineCategoryForChart(
      List<Note> notes);
}
