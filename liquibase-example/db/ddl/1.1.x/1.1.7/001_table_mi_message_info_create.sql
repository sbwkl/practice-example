CREATE TABLE mi_message_info (
  mi_message_info_id TEXT PRIMARY KEY,
  title TEXT,
  content TEXT,
  send_time TEXT,
  me_message_entrance_id TEXT,
  msg_status TEXT,
  msg_type TEXT,
  sender_scy_user_id TEXT,
  receiver_scy_user_id TEXT,
  createdby TEXT NOT NULL DEFAULT '',
  createdon TEXT NOT NULL,
  modifiedby TEXT NOT NULL DEFAULT '',
  modifiedon TEXT NOT NULL,
  deletion_state TEXT NOT NULL DEFAULT '0',
  description TEXT DEFAULT ''
);
