### Install the latest version from Github:

library(devtools)
install_github("tylermorganwall/rayshader")

# read full documentation in: https://github.com/tylermorganwall/rayshader

### Loading packages

library(rayshader)
library(tidyverse)
library(data.table)

### Autor example

mtplot <-  ggplot(mtcars) + 
  geom_point(aes(x = mpg, y = disp, color = hp)) + 
  theme_minimal()

par(mfrow = c(1, 2))
plot_gg(mtplot, width = 3.5, raytrace = FALSE, preview = TRUE)

plot_gg(mtplot, width = 3.5, multicore = TRUE, windowsize = c(800, 800), 
        zoom = 0.85, phi = 35, theta = 30, sunangle = 225, soliddepth = -100)

Sys.sleep(0.2)
render_snapshot(clear = TRUE)


### Class notes

## Read data

# The ENEM (National High School Exam) dataset for the year 2018 was used, considering only the important variables for the study

db <- file.choose()

db <- fread(db, dec = ";") # i use the fread function because full data set is very large

#  Grade of all students from DF who were present on all test days

db1 <- db %>% 
  select(SG_UF_ESC, TP_PRESENCA_CH, TP_PRESENCA_CN, TP_PRESENCA_LC, TP_PRESENCA_MT, 
         NU_NOTA_CN, NU_NOTA_CH, NU_NOTA_LC, NU_NOTA_MT, NU_NOTA_REDACAO) %>% 
  filter(SG_UF_ESC == "DF") %>% # separated by DF 
  filter(TP_PRESENCA_CH == 1 && TP_PRESENCA_LC == 1 && TP_PRESENCA_CN == 1 && TP_PRESENCA_MT == 1) # students present in the 4 test days

db1$NU_NOTA_CN <- as.numeric(db1$NU_NOTA_CN)
db1$NU_NOTA_MT <- as.numeric(db1$NU_NOTA_MT)
db1$NU_NOTA_REDACAO <- as.numeric(db1$NU_NOTA_REDACAO)

# reducing the size of the data set simulating the number of students in a class

db1 <- db1[c(1:40), ] %>% 
  na.omit()

### plot

mtplot <-  ggplot(db1) + 
  geom_point(aes(x = NU_NOTA_MT, y = NU_NOTA_CN, color = NU_NOTA_REDACAO)) + 
  labs(x = "Nota Matemática", y = "Nota Ciências da Natureza", col = "Nota Redação") +
  theme_minimal()

plot_gg(mtplot, width = 3.5, multicore = TRUE, windowsize = c(800, 800), 
        zoom = 0.85, phi = 35, theta = 30, sunangle = 225, soliddepth = -100)

Sys.sleep(0.2)
render_snapshot(clear = TRUE)
