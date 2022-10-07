#This new database contains results from 2008 to 2022
SELECT DISTINCT(SUBSTR(Date,1,4)) AS Year
FROM Tennis.tennis_data td 

#All matches lost by Federer in those years (Database doesnt include the score in a single column so I had to concat each set)
SELECT CONCAT(Tournament," ",SUBSTR(date,1,4)) AS Tournament, Winner, WRank, Loser, LRank, 
CASE WHEN W5 IS NOT NULL THEN CONCAT(W1,"-",L1," ",W2,"-",L2," ",W3,"-",L3," ",W4,"-",L4," ",W5,"-",L5)
WHEN W4 IS NOT NULL THEN CONCAT(W1,"-",L1," ",W2,"-",L2," ",W3,"-",L3," ",W4,"-",L4)
WHEN W3 IS NOT NULL THEN CONCAT(W1,"-",L1," ",W2,"-",L2," ",W3,"-",L3) 
WHEN W2 IS NOT NULL THEN CONCAT(W1,"-",L1," ",W2,"-",L2) 
WHEN W1 IS NOT NULL THEN CONCAT(W1,"-",L1)
WHEN W1 IS NULL THEN "Walkover" 
END AS Score
FROM Tennis.tennis_data 
WHERE Loser = "Federer R.";

#All matches lost by Nadal and Djokovic at a GS
SELECT CONCAT(Tournament," ",SUBSTR(date,1,4)) AS Tournament, Winner, WRank, Loser, LRank, 
CASE WHEN W5 IS NOT NULL THEN CONCAT(W1,"-",L1," ",W2,"-",L2," ",W3,"-",L3," ",W4,"-",L4," ",W5,"-",L5)
WHEN W4 IS NOT NULL THEN CONCAT(W1,"-",L1," ",W2,"-",L2," ",W3,"-",L3," ",W4,"-",L4)
WHEN W3 IS NOT NULL THEN CONCAT(W1,"-",L1," ",W2,"-",L2," ",W3,"-",L3) 
WHEN W2 IS NOT NULL THEN CONCAT(W1,"-",L1," ",W2,"-",L2) 
WHEN W1 IS NOT NULL THEN CONCAT(W1,"-",L1)
WHEN W1 IS NULL THEN "Walkover" 
END AS Score
FROM Tennis.tennis_data 
WHERE Series = "Grand Slam" AND Loser = "Nadal R." OR Series = "Grand Slam" AND Loser = "Djokovic N."

#Count how many GS matches were lost by each member of the Big 3 
SELECT Loser, COUNT(Loser) AS Defeats
FROM Tennis.tennis_data m1
WHERE Series = "Grand Slam" AND Loser = "Nadal R." OR Series = "Grand Slam" AND Loser = "Djokovic N." OR Series = "Grand Slam" AND Loser = "Federer R."
GROUP BY Loser
ORDER BY Defeats DESC

SELECT Winner, COUNT(Winner) AS Wins
FROM Tennis.tennis_data m2
WHERE Series = "Grand Slam" AND Winner = "Nadal R." OR Series = "Grand Slam" AND Winner = "Djokovic N." OR Series = "Grand Slam" AND Winner = "Federer R."
GROUP BY Winner
ORDER BY Wins DESC

#Show the 10 lowest players to beat a top 50 player
SELECT CONCAT(Tournament," ",SUBSTR(date,1,4)) AS Tournament, Winner, WRank, Loser, LRank, 
CASE WHEN W5 IS NOT NULL THEN CONCAT(W1,"-",L1," ",W2,"-",L2," ",W3,"-",L3," ",W4,"-",L4," ",W5,"-",L5)
WHEN W4 IS NOT NULL THEN CONCAT(W1,"-",L1," ",W2,"-",L2," ",W3,"-",L3," ",W4,"-",L4)
WHEN W3 IS NOT NULL THEN CONCAT(W1,"-",L1," ",W2,"-",L2," ",W3,"-",L3) 
WHEN W2 IS NOT NULL THEN CONCAT(W1,"-",L1," ",W2,"-",L2) 
WHEN W1 IS NOT NULL THEN CONCAT(W1,"-",L1)
WHEN W1 IS NULL THEN "Walkover" 
END AS Score
FROM Tennis.tennis_data 
WHERE  WRank IS NOT NULL AND LRank IS NOT NULL AND LRank <=50
ORDER BY WRank DESC
LIMIT 10;

#Oof, I want to test for top 10 now haha
SELECT CONCAT(Tournament," ",SUBSTR(date,1,4)) AS Tournament, Winner, WRank, Loser, LRank, 
CASE WHEN W5 IS NOT NULL THEN CONCAT(W1,"-",L1," ",W2,"-",L2," ",W3,"-",L3," ",W4,"-",L4," ",W5,"-",L5)
WHEN W4 IS NOT NULL THEN CONCAT(W1,"-",L1," ",W2,"-",L2," ",W3,"-",L3," ",W4,"-",L4)
WHEN W3 IS NOT NULL THEN CONCAT(W1,"-",L1," ",W2,"-",L2," ",W3,"-",L3) 
WHEN W2 IS NOT NULL THEN CONCAT(W1,"-",L1," ",W2,"-",L2) 
WHEN W1 IS NOT NULL THEN CONCAT(W1,"-",L1)
WHEN W1 IS NULL THEN "Walkover" 
END AS Score
FROM Tennis.tennis_data 
WHERE  WRank IS NOT NULL AND LRank IS NOT NULL AND LRank <=10
ORDER BY WRank DESC
LIMIT 10;

#Top 1?
SELECT CONCAT(Tournament," ",SUBSTR(date,1,4)) AS Tournament, Winner, WRank, Loser, LRank, 
CASE WHEN W5 IS NOT NULL THEN CONCAT(W1,"-",L1," ",W2,"-",L2," ",W3,"-",L3," ",W4,"-",L4," ",W5,"-",L5)
WHEN W4 IS NOT NULL THEN CONCAT(W1,"-",L1," ",W2,"-",L2," ",W3,"-",L3," ",W4,"-",L4)
WHEN W3 IS NOT NULL THEN CONCAT(W1,"-",L1," ",W2,"-",L2," ",W3,"-",L3) 
WHEN W2 IS NOT NULL THEN CONCAT(W1,"-",L1," ",W2,"-",L2) 
WHEN W1 IS NOT NULL THEN CONCAT(W1,"-",L1)
WHEN W1 IS NULL THEN "Walkover" 
END AS Score
FROM Tennis.tennis_data 
WHERE  WRank IS NOT NULL AND LRank IS NOT NULL AND LRank <=1
ORDER BY WRank DESC
LIMIT 10;

#Whos lost the most finals
SELECT Loser, COUNT(Loser) AS Finals_Lost
FROM Tennis.tennis_data m2
WHERE Round = "The Final"
GROUP BY Loser
ORDER BY Finals_Lost DESC
LIMIT 10;

#Players who won more than 1 title
SELECT Winner, COUNT(Winner) AS Finals_Won
FROM Tennis.tennis_data
WHERE Round = "The Final"
GROUP BY Winner
HAVING COUNT(Winner) > 1
ORDER BY Finals_Won DESC
LIMIT 10;

#Won no titles
SELECT Loser
FROM Tennis.tennis_data
WHERE Loser NOT IN (SELECT Winner FROM Tennis.tennis_data WHERE Round = "The Final" GROUP BY Winner)
GROUP BY Loser

#Now we can use the last query to see whos lost the most finals without winning one (at least during those years)
SELECT Loser, COUNT(Loser) AS Finals_Lost
FROM Tennis.tennis_data m2
WHERE Round = "The Final" AND Loser IN (SELECT Loser
										FROM Tennis.tennis_data
										WHERE Loser NOT IN (SELECT Winner FROM Tennis.tennis_data WHERE Round = "The Final" GROUP BY Winner)
										GROUP BY Loser)
GROUP BY Loser
ORDER BY Finals_Lost DESC
LIMIT 10;

#RIP Benneteau :(, James Blake won some titles years before this dataset has info about btw
