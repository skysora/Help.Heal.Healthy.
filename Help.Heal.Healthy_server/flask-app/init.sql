# db = pymysql.connect(host="127.0.0.1",port=5500,user="root",passwd="050042",db="Help_Heal_Healthy")
drop table if exists USER;
CREATE TABLE USER(  
  account char(30) Not NULL,
  password varchar(12) Not NULL,
  sex char(1) Not NULL,
  height decimal(5,2) Not NULL,
  weight decimal(5,2) Not NULL,
  uuid char(30) Not NULL,
  PRIMARY KEY(account)
 );
drop table if exists FOOD;
CREATE TABLE FOOD(  
  name char(10) NOT NULL,
  meat decimal(2,1) NOT NULL,
  vegetables decimal(2,1) NOT NULL,
  fish decimal(2,1) NOT NULL,
  egg decimal(2,1) NOT NULL,
  grains decimal(2,1) NOT NULL,
  calories decimal(5,2) NOT NULL,
  PRIMARY KEY(name)
 );
drop table if exists Notification_MESSAGE;
CREATE TABLE Notification_MESSAGE(  
  title char(10) NOT NULL,
  date char (30) NOT NULL,
  context char(100) ,
  PRIMARY KEY(title)
 );