import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../domain/notes/i_note_repository.dart';
import '../../domain/notes/note.dart';
import '../../domain/notes/note_failure.dart';
import '../core/database_provider.dart';
import 'note_dtos.dart';

@LazySingleton(as: INoteRepository)
class NoteRepository implements INoteRepository {
  final DatabaseProvider _databaseProvider = DatabaseProvider.db;

  NoteRepository();
  // NOTE: R
  // Future<List<Note>> getNotes() async {
  //   final db = await _databaseProvider.database;

  //   List<Map<String, dynamic>> result;

  //   result = await db.rawQuery(
  //       "SELECT DISTINCT notes.*, accounts.title AS accountTitle FROM notes LEFT JOIN accounts ON notes.accountId = accounts.id");
  //   List<Note> notes =
  //       result.map((note) => NoteDto.fromJson(note).toDomain()).toList();
  //   return notes;
  // }
  @override
  Future<Either<NoteFailure, List<Note>>> getNotesDuringPeriod(
    int accountId,
    String startTime,
    String endTime,
  ) async {
    try {
      final db = await _databaseProvider.database;

      List<Map<String, dynamic>> result;
      result = await db.rawQuery(
          "SELECT DISTINCT notes.* FROM notes WHERE accountId = ? AND date(dateTime) BETWEEN date(?) AND date(?)",
          [accountId, startTime, endTime]);

      List<Note> notes =
          result.map((note) => NoteDto.fromJson(note).toDomain()).toList();
      return right(notes);
    } catch (e) {
      return left(NoteFailure.api(e.toString()));
    }
  }

  // // 考慮如何移除01
  // Future<List<Note>> filterNotesByAmountType(
  //   List<Note> notes,
  //   String amountType,
  // ) async {
  //   return notes.where((note) => note.amountType == amountType).toList();
  // }
  // 考慮如何移除02
  // Future<int> computeNetAmount(int accountId) async {

  //   int totalExpense = await getTotalAmountByAmountType(accountId, 'expense');
  //   int totalIncome = await getTotalAmountByAmountType(accountId, 'income');
  //   return totalIncome - totalExpense;
  // }

  @override
  Future<Either<NoteFailure, int>> getTotalAmountByAmountType(
    int accountId,
    String amountType,
  ) async {
    try {
      final db = await _databaseProvider.database;

      List<Map<String, dynamic>> result;
      result = await db.rawQuery(
          "SELECT DISTINCT notes.* FROM notes WHERE accountId = ? AND amountType = ?",
          [accountId, amountType]);

      List<Note> notes =
          result.map((note) => NoteDto.fromJson(note).toDomain()).toList();

      int totalAmount = 0;

      for (var note in notes) {
        totalAmount += note.amount;
      }

      return right(totalAmount);
    } catch (e) {
      return left(NoteFailure.api(e.toString()));
    }
  }

  @override
  Future<Either<NoteFailure, List<Note>>> getNotesByAmountTypeDuringPeriod(
    int accountId,
    String amountType,
    String startTime,
    String endTime,
  ) async {
    try {
      final db = await _databaseProvider.database;

      List<Map<String, dynamic>> result;
      result = await db.rawQuery(
          "SELECT DISTINCT notes.* FROM notes WHERE accountId = ? AND amountType = ? AND date(dateTime) BETWEEN date(?) AND date(?)",
          [accountId, amountType, startTime, endTime]);

      List<Note> notes =
          result.map((note) => NoteDto.fromJson(note).toDomain()).toList();
      return right(notes);
    } catch (e) {
      return left(NoteFailure.api(e.toString()));
    }
  }

  // NOTE: CUD
  @override
  Future<Option<NoteFailure>> create(Note note) async {
    try {
      final db = await _databaseProvider.database;
      final noteDto = NoteDto.fromDomain(note);

      await db.insert("notes", noteDto.toJson());
      return none();
    } catch (e) {
      return some(NoteFailure.api(e.toString()));
    }
  }

  @override
  Future<Option<NoteFailure>> update(Note note) async {
    try {
      final db = await _databaseProvider.database;
      final noteDto = NoteDto.fromDomain(note);

      await db.update("notes", noteDto.toJson(),
          where: "id = ?", whereArgs: [note.id]);
      return none();
    } catch (e) {
      return some(NoteFailure.api(e.toString()));
    }
  }

  @override
  Future<Option<NoteFailure>> delete(int noteId) async {
    try {
      final db = await _databaseProvider.database;

      await db.delete("notes", where: "id = ?", whereArgs: [noteId]);
      return none();
    } catch (e) {
      return some(NoteFailure.api(e.toString()));
    }
  }
}
