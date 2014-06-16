# ---------- MODEL ----------
# Sets
set Teams;
set GroupsNames;
set GroupsTeams within GroupsNames cross Teams;

set Stadiums;

param startDay;
param endDay;
set Days := startDay .. endDay;

param minDaysBetweenMatches;

param maxMatchesPerDay;

# Variables
var matches{g in GroupsNames, t1 in Teams, t2 in Teams, d in Days, s in Stadiums : t1 < t2 and (g,t1) in GroupsTeams and (g,t2) in GroupsTeams}, binary;
var playedOnDays{t in Teams, d in Days}, binary;
#var lastday, integer, default 0;

# Constrains
#subject to setLastDay{t in Teams, d in Days} : 
#  playedOnDays[t,d] * d,
#  <= lastDay;

subject to numOfMatches:
  sum{g in GroupsNames, t1 in Teams, t2 in Teams, d in Days, s in Stadiums : t1 < t2 and (g,t1) in GroupsTeams and (g,t2) in GroupsTeams} matches[g, t1, t2, d, s],
   == sum{g in GroupsNames} sum{t1 in Teams, t2 in Teams : t1 < t2 and (g,t1) in GroupsTeams and (g,t2) in GroupsTeams} 1;

subject to vsAllTeamsInGroups{g in GroupsNames, t1 in Teams : (g,t1) in GroupsTeams} : 
  sum{d in Days} playedOnDays[t1,d],
  == card(setof{t2 in Teams : t1 != t2 and (g,t2) in GroupsTeams}(t2));

subject to playedOn{t1 in Teams, d in Days} :
  sum{g2 in GroupsNames, t2 in Teams, s2 in Stadiums : t1  < t2 and (g2,t1) in GroupsTeams and (g2,t2) in GroupsTeams} matches[g2, t1, t2, d , s2] +
  sum{g3 in GroupsNames, t3 in Teams, s3 in Stadiums : t3 < t1 and (g3,t1) in GroupsTeams and (g3,t3) in GroupsTeams} matches[g3, t3, t1, d , s3],
  == playedOnDays[t1,d];
  
subject to noConcurrentMatches{d in Days, s in Stadiums} : 
  sum{g in GroupsNames, t1 in Teams, t2 in Teams : t1 < t2 and (g,t1) in GroupsTeams and (g,t2) in GroupsTeams} matches[g, t1, t2, d , s],
  <= 1;
  
subject to noSameMatch{g in GroupsNames, t1 in Teams, t2 in Teams : t1 < t2 and (g,t1) in GroupsTeams and (g,t2) in GroupsTeams} :
  sum{d in Days, s in Stadiums} matches[g, t1, t2, d, s]   
  <= 1;
  
subject to noSameStadium{t1 in Teams, s in Stadiums} : 
  sum{g2 in GroupsNames, t2 in Teams, d2 in Days : t1 < t2 and (g2,t1) in GroupsTeams and (g2,t2) in GroupsTeams} matches[g2, t1, t2, d2 , s] +
  sum{g3 in GroupsNames, t3 in Teams, d3 in Days : t3 < t1 and (g3,t1) in GroupsTeams and (g3,t3) in GroupsTeams} matches[g3, t3, t1, d3 , s],
  <= 1;

subject to daysBetweenMatches{t in Teams, d1 in Days} : 
  sum{d2 in Days : d1 <= d2 and d2 <= d1 + minDaysBetweenMatches } playedOnDays[t,d2],
  <= 1; 

subject to matchesPerDay{d in Days} : 
  sum{t in Teams} playedOnDays[t,d],
  <= maxMatchesPerDay * 2;
  
# Objective
#minimize temporalWindowSize : lastDay;


# ---------- DATA ----------
data;

#Reference: http://it.wikipedia.org/wiki/Campionato_mondiale_di_calcio_2014#Squadre_partecipanti
set Teams := Brasile Giappone Australia Iran Corea_Sud Olanda Italia Stati_Uniti Costa_Rica Argentina Belgio Svizzera Germania Colombia Russia Bosnia_Erzegovina Inghilterra Spagna Cile Ecuador Honduras Costa_Avorio Nigeria Camerun Ghana Algeria Grecia Croazia Portogallo Francia Messico Uruguay;

# Reference: http://it.wikipedia.org/wiki/Campionato_mondiale_di_calcio_2014#Fase_a_gironi
set GroupsNames := A B C D E F G H;
set GroupsTeams := 
  (A,*) Brasile Croazia Messico Camerun
  (B,*) Spagna Olanda Cile Australia
  (C,*) Colombia Grecia Costa_Avorio Giappone
  (D,*) Uruguay Costa_Rica Inghilterra Italia
  (E,*) Svizzera Ecuador Francia Honduras
  (F,*) Argentina Bosnia_Erzegovina Iran Nigeria
  (G,*) Germania Portogallo Ghana Stati_Uniti
  (H,*) Belgio Algeria Russia Corea_Sud;

 
# Reference: http://it.wikipedia.org/wiki/Stadi_europei_per_capienza
set Stadiums := Giuseppe_Meazza Stadio_Olimpico San_Paolo San_Nicola Artemio_Franchi Marcantonio_Bentegodi Juventus_Stadium San_Filippo;

param startDay := 1;
param endDay := 14;
param minDaysBetweenMatches := 4;
param maxMatchesPerDay := 4;

end;
