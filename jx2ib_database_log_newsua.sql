DROP TABLE IF EXISTS common_log;
CREATE TABLE common_log (
   ID int(11) NOT NULL auto_increment,
   LogTime timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL on update CURRENT_TIMESTAMP,
   GroupName varchar(32),
   LogType int(10) unsigned,
   LogContent blob,
   ObjName varchar(255),
   Flag tinyint(3) unsigned,
   Editable int(10) unsigned,
   PRIMARY KEY (ID),
   KEY LogTime (LogTime),
   KEY GroupName (GroupName),
   KEY LogType (LogType),
   KEY ObjName (ObjName)
);
