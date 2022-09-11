CREATE DATABASE Help_Heal_Healthy;
USE Help_Heal_Healthy;
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
drop table if exists Meal;
Create table Meal(id int not null auto_increment,
userID char(30) not null, date char(16),
foodName char(20),meat decimal(2,1), vegetables decimal(2,1)
, fish decimal(2,1), egg decimal(2,1) ,grains decimal(2,1)
, mealTime int, primary key(id));

drop table if exists Info;
Create table Info(id int not null auto_increment, userID char(16) not null,date char(16),
calories int, step int, sleep int,primary key(id));

INSERT INTO FOOD (name,meat,vegetables,fish,egg,grains,calories)
            VALUES
            ("Tangyuan","0.5","0.5","0.5","0.5","0.5","12");
INSERT INTO FOOD (name,meat,vegetables,fish,egg,grains,calories)
            VALUES
            ("Longan","0.5","0.5","0.5","0.5","0.5","12");          
INSERT INTO FOOD (name,meat,vegetables,fish,egg,grains,calories)
            VALUES
            ("Dumpling","0.5","0.5","0.5","0.5","0.5","12");


INSERT INTO `Notification_MESSAGE` (title,date,context)
            VALUES
            ("早睡早起精神好A","2019-12-24","根據科學顯示，早睡早起可以使精神更好")
INSERT INTO `Notification_MESSAGE` (title,date,context)
            VALUES
            ("早睡早起精神好B","2019-12-24","根據科學顯示，早睡早起可以使精神更好")
INSERT INTO `Notification_MESSAGE` (title,date,context)
            VALUES
            ("早睡早起精神好C","2019-12-24","根據科學顯示，早睡早起可以使精神更好")






