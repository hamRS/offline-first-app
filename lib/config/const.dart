const String DATABASE_NAME = 'offline_first.db';

const String CREATE_COMMENT_TABLE = '''

      create table post(
        id INTEGER PRIMARY KEY,
        userId INTEGER NOT NULL,
        title TEXT,
        body TEXT
      )
''';
