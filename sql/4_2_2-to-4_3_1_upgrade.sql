--
--  Comment Meta Language Constructs:
--
--  #IfNotTable
--    argument: table_name
--    behavior: if the table_name does not exist,  the block will be executed

--  #IfTable
--    argument: table_name
--    behavior: if the table_name does exist, the block will be executed

--  #IfColumn
--    arguments: table_name colname
--    behavior:  if the table and column exist,  the block will be executed

--  #IfMissingColumn
--    arguments: table_name colname
--    behavior:  if the table exists but the column does not,  the block will be executed

--  #IfNotColumnType
--    arguments: table_name colname value
--    behavior:  If the table table_name does not have a column colname with a data type equal to value, then the block will be executed

--  #IfNotRow
--    arguments: table_name colname value
--    behavior:  If the table table_name does not have a row where colname = value, the block will be executed.

--  #IfNotRow2D
--    arguments: table_name colname value colname2 value2
--    behavior:  If the table table_name does not have a row where colname = value AND colname2 = value2, the block will be executed.

--  #IfNotRow3D
--    arguments: table_name colname value colname2 value2 colname3 value3
--    behavior:  If the table table_name does not have a row where colname = value AND colname2 = value2 AND colname3 = value3, the block will be executed.

--  #IfNotRow4D
--    arguments: table_name colname value colname2 value2 colname3 value3 colname4 value4
--    behavior:  If the table table_name does not have a row where colname = value AND colname2 = value2 AND colname3 = value3 AND colname4 = value4, the block will be executed.

--  #IfNotRow2Dx2
--    desc:      This is a very specialized function to allow adding items to the list_options table to avoid both redundant option_id and title in each element.
--    arguments: table_name colname value colname2 value2 colname3 value3
--    behavior:  The block will be executed if both statements below are true:
--               1) The table table_name does not have a row where colname = value AND colname2 = value2.
--               2) The table table_name does not have a row where colname = value AND colname3 = value3.

--  #IfRow2D
--    arguments: table_name colname value colname2 value2
--    behavior:  If the table table_name does have a row where colname = value AND colname2 = value2, the block will be executed.

--  #IfRow3D
--        arguments: table_name colname value colname2 value2 colname3 value3
--        behavior:  If the table table_name does have a row where colname = value AND colname2 = value2 AND colname3 = value3, the block will be executed.

--  #IfIndex
--    desc:      This function is most often used for dropping of indexes/keys.
--    arguments: table_name colname
--    behavior:  If the table and index exist the relevant statements are executed, otherwise not.

--  #IfNotIndex
--    desc:      This function will allow adding of indexes/keys.
--    arguments: table_name colname
--    behavior:  If the index does not exist, it will be created

--  #EndIf
--    all blocks are terminated with a #EndIf statement.

--  #IfNotListReaction
--    Custom function for creating Reaction List

--  #IfNotListOccupation
--    Custom function for creating Occupation List


#IfNotTable valueset
CREATE TABLE IF NOT EXISTS `valueset` (
  `nqf_code` varchar(255) DEFAULT NULL,
  `code` varchar(255) DEFAULT NULL,
  `code_system` varchar(255) DEFAULT NULL,
  `code_type` varchar(255) DEFAULT NULL,
  `valueset` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `valueset_name` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`nqf_code`,`code`,`valueset`)
) ENGINE=InnoDB;
#EndIf

#IfMissingColumn openemr_postcalendar_categories pc_active
	ALTER TABLE `openemr_postcalendar_categories` ADD `pc_active` tinyint(1) NOT NULL DEFAULT 1;
#Endif

#IfMissingColumn openemr_postcalendar_categories pc_seq
	ALTER TABLE `openemr_postcalendar_categories` ADD `pc_seq` int(11) NOT NULL DEFAULT '0';
	UPDATE `openemr_postcalendar_categories` set pc_seq = pc_catid;
#EndIf

-- Mu2 New Encounter Categories
#IfNotRow openemr_postcalendar_categories pc_catname Health and Behavioral Assessment
	SET @catid = (SELECT MAX(pc_catid) FROM  openemr_postcalendar_categories);
	INSERT INTO `openemr_postcalendar_categories` VALUES (@catid+1, 'Health and Behavioral Assessment', '#C7C7C7', 'Health and Behavioral Assessment', 0, NULL, 'a:5:{s:17:"event_repeat_freq";s:1:"0";s:22:"event_repeat_freq_type";s:1:"0";s:19:"event_repeat_on_num";s:1:"1";s:19:"event_repeat_on_day";s:1:"0";s:20:"event_repeat_on_freq";s:1:"0";}', 0, 900, 0, 0, 0, 0, 0,0,1,@catid+1);
	INSERT INTO `enc_category_map` ( `rule_enc_id`, `main_cat_id` ) VALUES ('enc_hea_and_beh', @catid+1);
#EndIf

#IfNotRow openemr_postcalendar_categories pc_catname Preventive Care Services
	SET @catid = (SELECT MAX(pc_catid) FROM  openemr_postcalendar_categories);
	INSERT INTO `openemr_postcalendar_categories` VALUES (@catid+1, 'Preventive Care Services', '#CCCCFF', 'Preventive Care Services', 0, NULL, 'a:5:{s:17:"event_repeat_freq";s:1:"0";s:22:"event_repeat_freq_type";s:1:"0";s:19:"event_repeat_on_num";s:1:"1";s:19:"event_repeat_on_day";s:1:"0";s:20:"event_repeat_on_freq";s:1:"0";}', 0, 900, 0, 0, 0, 0, 0,0,1,@catid+1);
	INSERT INTO `enc_category_map` ( `rule_enc_id`, `main_cat_id` ) VALUES ('enc_pre_ind_counsel', @catid+1);
	INSERT INTO `enc_category_map` ( `rule_enc_id`, `main_cat_id` ) VALUES ('enc_pre_med_group_counsel', @catid+1);
	INSERT INTO `enc_category_map` ( `rule_enc_id`, `main_cat_id` ) VALUES ('enc_pre_med_other_serv', @catid+1);
	INSERT INTO `enc_category_map` ( `rule_enc_id`, `main_cat_id` ) VALUES ('enc_pre_med_ser_18_older', @catid+1);
	INSERT INTO `enc_category_map` ( `rule_enc_id`, `main_cat_id` ) VALUES ('enc_pre_med_ser_40_older', @catid+1);
#EndIf

#IfNotRow2D list_options list_id order_type option_id enc_checkup_procedure
	SET @max_seq = (select max(seq) from list_options where list_id = 'order_type');
	INSERT INTO `list_options` (`list_id`,`option_id`,`title`,`seq`,`is_default`) values ('order_type','enc_checkup_procedure','Encounter Checkup Procedure',@max_seq+10,0);
#EndIf

-- updating nqf code for cqm measure blood pressure
UPDATE `clinical_rules` set `cqm_nqf_code` = '0018' where `id` = 'rule_htn_bp_measure_cqm';
--
