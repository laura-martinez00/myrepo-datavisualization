library(readr)
library(dplyr)
library(glue)
library(scales)
library(sf)
library(ggforce)
library(patchwork)
library(ggplot2)
library(cowplot)
library(maps)
library(ggnewscale)
library(ggtext)
library(ggmap)
library(RColorBrewer)
library(mapproj)


setwd("~/Desktop/Master/Data visualization/Data visualization final")


# 1. LOADING AND FIXING THE DATA

referendum <- read_csv("EU-referendum-result-data.csv")

uk_shp <- read_sf("uk_constituencies_2016.shp")
ireland_shp <- read_sf("IRL_adm1.shp")

length(st_geometry(uk_shp))
length(st_geometry(ireland_shp))

# eliminate meaningless columns: 
uk_shp$ID <- NULL
ireland_shp$ID_0 <- NULL
ireland_shp$ISO <- NULL
ireland_shp$NAME_0 <- NULL
ireland_shp$TYPE_1 <- NULL
ireland_shp$ENGTYPE_1 <- NULL
ireland_shp$NL_NAME_1 <- NULL
ireland_shp$VARNAME_1 <- NULL


names(ireland_shp)[names(ireland_shp) == "NAME_1"] <- "area_name"
names(ireland_shp)[names(ireland_shp) == "ID_1"] <- "area_code"

uk_shp <- st_transform(uk_shp, crs = st_crs("EPSG:4326"))
ireland_shp <- st_transform(ireland_shp, crs = st_crs("EPSG:4326"))


#look at their coordinates systems
print(st_crs(uk_shp))
print(st_crs(ireland_shp))

#Merge shapefiles

uk_shp1 <- rbind(uk_shp, ireland_shp)

referendum <- referendum |> 
  rename(area_code = Area_Code)

#Merge with dataset

brexit_data <- left_join(uk_shp1, referendum, by = "area_code")

#West Tyrone
brexit_data$Pct_Turnout[18] <- 61.8
brexit_data$Remain[18] <- 26765
brexit_data$Leave[18] <- 13274
brexit_data$Pct_Remain[18] <- 66.8
brexit_data$Pct_Leave[18] <- 33.2

#Upper Bann
brexit_data$Pct_Turnout[17] <- 63.8
brexit_data$Remain[17] <- 24550
brexit_data$Leave[17] <- 27262
brexit_data$Pct_Remain[17] <- 47.4
brexit_data$Pct_Leave[17] <- 52.6

#Strangford
brexit_data$Pct_Turnout[16] <- 64.5
brexit_data$Remain[16] <- 18727
brexit_data$Leave[16] <- 23383
brexit_data$Pct_Remain[16] <- 44.5
brexit_data$Pct_Leave[16] <- 55.5

#South Down
brexit_data$Pct_Turnout[15] <- 62.4
brexit_data$Remain[15] <- 32076
brexit_data$Leave[15] <- 15625
brexit_data$Pct_Remain[15] <- 67.2
brexit_data$Pct_Leave[15] <- 32.8

#South Antrim
brexit_data$Pct_Turnout[14] <- 63.4
brexit_data$Remain[14] <- 21498
brexit_data$Leave[14] <- 22055
brexit_data$Pct_Remain[14] <- 49.4
brexit_data$Pct_Leave[14] <- 50.6

#North Down
brexit_data$Pct_Turnout[13] <- 67.7
brexit_data$Remain[13] <- 23131
brexit_data$Leave[13] <- 21046
brexit_data$Pct_Remain[13] <- 52.4
brexit_data$Pct_Leave[13] <- 47.6

#North Antrim
brexit_data$Pct_Turnout[12] <- 64.9
brexit_data$Remain[12] <- 18782
brexit_data$Leave[12] <- 30938
brexit_data$Pct_Remain[12] <- 37.8
brexit_data$Pct_Leave[12] <- 62.2

#Newry and Armagh
brexit_data$Pct_Turnout[11] <- 63.7
brexit_data$Remain[11] <- 31963
brexit_data$Leave[11] <- 18659
brexit_data$Pct_Remain[11] <- 62.9
brexit_data$Pct_Leave[11] <- 37.1

#Mid Ulster
brexit_data$Pct_Turnout[10] <- 61.7
brexit_data$Remain[10] <- 25612
brexit_data$Leave[10] <- 16799
brexit_data$Pct_Remain[10] <- 60.4
brexit_data$Pct_Leave[10] <- 39.6

#Lagan Valley
brexit_data$Pct_Turnout[9] <- 66.6
brexit_data$Remain[9] <- 22710
brexit_data$Leave[9] <- 25704
brexit_data$Pct_Remain[9] <- 46.9
brexit_data$Pct_Leave[9] <- 53.1

#Foyle
brexit_data$Pct_Turnout[8] <- 57.4
brexit_data$Remain[8] <- 32064
brexit_data$Leave[8] <- 8905
brexit_data$Pct_Remain[8] <- 78.3
brexit_data$Pct_Leave[8] <- 21.7

#Fermanagh and South Tyrone
brexit_data$Pct_Turnout[7] <- 67.9
brexit_data$Remain[7] <- 28200
brexit_data$Leave[7] <- 19958
brexit_data$Pct_Remain[7] <- 58.6
brexit_data$Pct_Leave[7] <- 41.4

#East Londonderry
brexit_data$Pct_Turnout[6] <- 69.9
brexit_data$Remain[6] <- 21098
brexit_data$Leave[6] <- 19455
brexit_data$Pct_Remain[6] <- 52.0
brexit_data$Pct_Leave[6] <- 48.0

#East Antrim
brexit_data$Pct_Turnout[5] <- 65.2
brexit_data$Remain[5] <- 18616
brexit_data$Leave[5] <- 22929
brexit_data$Pct_Remain[5] <- 44.8
brexit_data$Pct_Leave[5] <- 55.2

#Belfast West
brexit_data$Pct_Turnout[4] <- 48.9
brexit_data$Remain[4] <- 23099
brexit_data$Leave[4] <- 8092
brexit_data$Pct_Remain[4] <- 74.1
brexit_data$Pct_Leave[4] <- 25.9

#Belfast South
brexit_data$Pct_Turnout[3] <- 67.6
brexit_data$Remain[3] <- 30960
brexit_data$Leave[3] <- 13596
brexit_data$Pct_Remain[3] <- 69.5
brexit_data$Pct_Leave[3] <- 30.5

#Belfast North
brexit_data$Pct_Turnout[2] <- 57.5
brexit_data$Remain[2] <- 20128
brexit_data$Leave[2] <- 19844
brexit_data$Pct_Remain[2] <- 50.4
brexit_data$Pct_Leave[2] <- 49.6

#Belfast East
brexit_data$Pct_Turnout[1] <- 66.5
brexit_data$Remain[1] <- 20728
brexit_data$Leave[1] <- 21918
brexit_data$Pct_Remain[1] <- 48.6
brexit_data$Pct_Leave[1] <- 51.4

brexit_data$Region_Code <- NULL
brexit_data$Region <- NULL
brexit_data$id <- NULL
brexit_data$Area <- NULL

# 2. CREATING TWO SCALES

# Making a winner column
brexit_data <- mutate(brexit_data, winner = if_else(Pct_Remain > Pct_Leave, "Remain", "Leave"))

#Add ireland as Pct_leave to have it in gray
brexit_data$winner[399:424] <- "Leave"

# Creating two different data frames
leave_df <- brexit_data[brexit_data$winner == "Leave",]
remain_df <- brexit_data[brexit_data$winner == "Remain",]

# 3. FONTS FOR THE MAP

if (!requireNamespace("extrafont", quietly = TRUE)) {
  install.packages("extrafont")
}
library(extrafont)

# Load extrafont and import fonts
font_import("Lora")

# Specify a different font family
par(family = "Times")  

#Add fonts

sysfonts::font_add_google("Lora", family="Lora")
sysfonts::font_add_google("DM Serif Display", family="DM Serif Display")
showtext::showtext_auto()



# 4. TAGS FOR THE MAP

leave_df <- leave_df |> 
  mutate(country = case_when(
    substr(area_code, 1, 1) == "E" ~ "England",
    substr(area_code, 1, 1) == "N" ~ "Northern Ireland",
    substr(area_code, 1, 1) == "W" ~ "Wales",
    substr(area_code, 1, 1) == "S" ~ "Scotland",
    TRUE ~ NA_character_
  )) 
leave_df <- leave_df |> 
  select(country, everything())

remain_df <- remain_df |> 
  mutate(country = case_when(
    substr(area_code, 1, 1) == "E" ~ "England",
    substr(area_code, 1, 1) == "N" ~ "Northern Ireland",
    substr(area_code, 1, 1) == "W" ~ "Wales",
    substr(area_code, 1, 1) == "S" ~ "Scotland",
    TRUE ~ NA_character_
  )) 
remain_df <- remain_df |> 
  select(country, everything())

#Dataframe of tags
country_tag <- data.frame(
  country = c("Scotland", "England", "Wales", "Nothern \nIreland"),
latitude = c(56.999651, 54.383331, 52.000, 55.360043), 
longitude = c(-4.809075, -1.866667, -4.933, -7.707558)
)




# 5. CREATE THE PLOT

map <- ggplot() +
  geom_sf(data = remain_df,
          aes(fill = Pct_Remain),
          colour = "white",
          lwd = 0.1) +
  scale_fill_stepsn(
    colors = c("lightskyblue1", "steelblue1", "dodgerblue", "dodgerblue4"),
    breaks = c(50, 60, 70, 80),
    labels = c("", "", "", ""),
    limits = c(50, 90),
    name = "Remain", 
    guide = guide_colorsteps(
      even.steps = TRUE,
      order = 1,
      ticks = TRUE,
      ticks.colour = "black",
      ticks.linewidth = 0.5,
      direction = "horizontal",
      title = "Remain",
      draw.llim = TRUE,
      draw.ulim = TRUE,
      frame.color = "black",
      label.theme = element_text(size = 7))) +
  new_scale_fill() +
  geom_sf(data = leave_df,
          aes(fill = Pct_Leave),
          colour = "white",
          lwd = 0.1) +
  scale_fill_stepsn(
    colors = c("bisque", "lightsalmon", "orangered", "red3"),
    breaks = c(50, 60, 70, 80),
    labels = c("50%", "", "", "80%"),
    limits = c(50, 90),
    name = "Leave",
    na.value = "gray87", 
    guide = guide_colorsteps(
      even.steps = TRUE,
      order = 1,
      ticks = TRUE,
      ticks.colour = "black",
      ticks.linewidth = 0.5,
      direction = "horizontal",
      title = "Leave",
      draw.llim = TRUE,
      draw.ulim = TRUE,
      frame.color = "black",
      label.theme = element_text(size = 7))) +
  geom_text(data = country_tag,
            aes(x = longitude, y = latitude, label = country),
            color = "black",
            size = 2.5, fontface = "bold",
            family = "Lora") +
  theme_minimal() +
  labs(title = "           How Britain Voted in the E.U. Referendum",
       x = NULL, 
       y = NULL, 
       fill = "Should Britain remain in the European Union?") +
  theme(legend.title = element_text(size = 9),
        plot.title = element_text(hjust = 0, vjust = 0.5, face = "bold"),
        legend.position = c(0.15, 0.85),
        text = element_text(family = "DM Serif Display",  size = 15),
        axis.text = element_blank(),
        axis.title = element_blank(),
        axis.ticks = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        legend.direction = "horizontal",
        legend.box = "vertical",
        legend.box.just = "right",
        legend.key.size = unit(0.4, "cm"), 
        legend.text = element_text(size = 6),
        legend.spacing.y = unit(0, "cm"))
map


# Expand coordinates of map

expanded_xmin <- -11.653038
expanded_xmax <- 4.382762
expanded_ymin <- 49.41625
expanded_ymax <- 61.529979

# Modify coord_sf() to include expanded limits
map <- map +
  coord_sf(xlim = c(expanded_xmin, expanded_xmax),
           ylim = c(expanded_ymin, expanded_ymax))

print(map)



# 6. ADD TAGS TO THE MAP

#Cities annotations
cities <- data.frame(
  city = c("London", "Manchester", "Cardiff", "Birmingham", "Edinburgh", "Liverpool", "Oxford", "Belfast"),
  latitude = c(51.509865, 53.4794, 51.4861, 52.479876, 55.9410, 53.3549, 51.750051, 54.5930),
  longitude = c(-0.118092, -2.2437, -3.1801, -1.9058, -3.29181, -3.0104, -1.25386, -5.9381))

#MAP
map1 <- map+
  geom_circle(data = cities,
              aes(x0 = longitude, y0 = latitude, r=0.2),  
              stat= "circle",color = "gray48" , fill = NA, 
              size = 0.2)+ 
  geom_text(data = cities[c(2, 3, 4, 7), ], aes(x = longitude, y = latitude, label = city),
            vjust = -2.5, size = 1.5, fontface = "bold", color = "gray24") +
  geom_text(data = cities[c(1, 5), ], aes(x = longitude, y = latitude, label = city),
            vjust = 3.6 , size = 1.5, fontface = "bold", color = "gray24") +
  geom_text(data = cities[6,], aes(x = longitude, y = latitude, label = city),
            hjust = 1.3, size = 1.5, fontface = "bold", color = "gray24") +
  geom_text(data = cities[8,], aes(x = longitude, y = latitude, label = city),
            hjust = -0.5, size = 1.5, fontface = "bold", color = "gray24") +
  theme(aspect.ratio = 1.15)
map1



# 7. LONDON CLOSE-UP


# Code that DOES work but is not round or adjusted to the bottom right  
locations <- data.frame(
  rbind(
    c("London", -0.58913, 0.3520155, 51.2318741, 51.7167602),
    c("Manchester", -2.4034, -2.0937, 53.3794, 53.5501),
    c("Cardiff", -3.3124, -3.0971, 51.4461, 51.5521),
    c("Birmingham", -2.0450, -1.6958, 52.3538, 52.5578),
    c("Edinburgh", -3.3278, -3.0481, 55.8910, 55.9880),
    c("Liverpool", -3.0917, -2.8125, 53.3321, 53.4586),
    c("Oxford", -1.2994, -1.1280, 51.7149, 51.7984),
    c("Belfast", -5.9959, -5.8481, 54.6430, 51.5400)
  ),stringsAsFactors = F)

location <- "London" # Change the location as needed

# Extract xlim and ylim values directly from the locations data frame
xlim <- as.numeric(locations[locations[, 1] == location, c(2, 3)])
ylim <- as.numeric(locations[locations[, 1] == location, c(4, 5)])


zoomed_map1 <- map +
  theme(legend.position = "none", plot.title = element_blank(),
        panel.border = element_rect(color = "black", fill = NA, size = 1)) +
  coord_sf(xlim = c(xlim[1], xlim[2]), ylim = c(ylim[1], ylim[2]), crs = 4326) +
  theme(aspect.ratio = 1)
zoomed_map1

# 8. REMAIN-LEAVE BAR PLOT

# Create data frame
df <- data.frame(Region = c("Britain", "England", "London", "Scotland", "Wales", "N. Ireland", " "),
                 Pop_M = c(64.1, 53.0, 8.5, 5.3, 3.0, 1.8, NA),
                 Remain = c(48, 47, 60, 62, 47, 56, NA),
                 Leave = c(52, 53, 40, 38, 53, 44, NA))

# Reorder levels of factor

df$Region <- factor(df$Region, levels = c("London", "N. Ireland", "Wales", "Scotland", "England", "Britain", " "), ordered = is.ordered(df$Region))

bar_plot <- df |> 
  select(Region, Remain, Leave)  |> 
  gather(key, VoteCount, -Region) |> 
  ggplot(aes(x = Region, y = VoteCount, fill = key)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label = ifelse(Region %in% c("N. Ireland", "Scotland", "London"), paste0(VoteCount, "%"), "")),
            position = position_stack(vjust = c(0.4, 0.47)),
            color = "white", fontface = "bold", size = 2) +
  geom_text(aes(label = ifelse(Region %in% c("England", "Wales", "Britain"), paste0(VoteCount, "%"), "")),
            position = position_stack(vjust = c(0.5, 0.6)),
            color = "white", fontface = "bold", size = 2) +
  annotate("text", x=6.7, y= 12, label = "REMAIN",  size = 2)+
  annotate("text", x=6.7, y= 90, label = "LEAVE", size = 2)+
  labs(title = "",
       x = "", y = "") +
  theme_minimal() +
  coord_flip() +
  scale_fill_manual(values = c("Remain" = "dodgerblue3", "Leave" = "red2"))+
  theme(legend.position = "none",
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.text.x = element_blank(),
        axis.text.y = element_text(face = "bold", color = "black", size = 6, hjust = 0, family = "Lora"))+
  geom_hline(yintercept = 50, linetype = "dashed", color = "white", size=0.2)
bar_plot



# 9. LONDON ZOOM-UP LINES

#LINEs
origin1 <- c(-0.090525, 51.757161)
end1 <- c(1.954604, 52.518733)
origin2 <- c(-0.100525, 51.240399)
end2 <- c(1.954604, 50.959038)

line1 <- data.frame(x = c(origin1[1], end1[1]), y = c(origin1[2], end1[2]))
line2 <- data.frame(x = c(origin2[1], end2[1]), y = c(origin2[2], end2[2]))

map2 <- map1 +
  geom_segment(data = line1,
               aes(x = x[1], y = y[1], xend = x[2], yend = y[2]),
               color = "grey38", linetype = "dashed", size = 0.13) +
  geom_segment(data = line2,
               aes(x = x[1], y = y[1], xend = x[2], yend = y[2]),
               color = "grey38", linetype = "dashed", size = 0.13)
map2


# 10. GLUE OPTIONS

# OPTION 1

#map1 + inset_element(zoomed_map1, 0, 0.08, 1.9, 0)


# OPTION 2
#map_closeup <- plot_grid(map1, zoomed_map1, ncol = 2, align = "v",rel_widths = c(2, 0.5), rel_heights = c(4, 1))
#map_closeup

# OPTION 3

# Specify coordinates for the zoomed map
xmin <- 1.4
xmax <- 5.5
ymin <- 50.7
ymax <- 52.7

#specify coordinates for the bar plot
xmin1 <- -2
xmax1 <- 5.5
ymin1 <- 55.5
ymax1 <- 60.5

# Combine the maps into one
combined_map <- annotation_custom(grob = ggplotGrob(zoomed_map1), 
                                xmin = xmin, xmax = xmax, 
                                ymin = ymin, ymax = ymax)

combined_bar <- annotation_custom(grob = ggplotGrob(bar_plot), 
                                  xmin = xmin1, xmax = xmax1, 
                                  ymin = ymin1, ymax = ymax1)


# Create combination of all plots
plot_w_addins <- map2 + combined_map + combined_bar
plot_w_addins


# 11. FINAL ANNOTATIONS

#Scotland
point1 <- c(-0.666206, 55.598766)
point2 <- c(-2.456146, 56.080442)
point3 <- c(-0.59, 55.152745)
annotation_text1 <- "The Scottish first minister has said that a leave\nvote could trigger a referendum vote in\nScotland to leave Britain. Scots rejected\nindependence in a referendum in September\n2014 by 55 percent to 45 percent."

#London

point4 <- c(1.930838, 53.16749)
annotation_text2 <- "London, along with Scotland,\nled the vote to remain in the\nEuropean Union, though the\neast side of the city voted to\nleave."

#Ireland
point5 <- c(-7.84579, 55.970628)
point6 <- c(-6.506151, 55.300913)
point7 <- c(-11.220845, 56.260588)
annotation_text3 <- "Northern Ireland shares a\ncompletely porous border with\nIreland, which is in the\nEuropean Union. Trade issues\ncould arise between the two."

#Wales
point8 <- c(-5.517893, 50.843996)
point9 <- c(-4.524143, 51.599867)
point10 <- c(-9.527097, 50.85646)
annotation_text4 <- "The majority of Wales voted\nstrongly to leave, except for the\nlargest city Cardiff, which voted to\nremain by 60 percent."

# Legend title
point11 <- c(-9.750845, 61.260588)
annotation_text5 <- "Should Britain remain\nin the European Union?"

#final plot
plot_w_addins+
  geom_curve(aes(x = point1[1], y = point1[2], xend = point2[1], yend = point2[2]),
             curvature = 0.3,  # Adjust curvature as needed
             arrow = arrow(length = unit(0.05, "cm")),  # Add an arrow at the end
             color = "gray51") +
  geom_curve(aes(x = point5[1], y = point5[2], xend = point6[1], yend = point6[2]),
             curvature = -0.3,  # Adjust curvature as needed
             arrow = arrow(length = unit(0.05, "cm")),  # Add an arrow at the end
             color = "gray51") +
  geom_curve(aes(x = point8[1], y = point8[2], xend = point9[1], yend = point9[2]),
             curvature = 0.3,  # Adjust curvature as needed
             arrow = arrow(length = unit(0.05, "cm")),  # Add an arrow at the end
             color = "gray51") +
  annotate("text", x = point3[1], y = point3[2],
           label = annotation_text1, size = 1.7, color = "black", family = "Lora", hjust = 0) +
  annotate("text", x = point4[1], y = point4[2],
           label = annotation_text2, size = 1.7, color = "black", family = "Lora", hjust = 0) +
  annotate("text", x = point7[1], y = point7[2],
           label = annotation_text3, size = 1.7, color = "black", family = "Lora", hjust = 0) +
  annotate("text", x = point10[1], y = point10[2],
           label = annotation_text4, size = 1.7, color = "black", family = "Lora", hjust = 0) +
  annotate("text", x = point11[1], y = point11[2],
           label = annotation_text5, size = 3.3, color = "black", family = "Lora", fontface = "bold", hjust = 0.5) +
  theme_minimal()+
  theme(legend.title = element_text(size = 9),
        plot.title = element_text(hjust = 0, vjust = 0.5, face = "bold"),
        legend.position = c(0.15, 0.85),
        text = element_text(family = "DM Serif Display",  size = 15),
        axis.text = element_blank(),
        axis.title = element_blank(),
        axis.ticks = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        legend.direction = "horizontal",
        legend.box = "vertical",
        legend.box.just = "right",
        legend.key.size = unit(0.4, "cm"), 
        legend.text = element_text(size = 6),
        legend.spacing.y = unit(0, "cm"))




