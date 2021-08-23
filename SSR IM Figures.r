---
title: "Sclerotinia Stem Rot Integrated Management Figures"
author: "R.W. Webster"
date: "8/12/2021"
output: html_document
---

Loading Packages
```{r}
library(cowplot)
library(ggplot2)
library(viridis)
```
Figure 1
Map of locations in this study
```{r}
# Define objects for all counties and states in the US
AllCounty <- map_data("county")
MainStates <- map_data("state")

# Define the trial locations and create new data frame "locs" from these vectors
names <- c("Dekalb, IL", "Lewiston, MN", "Arlington, WI", "Hancock, WI", "Montfort, WI", "Kanawha, IA", "Nashua, IA", "Entrican, MI", "Owatonna, MN", "Stewertville, MN")
lat <- c(41.8442, 43.9807, 43.3182, 44.1211, 42.9589, 42.9327, 42.9379, 43.3516, 44.0198, 43.8443)
long <- c(-88.8491, -91.9180, -89.3319, -89.5386, -90.3990, -93.7976, -92.5698, -85.1755, -93.3820, -92.3543)
trial <- c("Fully Integrated Trials","Fully Integrated Trials","Fully Integrated Trials","Fully Integrated Trials","Fully Integrated Trials","Partially Integrated Trials","Partially Integrated Trials","Partially Integrated Trials","Partially Integrated Trials","Partially Integrated Trials")
locs <- data.frame(names, lat, long, trial)


# Create map in ggplot
ggplot() + 
  geom_polygon( data=AllCounty, aes(x=long, y=lat, group=group),
                color="gray", fill="lightgray", size = .1 ) +
  geom_polygon( data=MainStates, aes(x=long, y=lat, group=group),
                color="black", fill="lightgray",  size = 1, alpha = 0.3) +
  coord_cartesian(xlim=c(-100, -82), 
                  ylim=c(37, 48)) +
  geom_point(data=locs, aes(x=long, y=lat, col=trial, shape=trial), 
             size=5) +
  geom_label(data=locs, aes(x=long, y=lat, label=names),
             size=5, 
             label.r = unit(0.2, "lines"),
             label.size=.15, 
             nudge_y=c(-0.37,0.37,-0.33,0.38,-0.4,0.25,-0.35,-0.35,0.5,-0.35), 
             nudge_x=c(0.75, 0.65, 1.15, 1.0, 0.5,-1.35,0.25,0.95,-1,0.5)) +
  theme_test() +
  theme(axis.title.x = element_blank(),
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank(),
        axis.title.y = element_blank(),
        axis.text.y = element_blank(), 
        axis.ticks.y = element_blank(),
        legend.position = c(0.82, 0.94), 
        legend.title = element_blank(),
        legend.text = element_text(size=16, face="bold"))
```


Loading SAS Output
```{r}
# Fuly Integrated Locations
full_rowxfung <- read.table(text="Fung	Row	logDIX	logDIX_SE	logDIX_letter	logDIX_BT
                                  Standard	38	1.1976	0.1244	b	3.31
                                  Model	38	1.1286	0.1157	b	3.09
                                  Non-Treated	38	1.4887	0.1171	a	4.43
                                  Standard	76	0.6824	0.1223	b	1.98
                                  Model	76	1.1873	0.1145	a	3.28
                                  Non-Treated	76	1.0697	0.1137	a	2.91",
                                  header=T)
  full_rowxfung$Row <- as.factor(full_rowxfung$Row)

full_rowxpop <- read.table(text="Row	Pop	Yield	Yield_SE	Yield_letter
                                38	270,000	5263.01	80.3838	c
                                38	345,000	5471.83	80.0805	b
                                38	420,000	5736.44	80.2665	a
                                38	495,000	5866.65	80.227	a
                                76	270,000	5104.68	79.8185	b
                                76	345,000	5140.63	80.5494	ab
                                76	420,000	5256.68	80.1384	a
                                76	495,000	5271.29	79.7506	a", 
                                header=T)
  full_rowxpop$Row <- as.factor(full_rowxpop$Row)
  full_rowxpop$Pop <- as.factor(full_rowxpop$Pop)

full_fung <- read.table(text="Fung	Yield	Yield_SE	Yield_letter
                              Standard	5495.03	64.3879	a
                              Model	5365.76	64.3309	b
                              Non-Treated	5305.92	64.3509	b",
                              header=T)

# Partially Integrated Locations
part_pop <- read.table(text="Pop	logDIX	logDIX_SE	logDIX_letter	Yield	Yield_SE	Yield_letter
                            270,000	1.9042	0.2114	b	3955.44	81.508	b
                            345,000	2.4802	0.2286	a	4177.16	81.508	a
                            420,000	2.3619	0.1844	a	4241.09	81.508	a
                            495,000	2.7404	0.1989	a	4202.9	81.508	a",
                            header=T)
  part_pop$Pop <- as.factor(part_pop$Pop)

part_fung <- read.table(text="Fung	logDIX	logDIX_SE	logDIX_letter	Yield	Yield_SE	Yield_letter
                              Standard	1.3918	0.4088	b	4214.24	78.9076	a
                              Model	1.7913	0.404	a	4149.85	78.9076	ab
                              Non-Treated	1.7912	0.3974	a	4068.36	78.9076	b",
                              header=T)
```
Figure 2
Figures for Fully Integrated DIX
```{r}
full_rowxfung$Fung <- factor(full_rowxfung$Fung, levels = c("Non-Treated", "Model", "Standard"))
Fig2A <- ggplot(data=full_rowxfung, aes(x=Row, y=logDIX, fill=Fung)) + 
        geom_bar(stat="identity", position="dodge", color="black", size=0.75) +
        geom_errorbar(aes(ymin=(logDIX-logDIX_SE), ymax=(logDIX+logDIX_SE)), width=0.1, position=position_dodge(width=0.9)) +
        theme_bw() +
        coord_cartesian(ylim=c(0.1,2)) +
        geom_text(aes(label=logDIX_letter), vjust=-1.3, size=7, position=position_dodge(width=0.9)) +
        scale_fill_viridis(option="mako", discrete=T) +
        xlab("Row Spacing (cm)") +
        ylab("Sclerotinia Stem Rot\nDisease Severity Index (DIX)") +
        labs(fill="Fungicide Program") +
        theme(axis.title.y = element_text(size=15, face="bold"),
              axis.title.x = element_text(size=15, face="bold"),
              axis.text = element_text(size=16), 
              legend.title = element_text(size=15),
              legend.text = element_text(size=14)) +
        annotate(geom="text", label="A", x=1, y=1.9, size=8) +
        annotate(geom="text", label="B", x=2, y=1.9, size=8) +
        annotate(geom="segment", x=0.55, xend=0.95, y=1.90, yend=1.90) + ## For A line left horizontal
        annotate(geom="segment", x=1.05, xend=1.45, y=1.90, yend=1.90) + ## For A line right horizontal
        annotate(geom="segment", x=0.55, xend=0.55, y=1.95, yend=1.85) + ## For A line left vertical
        annotate(geom="segment", x=1.45, xend=1.45, y=1.95, yend=1.85) + ## For A line right vertical 
        annotate(geom="segment", x=1.55, xend=1.95, y=1.90, yend=1.90) + ## For B line left horizontal
        annotate(geom="segment", x=2.05, xend=2.45, y=1.90, yend=1.90) + ## For B line right horizontal
        annotate(geom="segment", x=1.55, xend=1.55, y=1.95, yend=1.85) + ## For B line left vertical
        annotate(geom="segment", x=2.45, xend=2.45, y=1.95, yend=1.85)   ## For B line right vertical 

Fig2B <- ggplot(data=full_rowxpop, aes(x=Row, y=Yield, fill=Pop)) + 
        geom_bar(stat="identity", position="dodge", color="black", size=0.75) +
        geom_errorbar(aes(ymin=(Yield-Yield_SE), ymax=(Yield+Yield_SE)), width=0.1, position=position_dodge(width=0.9)) +
        geom_text(aes(label=Yield_letter), vjust=-0.75, size=7, position=position_dodge(width=0.9)) +
        coord_cartesian(ylim=c(4000,6500)) +
        theme_bw() +
        scale_fill_viridis(option="cividis", discrete=T) + 
        xlab("Row Spacing (cm)") +
        ylab(bquote(bold('Yield (kg'~ha^-1*')'))) + 
        #labs(fill="Planting Population\n(seeds/ha)", size=25) +
        labs(fill=expression(atop("Seeding Rate", paste("(seeds ha"^"-1",")"))), size=25) +
        theme(axis.title.y = element_text(size=15, face="bold"),
              axis.title.x = element_text(size=15, face="bold"),
              axis.text = element_text(size=16), 
              legend.title = element_text(size=15),
              legend.text = element_text(size=14)) +
        annotate(geom="text", label="A", x=1, y=6350, size=8) +
        annotate(geom="text", label="B", x=2, y=6350, size=8) +
        annotate(geom="segment", x=0.55, xend=0.95, y=6350, yend=6350) + ## For A line left horizontal
        annotate(geom="segment", x=1.05, xend=1.45, y=6350, yend=6350) + ## For A line right horizontal
        annotate(geom="segment", x=0.55, xend=0.55, y=6425, yend=6275) + ## For A line left vertical
        annotate(geom="segment", x=1.45, xend=1.45, y=6425, yend=6275) + ## For A line right vertical 
        annotate(geom="segment", x=1.55, xend=1.95, y=6350, yend=6350) + ## For B line left horizontal
        annotate(geom="segment", x=2.05, xend=2.45, y=6350, yend=6350) + ## For B line right horizontal
        annotate(geom="segment", x=1.55, xend=1.55, y=6425, yend=6275) + ## For B line left vertical
        annotate(geom="segment", x=2.45, xend=2.45, y=6425, yend=6275)   ## For B line right vertical 

## Combined Figure 2
ggdraw() +
  draw_plot(Fig2A, 0.07, .5, .945, .48) +
  draw_plot(Fig2B, 0.07, 0, .90, .48) +
  draw_plot_label(c("A", "B"), c(0.05, 0.05), c(1.01, 0.51), size = 20)

```
Figure 3
Figures for Fully Integrated Yield
```{r}
full_fung$Fung <- factor(full_fung$Fung, levels = c("Non-Treated", "Model", "Standard"))
Fig3 <- ggplot(data=full_fung, aes(x=Fung, y=Yield, fill=Fung)) + 
        geom_bar(stat="identity", color="black", size=0.75, width=0.9, position="dodge") +
        geom_errorbar(aes(ymin=(Yield-Yield_SE), ymax=(Yield+Yield_SE)), width=0.1, position=position_dodge(width=0.9)) +
        geom_text(aes(label=Yield_letter), vjust=-1, size=7) +
        coord_cartesian(ylim=c(4000,6500)) +
        theme_bw() +
        scale_fill_viridis(option="mako", discrete=T) + 
        xlab("Fungicide Treatment Application") +
        ylab(bquote(bold('Yield (kg'~ha^-1*')'))) + 
        theme(axis.title.y = element_text(size=15, face="bold"),
              axis.title.x = element_text(size=15, face="bold"),
              axis.text = element_text(size=16),
              legend.position = "none")
print(Fig3)
```
Figure 4 
Figure for Partially Integrated Seeding Rate
```{r}
#### Partially Integrated - Population (Simple) ####
  # DIX
Fig4A <-  ggplot(data=part_pop, aes(x=Pop, y=logDIX, fill=Pop)) + 
    geom_bar(stat="identity", color="black", size=0.75) + 
    theme_bw() +
    coord_cartesian(ylim=c(0.18,3.5)) +
    geom_text(aes(label=logDIX_letter),
                  size=7,
                  hjust=0.5,
                  vjust=-1.25) +
    ylab("Sclerotinia Stem Rot\nDisease Severity Index (DIX)") +
    xlab(bquote(bold('Seeding Rate (seeds'~ha^-1*')'))) +
    geom_errorbar(aes(ymin=(logDIX-logDIX_SE), ymax=(logDIX+logDIX_SE)), width=0.1) +
    scale_fill_viridis(option="cividis", discrete=T) +
    theme(axis.title.y = element_text(size=15, face="bold"),
          axis.title.x = element_text(size=15, face="bold"),
          axis.text = element_text(size=16),
          legend.position = "none")
    
    
  # Yield (kg/ha)
Fig4B <- ggplot(data=part_pop, aes(x=Pop, y=Yield, fill=Pop)) + 
    geom_bar(stat="identity", color="black", size=0.75) + 
    theme_bw() +
    coord_cartesian(ylim=c(3750,4500)) +
    geom_text(aes(label=Yield_letter),
                  size=7,
                  hjust=0.5,
                  vjust=-1.85) +
    ylab(bquote(bold('Yield (kg'~ha^-1*')'))) +
    xlab(bquote(bold('Seeding Rate (seeds'~ha^-1*')'))) +
    geom_errorbar(aes(ymin=(Yield-Yield_SE), ymax=(Yield+Yield_SE)), width=0.1) +
    scale_fill_viridis(option="cividis", discrete=T) +
    theme(axis.title.y = element_text(size=15, face="bold"),
          axis.title.x = element_text(size=15, face="bold"),
          axis.text = element_text(size=16),
          legend.position = "none")

# Combine Figure 4
  ggdraw() +
  draw_plot(Fig4A, 0.07, .5, .91, .48) +
  draw_plot(Fig4B, 0.07, 0, .91, .48) +
  draw_plot_label(c("A", "B"), c(0.05, 0.05), c(1.01, 0.51), size = 20)
```

Figure 5 
Figure for Partially Integrated Fungicide
```{r}
#### Partially Integrated - Fungicide  ####
part_fung$Fung <- factor(part_fung$Fung, levels = c("Non-Treated", "Model", "Standard"))
  # DIX
Fig5A <- ggplot(data=part_fung, aes(x=Fung, y=logDIX, fill=Fung)) + 
    geom_bar(stat="identity", color="black", size=0.75) + 
    theme_bw() +
    coord_cartesian(ylim=c(0.18,3.5)) +
    geom_text(aes(label=logDIX_letter),
                  size=7,
                  hjust=0.5,
                  vjust=-2.0) +
    ylab("Sclerotinia Stem Rot\nDisease Severity Index (DIX)") +
    xlab("Fungicide Treatment Program") +
    geom_errorbar(aes(ymin=(logDIX-logDIX_SE), ymax=(logDIX+logDIX_SE)), width=0.1) +
    scale_fill_viridis(option="mako", discrete=T) +
    theme(axis.title.y = element_text(size=15, face="bold"),
          axis.title.x = element_text(size=15, face="bold"),
          axis.text = element_text(size=16),
          legend.position = "none")
  
  # Yield (kg/ha)
Fig5B <- ggplot(data=part_fung, aes(x=Fung, y=Yield, fill=Fung)) + 
    geom_bar(stat="identity", color="black", size=0.75) + 
    theme_bw() +
    coord_cartesian(ylim=c(3750,4500)) +
    geom_text(aes(label=Yield_letter),
                  size=7,
                  hjust=0.5,
                  vjust=-1.6) +
    ylab(bquote(bold('Yield (kg'~ha^-1*')'))) +
    xlab("Fungicide Treatment Program") +
    geom_errorbar(aes(ymin=(Yield-Yield_SE), ymax=(Yield+Yield_SE)), width=0.1) +
    scale_fill_viridis(option="mako", discrete=T) +
    theme(axis.title.y = element_text(size=15),
          axis.title.x = element_text(size=15, face="bold"),
          axis.text = element_text(size=16),
          legend.position = "none")
## Combined Figure 5
ggdraw() +
  draw_plot(Fig5A, 0.05, .5, .92, .48) +
  draw_plot(Fig5B, 0.05, 0, .92, .48) +
  draw_plot_label(c("A", "B"), c(0.04, 0.04), c(1.01, 0.51), size = 20)
```