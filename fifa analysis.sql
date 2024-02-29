-- 1. Player Performance and Stats:
-- What are the top 10 players based on overall rating (ova) in a specific position?
SELECT name,age,team,main_position,card_rating.ova,wage.value,wage.wage FROM players
JOIN wage ON wage.player_id = players.player_id
JOIN card_rating ON card_rating.player_id = players.player_id
WHERE main_position = 'ST'
ORDER BY ova DESC
LIMIT 10;

SELECT name,age,team,main_position,card_rating.ova,wage.value,wage.wage FROM players
JOIN wage ON wage.player_id = players.player_id
JOIN card_rating ON card_rating.player_id = players.player_id
WHERE main_position = 'LW'
ORDER BY ova DESC
LIMIT 10;

SELECT name,age,team,main_position,card_rating.ova,wage.value,wage.wage FROM players
JOIN wage ON wage.player_id = players.player_id
JOIN card_rating ON card_rating.player_id = players.player_id
WHERE main_position = 'RW'
ORDER BY ova DESC
LIMIT 10;

SELECT name,age,team,main_position,card_rating.ova,wage.value,wage.wage FROM players
JOIN wage ON wage.player_id = players.player_id
JOIN card_rating ON card_rating.player_id = players.player_id
WHERE main_position = 'CM'
ORDER BY ova DESC
LIMIT 10;

SELECT name,age,team,main_position,card_rating.ova,wage.value,wage.wage FROM players
JOIN wage ON wage.player_id = players.player_id
JOIN card_rating ON card_rating.player_id = players.player_id
WHERE main_position = 'CDM'
ORDER BY ova DESC
LIMIT 10;

SELECT name,age,team,main_position,card_rating.ova,wage.value,wage.wage FROM players
JOIN wage ON wage.player_id = players.player_id
JOIN card_rating ON card_rating.player_id = players.player_id
WHERE main_position = 'RB'
ORDER BY ova DESC
LIMIT 10;

SELECT name,age,team,main_position,card_rating.ova,wage.value,wage.wage FROM players
JOIN wage ON wage.player_id = players.player_id
JOIN card_rating ON card_rating.player_id = players.player_id
WHERE main_position = 'CB'
ORDER BY ova DESC
LIMIT 10;

SELECT name,age,team,main_position,card_rating.ova,wage.value,wage.wage FROM players
JOIN wage ON wage.player_id = players.player_id
JOIN card_rating ON card_rating.player_id = players.player_id
WHERE main_position = 'LB'
ORDER BY ova DESC
LIMIT 10;

SELECT name,age,team,main_position,card_rating.ova,wage.value,wage.wage FROM players
JOIN wage ON wage.player_id = players.player_id
JOIN card_rating ON card_rating.player_id = players.player_id
WHERE main_position = 'GK'
ORDER BY ova DESC
LIMIT 10;

-- Height vs dribble?
SELECT a.height,da.agility,da.acceleration,da.movement,da.ball_control,
       da.sprint_speed,da.balance,ca.dri AS dribble 
FROM card_rating ca
JOIN attributes a ON a.player_id = ca.player_id
JOIN dribble_attributes da ON da.player_id = ca.player_id;

-- players who have a high release clause with a lower overall rating?
SELECT p.name,p.team,p.age, w.release_clause, cr.ova
FROM players p
JOIN wage w ON p.player_id = w.player_id
JOIN card_rating cr ON p.player_id = cr.player_id
WHERE w.release_clause > (SELECT PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY release_clause) FROM wage)
  AND cr.ova < (SELECT AVG(ova) FROM card_rating)
ORDER BY w.release_clause DESC, cr.ova ASC
LIMIT 10;

--  Wages and Release Clauses Comparison
SELECT
  ROUND(AVG(CASE WHEN a.age <= 21 THEN w.wage END)) as average_wage_young,
  ROUND(AVG(CASE WHEN a.age <= 21 THEN w.release_clause END)) as average_release_clause_young,
  ROUND(AVG(CASE WHEN a.age > 30 THEN w.wage END)) as average_wage_old,
  ROUND(AVG(CASE WHEN a.age > 30 THEN w.release_clause END)) as average_release_clause_old
FROM wage w
JOIN attributes a ON w.player_id = a.player_id;

-- height distribution by every position
SELECT cr.main_position,a.height FROM card_rating cr
JOIN attributes a ON a.player_id = cr.player_id;

SELECT p.team, ROUND(AVG(ca.ova), 0) AS avg_overall
FROM players p
JOIN card_rating ca ON ca.player_id = p.player_id
WHERE p.team IN ('Arsenal', 'Manchester City', 'Manchester United', 'Chelsea', 'Liverpool')
GROUP BY p.team
ORDER BY avg_overall DESC;

-- What is the Average Player Rating in ST Positions for Each Team?
SELECT 
  p.team,
  ROUND(AVG(cr.ova)) AS avg_position_rating
FROM 
  players p
JOIN 
  card_rating cr ON p.player_id = cr.player_id
WHERE 
  p.team IN ('Arsenal', 'Manchester City', 'Manchester United', 'Liverpool', 'Chelsea')
  AND cr.main_position IN ('ST')
GROUP BY 
  p.team, cr.main_position;

-- How Do Teams Compare in Terms of Homegrown vs. Foreign Players?
SELECT 
  p.team,
  COUNT(CASE WHEN p.nationality = 'England' THEN 1 END) AS homegrown_players,
  COUNT(CASE WHEN p.nationality <> 'England' THEN 1 END) AS foreign_players
FROM 
  players p
WHERE 
  p.team IN ('Arsenal', 'Manchester City', 'Manchester United', 'Liverpool', 'Chelsea')
GROUP BY 
  p.team;
  
-- 6. What is the Distribution of Player Strength and Stamina for Each Team?
SELECT 
  p.team,
  ROUND(AVG(a.strength), 2) AS avg_strength,
  ROUND(AVG(a.stamina), 2) AS avg_stamina
FROM 
  players p
JOIN 
  attributes a ON p.player_id = a.player_id
WHERE 
  p.team IN ('Arsenal', 'Manchester City', 'Manchester United', 'Liverpool', 'Chelsea')
GROUP BY 
  p.team;
  
-- Which Team Has the Fastest Players on Average?
SELECT 
  p.team,
  ROUND(AVG(da.sprint_speed), 2) AS avg_sprint_speed
FROM 
  players p
JOIN 
  dribble_attributes da ON p.player_id = da.player_id
WHERE 
  p.team IN ('Arsenal', 'Manchester City', 'Manchester United', 'Liverpool', 'Chelsea')
GROUP BY 
  p.team
ORDER BY 
  avg_sprint_speed DESC;

