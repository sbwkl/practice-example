CREATE TABLE me_message_entrance (
  me_message_entrance_id TEXT PRIMARY KEY,
  me_message_entrance_parent_id TEXT DEFAULT NULL,
  name TEXT NOT NULL,
  icon TEXT DEFAULT NULL,
  type TEXT NOT NULL,
  createdby TEXT NOT NULL DEFAULT '',
  createdon TEXT NOT NULL,
  modifiedby TEXT NOT NULL DEFAULT '',
  modifiedon TEXT NOT NULL,
  deletion_state TEXT NOT NULL DEFAULT '0',
  description TEXT DEFAULT ''
);
