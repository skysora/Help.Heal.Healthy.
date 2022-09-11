CREATE DATABASE Help_Heal_Healthy;
USE Help_Heal_Healthy;
drop table if exists food;
create table food(id int not null auto_increment,foodName char(20) not null,
rice int, meat int, vegetable int, milk int ,nut int , fruit int, primary key(id));
drop table if exists info;
Create table info(id int not null auto_increment, userID int not null,date char(16),
calories int, step int, sleep int, 
rice int, meat int, vegetable int, milk int ,nut int , fruit int, primary key(id));
drop table if exists meal;
Create table meal(id int not null auto_increment, userID int not null, date char(16),
foodName char(20),rice int, meat int, vegetable int, milk int ,nut int , fruit int
, mealTime int, primary key(id));
Create table mealNotification(id int not null auto_increment,userID int not null,
title char(100) not null,body text not null,hour int,minute int,primary key(id));
