#How many matches were won by Marcos Baghdatis from in 2011
SELECT winner_name as Name, COUNT(winner_name) AS Wins FROM Tennis.matches2011 m 
WHERE winner_name = "Marcos Baghdatis";

#Print all of the details of the longest match of 2012
SELECT tourney_name AS Tournament, winner_name AS Winner, loser_name AS Loser,
Score, Minutes FROM Tennis.matches2012 m 
ORDER BY minutes DESC 
LIMIT 1;

#Now longest non GS match of 2013
SELECT tourney_name AS Tournament, winner_name AS Winner, loser_name AS Loser,
Score, Minutes FROM Tennis.matches2013 m 
WHERE draw_size != 128
ORDER BY minutes DESC 
LIMIT 1;

#Who made the biggest surprise of 2014? Consider surprise a low ranked player
#beating a player in the top 50
SELECT tourney_name AS Tournament, winner_name AS Winner, winner_rank as Winner_Ranking, 
loser_name AS Loser, loser_rank AS Loser_Ranking, Score FROM Tennis.matches2014 m 
WHERE  winner_rank = (SELECT MAX(winner_rank) FROM Tennis.matches2014 WHERE 
winner_rank IS NOT NULL AND loser_rank IS NOT NULL AND loser_rank <=50)
ORDER BY loser_rank 
LIMIT 1;

#Show all of the times that a number 1 lost a match in 2015
SELECT tourney_name AS Tournament, winner_name AS Winner, winner_rank as Winner_Ranking, 
loser_name AS Loser, loser_rank AS Loser_Ranking, Score FROM Tennis.matches2015 m 
WHERE loser_rank = 1;

#How many times did John Isner lost his serve during 2010?
SELECT SUM(CASE 
WHEN winner_name = "John Isner" THEN (w_bpFaced - w_bpSaved)
WHEN loser_name = "John Isner" THEN (w_bpFaced - w_bpSaved) END) AS Breaks
FROM Tennis.matches2010 m;

#See how many times Milos Raonic lost his serve in each game of 2010
SELECT tourney_name AS Tournament, winner_name AS Winner, winner_rank as Winner_Ranking, 
loser_name AS Loser, loser_rank AS Loser_Ranking, Score,
IFNULL(CASE 
WHEN winner_name = "Milos Raonic" THEN (w_bpFaced - w_bpSaved)
WHEN loser_name = "Milos Raonic" THEN (w_bpFaced - w_bpSaved) END,0) AS Breaks
FROM Tennis.matches2011 m 
WHERE winner_name = "Milos Raonic" OR loser_name = "Milos Raonic";

#Oops, he barely played in 2010 haha, lets try 2014 again for Milos
SELECT tourney_name AS Tournament, winner_name AS Winner, winner_rank as Winner_Ranking, 
loser_name AS Loser, loser_rank AS Loser_Ranking, Score,
IFNULL(CASE 
WHEN winner_name = "Milos Raonic" THEN (w_bpFaced - w_bpSaved)
WHEN loser_name = "Milos Raonic" THEN (w_bpFaced - w_bpSaved) END,0) AS Breaks
FROM Tennis.matches2014 m 
WHERE winner_name = "Milos Raonic" OR loser_name = "Milos Raonic";

#See all the aces of Jerzy Janowicz in 2015
SELECT tourney_name AS Tournament, winner_name AS Winner, winner_rank as Winner_Ranking, 
loser_name AS Loser, loser_rank AS Loser_Ranking, Score,
IFNULL((CASE 
WHEN winner_name = "Jerzy Janowicz" THEN w_ace 
WHEN loser_name = "Jerzy Janowicz" THEN l_ace  END),0) AS Aces
FROM Tennis.matches2015 m 
WHERE winner_name = "Jerzy Janowicz" OR loser_name = "Jerzy Janowicz"
ORDER BY Aces DESC;

#Youngest player to win a tournament in 2013
SELECT tourney_name AS Tournament, winner_name AS Winner, winner_rank as Winner_Ranking, 
Winner_Age, loser_name AS Loser, loser_rank AS Loser_Ranking, Loser_Age, Score
FROM Tennis.matches2013
WHERE Winner_Age IS NOT NULL AND round = "F"
ORDER BY winner_age 
LIMIT 1;

#See all of the games that had a bagel (6-0 in a set) in 2012
SELECT tourney_name AS Tournament, winner_name AS Winner, winner_rank as Winner_Ranking, 
loser_name AS Loser, loser_rank AS Loser_Ranking, Score
FROM Tennis.matches2012
WHERE score LIKE "6-0%" OR score LIKE "0-6%" OR score LIKE "%6-0" OR score LIKE "%0-6"

#Hmm, thats more than I expected. Search for the ones who received a bagel and still won
SELECT tourney_name AS Tournament, winner_name AS Winner, winner_rank as Winner_Ranking, 
loser_name AS Loser, loser_rank AS Loser_Ranking, Score
FROM Tennis.matches2012
WHERE score LIKE "0-6%" OR score LIKE "%0-6"

#This one shows all of the matches lost by Roger Federer during these years
SELECT CONCAT(tourney_name," ",SUBSTR(tourney_id,1,4)) AS Tournament,  winner_name AS Winner, winner_rank as Winner_Ranking, 
loser_name AS Loser, loser_rank AS Loser_Ranking, Score FROM
(SELECT * FROM Tennis.matches2010
UNION 
SELECT * FROM Tennis.matches2011
UNION 
SELECT * FROM Tennis.matches2012
UNION 
SELECT * FROM Tennis.matches2013
UNION 
SELECT * FROM Tennis.matches2014
UNION 
SELECT * FROM Tennis.matches2015) AS T1
WHERE loser_name = "Roger Federer";

