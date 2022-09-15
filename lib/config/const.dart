const String DATABASE_NAME = 'offline_first.db';

const String CREATE_COMMENT_TABLE = '''

      create table post(
        id Integer PRIMARY KEY,
        userID Integer,
        title TEXT,
        body TEXT
      )
''';
