# m365webapps
Webapps für RDP/RDS Umgebungen

TEAMS führt in RDS/RDP Umgebungen zu sehr hohen CPU und Speicherauslastungen.

# Tipps und Tricks  

## Alle TEAMS Prozesse Killen
Get-Process teams*| foreach {$_.kill()}  

## Deinstallation von TEAMS  
TEAMS kann über verschiedene Möglichkeiten installiert worden sein  
1. Office Setup   
2. Machine Wide Installation  
3. Im User Contex (APPDATA)  

