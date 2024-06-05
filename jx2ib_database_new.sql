DROP TABLE IF EXISTS exceptionrole;
CREATE TABLE exceptionrole (
   RoleName varchar(32),
   Account varchar(32),
   GroupName varchar(32),
   FullInfo blob,
   LastModify varchar(20)
);


DROP TABLE IF EXISTS fightteam;
CREATE TABLE fightteam (
   GUID bigint(20) unsigned NOT NULL,
   GroupName varchar(32) NOT NULL,
   LastModify timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL on update CURRENT_TIMESTAMP,
   Name varchar(32),
   Leader varchar(32),
   Member blob,
   State int(11),
   Flag int(11),
   CreateTime timestamp DEFAULT '0000-00-00 00:00:00' NOT NULL,
   Score int(11),
   Data blob,
   PRIMARY KEY (GUID),
   KEY Name (Name)
);


DROP TABLE IF EXISTS masterandprentice;
CREATE TABLE masterandprentice (
   RoleName varchar(32) NOT NULL,
   GroupName varchar(32),
   MasterName varchar(32),
   Data blob,
   LastModify varchar(20),
   PRIMARY KEY (RoleName),
   KEY MasterName (MasterName)
);


DROP TABLE IF EXISTS offlinemsg;
CREATE TABLE offlinemsg (
   RoleName varchar(32) NOT NULL,
   GroupName varchar(32),
   Message blob,
   LastModify varchar(20),
   PRIMARY KEY (RoleName)
);

DROP TABLE IF EXISTS playerfightteam;
CREATE TABLE playerfightteam (
   RoleName varchar(32) NOT NULL,
   GroupName varchar(32),
   TeamID bigint(20) unsigned,
   PRIMARY KEY (RoleName),
   KEY RoleName (RoleName)
);


DROP TABLE IF EXISTS playerrelation;
CREATE TABLE playerrelation (
   RoleName varchar(32) NOT NULL,
   GroupName varchar(32),
   Relation blob,
   LastModify varchar(20),
   PRIMARY KEY (RoleName)
);

DROP TABLE IF EXISTS role;
CREATE TABLE role (
   RoleName varchar(32) NOT NULL,
   Account varchar(32),
   GroupName varchar(32),
   ListItem blob,
   FullInfo blob,
   LastModify varchar(20),
   PRIMARY KEY (RoleName),
   KEY Account (Account)
);

DROP TABLE IF EXISTS sharedatabase;
CREATE TABLE sharedatabase (
   KeyEntry blob,
   GroupName varchar(32),
   Data blob,
   KEY KeyEntry(KeyEntry(767))
);

DROP TABLE IF EXISTS tong;
CREATE TABLE tong (
   Name varchar(32) NOT NULL,
   GroupName varchar(32),
   Data blob,
   LastModify varchar(20),
   PRIMARY KEY (Name)
);

