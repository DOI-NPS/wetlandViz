# wetlandViz
This repo contains code to compile data for and run the freshwater wetland visualizer for data collected in 
Acadia NP by the Northeast Temperate Network. 

The following files are part of the repo:  

<ul>
<li>ui.R: user interface for shiny app</li>
<li>server.R: server for shiny app</li>
<li>global.R: global parameters and data frames sourced by shiny app</li>
<li>scripts/: folder containing scripts used to compile/update data for the shiny app </li>
<li>www/: folder containing wetland photopoints, CSS and other objects sourced by the app</li>
<li>boundbox.csv: lat/long coordinates to bound the leaflet map</li>
</ul>

Note that protected species are not included in this dataset, but are available upon request. The data
used for this shiny app are available internally to NPS via NPS DataStore 
<a href = "https://irma.nps.gov/DataStore/Reference/Profile/2320179">record 2320179</a>. The 
public version of the wetland data package is <a href = "https://irma.nps.gov/DataStore/Reference/Profile/2319029"> 
record 2319029</a>.