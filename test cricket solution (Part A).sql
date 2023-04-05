create database test_match
use test_match

 SELECT * FROM icc_test_batting_figures;
 
 -- 1.Import the csv file to a table in the database.
 
 -- 2.Remove the column 'Player Profile' from the table.
 
 ALTER TABLE `icc_test_batting_figures`  CHANGE COLUMN `Player Profile` `PlayerProfile` TEXT NULL DEFAULT NULL ;
 ALTER TABLE icc_test_batting_figures DROP COLUMN PlayerProfile;
 
-- 3.Extract the country name and player names from the given data and store it in separate columns for further usage.



ALTER TABLE icc_test_batting_figures ADD COLUMN Country TEXT ;
update  icc_test_batting_figures set country = replace(SUBSTRING(player,POSITION('(' IN player)+1, LENGTH(player)),')',"");


ALTER TABLE icc_test_batting_figures ADD COLUMN player_name TEXT;
update  icc_test_batting_figures set player_name = SUBSTR(player,1,POSITION('(' IN player)-1);


-- 4.From the column 'Span' extract the start_year and end_year and store them in separate columns for further usage.
-- elect year(span) from icc_test_batting_figures;


ALTER TABLE icc_test_batting_figures ADD COLUMN start_year TEXT;
update  icc_test_batting_figures set start_year = SUBSTR(span, 1,4 ) ;

ALTER TABLE icc_test_batting_figures ADD COLUMN end_year TEXT;
update  icc_test_batting_figures set end_year = SUBSTR(span, 6,4 ) ;

-- 5.The column 'HS' has the highest score scored by the player so far in any given match. The column also has details if the player had completed the match in a NOT OUT status. Extract the data and store the highest runs and the NOT OUT status in different columns.


ALTER TABLE icc_test_batting_figures ADD COLUMN HS_notOut TEXT;
update  icc_test_batting_figures set HS_notOut =  SUBSTR(HS,1,length(HS)-1) where SUBSTR(HS,length(HS),length(HS))='*' ;

-- 6.Using the data given, considering the players who were active in the year of 2019, create a set of batting order of best 6 players using the selection criteria of those who have a good average score across all matches for India.
 SELECT *
 FROM `batting figures`
 WHERE player LIKE '%(INDIA)' AND
	   span LIKE '%2019'
ORDER BY avg DESC
LIMIT 6



/* 7.Using the data given, considering the players who were active in the year of 2019, create a set of batting order of best 6 players
 using the selection criteria of those who have the highest number of 100s across all matches for India. */
 SELECT *
 FROM `batting figures`
 WHERE player LIKE '%(INDIA)' AND
	   span LIKE '%2019'
ORDER BY '100' DESC
LIMIT 6

/* 8.Using the data given, considering the players who were active in the year of 2019, create a set of batting order of best 6 players 
using 2 selection criteria of your own for India.*/
SELECT *
 FROM `batting figures`
 WHERE player LIKE '%(INDIA)' AND
	   span LIKE '%2019' AND hs > 150 AND avg > 40
ORDER BY '100' DESC
LIMIT 6

/* 9.Create a View named ‘Batting_Order_GoodAvgScorers_SA’ using the data given, considering the players who were active in the year of 2019
, create a set of batting order of best 6 players using the selection criteria of those who have a good average score across all matches 
for South Africa.*/

CREATE VIEW Batting_Order_GoodAvgScorers_SA_VW AS
SELECT *
 FROM `batting figures`
 WHERE player LIKE '%(SA)' AND
	   span LIKE '%2019' 
ORDER BY avg DESC
LIMIT 6 

/* 10.Create a View named ‘Batting_Order_HighestCenturyScorers_SA’ Using the data given, considering the players who were active in the 
year of 2019, create a set of batting order of best 6 players using the selection criteria of those who have highest number of 100s 
across all matches for South Africa.*/

CREATE VIEW Batting_Order_HighestCenturyScorers_SA_VW AS
SELECT *
 FROM `batting figures`
 WHERE player LIKE '%(SA)' AND
	   span LIKE '%2019' 
ORDER BY '100' DESC
LIMIT 6 

/* 11.Using the data given, Give the number of player_played for each country.*/
SELECT SUBSTRING(player,POSITION('(' IN player), LENGTH(player)) AS country_name, COUNT(player) AS Number_of_player
FROM `batting figures`
GROUP BY SUBSTRING(player,POSITION('(' IN player), LENGTH(player))

/* 12. Using the data given, Give the number of player_played for Asian and Non-Asian continent*/
#Asian Continent
SELECT COUNT(player) AS no_of_asian_cricketer
FROM `batting figures`
WHERE SUBSTRING(player,POSITION('(' IN player), LENGTH(player))  LIKE '%INDIA%' OR 
      SUBSTRING(player,POSITION('(' IN player), LENGTH(player)) LIKE '%PAK%' OR 
       SUBSTRING(player,POSITION('(' IN player), LENGTH(player)) LIKE '%BDESH%' OR 
       SUBSTRING(player,POSITION('(' IN player), LENGTH(player)) LIKE '%SL%' OR 
       SUBSTRING(player,POSITION('(' IN player), LENGTH(player)) LIKE '%AFG%'
 
#Non Asian Continent
SELECT COUNT(player) AS no_of_non_asian_cricketer
FROM `batting figures`
WHERE SUBSTRING(player,POSITION('(' IN player), LENGTH(player))  LIKE '%AUS%' OR 
      SUBSTRING(player,POSITION('(' IN player), LENGTH(player)) LIKE '%SA%' OR 
       SUBSTRING(player,POSITION('(' IN player), LENGTH(player)) LIKE '%ZIM%' OR 
       SUBSTRING(player,POSITION('(' IN player), LENGTH(player)) LIKE '%WI%' OR 
       SUBSTRING(player,POSITION('(' IN player), LENGTH(player)) LIKE '%ENG%' OR
       SUBSTRING(player,POSITION('(' IN player), LENGTH(player)) LIKE '%NZ%' OR
       SUBSTRING(player,POSITION('(' IN player), LENGTH(player)) LIKE '%IRE%'
	 




