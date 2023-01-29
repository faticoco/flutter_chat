import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

import 'crud_exceptions.dart';

class notesService {
  Database? _db;

  Future<databasenote> updatenote(
      {required databasenote note, required String text}) async {
    final db = _getdatabaseorthrow();
    await getnote(id: note.id);
    final update_count = await db.update(notetable, {
      textcol: text,
      issyncedwithcloudcol: 0,
    });

    if (update_count == 0) {
      throw CouldNotUpdateNote();
    } else {
      return await getnote(id: note.id);
    }
  }

  Future<Iterable<databasenote>> getallnotes() async {
    final db = _getdatabaseorthrow();
    final notes = await db.query(
      notetable,
    );
    return notes.map((noteRow) => databasenote.fromRow(noteRow));
  }

  Future<databasenote> getnote({required int id}) async {
    final db = _getdatabaseorthrow();
    final notes = await db.query(
      notetable,
      limit: 1,
      where: 'id =?',
      whereArgs: [id],
    );
    if (notes.isEmpty) {
      throw CouldNotFindNote();
    } else {
      return databasenote.fromRow(notes.first);
    }
  }

  Future<int> deleteallnotes() async {
    final db = _getdatabaseorthrow();
    return await db.delete(notetable);
  }

  Future<void> deletenote({required int id}) async {
    final db = _getdatabaseorthrow();
    final deleted_count = await db.delete(
      notetable,
      where: 'id =?',
      whereArgs: [id],
    );
    if (deleted_count == 0) {
      throw CouldNotDeleteNote();
    }
  }

  Future<databasenote> createnote({required databaseuser owner}) async {
    final db = _getdatabaseorthrow();

    //owner exists or not
    final db_user = await getuser(email: owner.email);
    if (db_user != owner) {
      throw CouldNotFindUser();
    }
    const text = '';
    //creating note
    final note_id = await db.insert(notetable,
        {useridcol: owner.id, textcol: text, issyncedwithcloudcol: 1});

    final note = databasenote(
      id: note_id,
      text: text,
      User_id: owner.id,
      Is_synced_with_cloud: true,
    );
    return note;
  }

  Future<databaseuser> getuser({required String email}) async {
    final db = _getdatabaseorthrow();
    final results = await db.query(
      usertable,
      limit: 1,
      where: 'email=?',
      whereArgs: [email.toLowerCase()],
    );
    if (results.isEmpty) {
      throw CouldNotFindUser();
    } else {
      return databaseuser.fromRow(results.first);
    }
  }

  Future<databaseuser> createuser({required String email}) async {
    final db = _getdatabaseorthrow();
    final results = await db.query(
      usertable,
      limit: 1,
      where: 'email=?',
      whereArgs: [email.toLowerCase()],
    );
    if (results.isNotEmpty) {
      throw UserAlreadyExists();
    }
    final user_id = await db.insert(usertable, {
      emailcolumn: email.toLowerCase(),
    });

    return databaseuser(
      id: user_id,
      email: email,
    );
  }

  Future<void> deleteuser({required String email}) async {
    final db = _getdatabaseorthrow();
    final deleted_count = await db.delete(
      usertable,
      where: 'email =?',
      whereArgs: [email.toLowerCase()],
    );
    if (deleted_count != 1) {
      throw CouldNotDeleteUser();
    }
  }

  Database _getdatabaseorthrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      return db;
    }
  }

//closing data base in sqflite
  Future<void> close() async {
    final db = _db;
    if (db != null) {
      throw DatabaseIsNotOpen();
    } else {
      await db?.close();
      _db = null;
    }
  }

//opening data base in sqflite
  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    }

    try {
      final docspath = await getApplicationDocumentsDirectory();
      final db_path = join(docspath.path, dbname);
      final db = await openDatabase(db_path);
      _db = db;

//create user table
      await db.execute(createUserTable);

//create note table
      await db.execute(createnotetable);
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentsDirectory();
    }
  }
}

@immutable
class databaseuser {
  final int id;
  final String email;
  const databaseuser({
    required this.id,
    required this.email,
  });

  databaseuser.fromRow(Map<String, Object?> map)
      : id = map[idcolumn] as int,
        email = map[emailcolumn] as String;

  @override
  String toString() => 'person , id =$id , email =$email';

  @override
  bool operator ==(covariant databaseuser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class databasenote {
  final int id;
  final String text;
  final int User_id;
  final bool Is_synced_with_cloud;

  databasenote({
    required this.id,
    required this.text,
    required this.User_id,
    required this.Is_synced_with_cloud,
  });

  databasenote.fromRow(Map<String, Object?> map)
      : id = map[idcolumn] as int,
        text = map[textcol] as String,
        User_id = map[useridcol] as int,
        Is_synced_with_cloud =
            (map[issyncedwithcloudcol] as int) == 1 ? true : false;

  @override
  String toString() =>
      'person , id =$id  , User_id =$User_id , Is_synced_with_cloud=$Is_synced_with_cloud';

  @override
  bool operator ==(covariant databasenote other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

//constants
const dbname = 'notes.db';
const notetable = 'note';
const usertable = 'user';
const idcolumn = 'id';
const emailcolumn = 'email';
const useridcol = 'user_id';
const textcol = 'text';
const issyncedwithcloudcol = 'is_synced_with_cloud';
const createnotetable = ''' CREATE TABLE IF NOT EXISTS "note" (
	"id"	INTEGER NOT NULL,
	"user id"	INTEGER NOT NULL,
	"text"	TEXT,
	"is_synced_with_server_cloud"	INTEGER NOT NULL DEFAULT 0,
	PRIMARY KEY("id" AUTOINCREMENT)
);''';

const createUserTable = '''CREATE TABLE IF NOT EXISTS "user"  (
	"id"	INTEGER NOT NULL,
	"email"	TEXT NOT NULL UNIQUE,
	PRIMARY KEY("id" AUTOINCREMENT)
);
''';
