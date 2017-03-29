DROP TABLE IF EXISTS `user_push`;
 CREATE TABLE `user_push` (
  `user_push_id` varchar(40) NOT NULL,
  `scy_user_id` varchar(40) DEFAULT NULL,
  `push_id` varchar(40) DEFAULT NULL,
  `IS_PUSH` char(1) DEFAULT '1' COMMENT '�Ƿ���������Ϣ 0:����;1:��',
  `IS_SOUND` char(1) DEFAULT '1' COMMENT '�Ƿ������� 0:����;1:��',
  `IS_VIBRATE` char(1) DEFAULT '1' COMMENT '�Ƿ����� 0:����;1:��',
  `IS_DISTURB` char(1) DEFAULT '0' COMMENT '�Ƿ�������� 0:����;1:��',
  `createdby` varchar(40) NOT NULL DEFAULT '',
  `createdon` datetime NOT NULL,
  `modifiedby` varchar(40) NOT NULL DEFAULT '',
  `modifiedon` datetime NOT NULL,
  `deletion_state` char(1) NOT NULL DEFAULT '0' COMMENT 'ɾ��״̬',
  `description` varchar(500) DEFAULT '',
  PRIMARY KEY (`user_push_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
