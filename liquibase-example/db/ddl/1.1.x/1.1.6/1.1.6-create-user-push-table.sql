CREATE TABLE user_push (
  user_push_id TEXT PRIMARY KEY NOT NULL,
  scy_user_id TEXT,
  push_id TEXT,
  IS_PUSH TEXT DEFAULT '1',
  IS_SOUND TEXT DEFAULT '1',
  IS_VIBRATE TEXT DEFAULT '1',
  IS_DISTURB TEXT DEFAULT '0',
  createdby TEXT NOT NULL DEFAULT '',
  createdon DATETIME NOT NULL,
  modifiedby TEXT NOT NULL DEFAULT '',
  modifiedon DATETIME NOT NULL,
  deletion_state TEXT NOT NULL DEFAULT '0',
  description TEXT DEFAULT ''
);
