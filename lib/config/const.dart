const String DATABASE_NAME = 'offline_first2.db';

const String CREATE_COMMENT_TABLE = '''

      create table post(
        id INTEGER PRIMARY KEY,
        userID INTEGER,
        title TEXT,
        body TEXT
      )
''';
