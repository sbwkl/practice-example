CREATE TABLE dynamic_func (
  dynamic_func_id TEXT NOT NULL,
  dynamic_func_type TEXT NOT NULL,
  func_sort TEXT NOT NULL,
  need_publish TEXT NOT NULL,
  createdby TEXT NOT NULL DEFAULT '',
  createdon TEXT NOT NULL,
  modifiedby TEXT NOT NULL DEFAULT '',
  modifiedon TEXT NOT NULL,
  deletion_state TEXT NOT NULL DEFAULT '0',
  description TEXT DEFAULT '',
  PRIMARY KEY (dynamic_func_id)
);
