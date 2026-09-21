#----------------------------------------------------------------
# Run 01_prep_photopoints_for_viz.R before running this script
# Appends latest year of veg and site data to existing datasets
#----------------------------------------------------------------
library(tidyverse)
library(wetlandACAD)
#setwd("./wetlandViz")

importRAM(export_protected = T) # have to include protected for VMMI calculation. 
# Protected species are dropped before written to disk.

path <- paste0(getwd(), "/data/")

#--- VMMI data update ---
# All sites, including SEN. Need to update SEN labels to match photopoint label names
vmmi <- sumVegMMI(site = "all", years = 2022:2026, panel = c(-1, 1, 2, 3, 4)) |> 
  mutate(Label = ifelse(Panel > 0, gsub("R-", "RAM-", SiteCode), SiteCode))

sitedata <- read.csv(paste0(path, 'Sentinel_and_USA-RAM_Sites_2026.csv'))
sitelabs <- sitedata |> filter(Panel == -1) |> 
  mutate(SiteCode = paste0("NWCA11-", substr(Site, 5, 8))) |> 
  select(Label, SiteCode) 

vmmi <- left_join(vmmi, sitelabs, by = "SiteCode") |> 
  mutate(Label = ifelse(Panel > 0, Label.x, Label.y)) |> 
  select(-Label.x, -Label.y)

vmmi_site <- left_join(vmmi, sitedata, by = c("Label", "Panel")) |> 
  select(SiteCode, Label, Year, Visit_Type, Mean_C = meanC, Invasive_Cover, 
         Pct_Cov_TolN = Cover_Tolerant, Sphagnum_Cover = Bryophyte_Cover,
         VMMI = vmmi, VMMI_Rating = vmmi_rating) |> 
  mutate(across(c(Mean_C, Invasive_Cover, Sphagnum_Cover, Pct_Cov_TolN, VMMI),
                \(x) round(x, 2))) |> 
  arrange(SiteCode, Year)

head(vmmi_site)

# combine RAM and NWCA sites
table(vmmi_site$Year)
write.csv(vmmi_site, paste0(path, "vmmi_2022-2026.csv"), row.names = F)

#--- Species data update ---
sppdata_new <- sumSpeciesList(years = 2022:2026, panel = c(-1, 1, 2, 3, 4)) |> 
  mutate(Label = ifelse(grepl("R", SiteCode), gsub("R-", "RAM-", SiteCode), SiteCode)) |> 
  left_join(sitelabs, by = "SiteCode") |> 
  mutate(Label = ifelse(Panel > 0, Label.x, Label.y)) |> 
  select(-Label.x, -Label.y) |> 
  mutate(Site_Type = ifelse(grepl("RAM", Label), "RAM", "SEN")) |> 
  select(Latin_Name = ScientificName, Common = CommonName, Label, Longitude, Latitude, Site_Type, Year, 
         PctFreq = quad_freq, Invasive, Protected_species) |> 
  filter(Protected_species == FALSE) |> 
  arrange(Label, Latin_Name = F)

table(sppdata_new$Protected_species) # all F

write.csv(sppdata_new, paste0(path, "Sentinel_and_RAM_species_data_2022-2026.csv"), row.names = F)
