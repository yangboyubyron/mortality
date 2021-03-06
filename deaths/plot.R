library(ggplot2)
library(DALEX)

data_mortality <- read.csv("data_mortality_11_2020.csv")
data_covid <- read.csv("data_covid_11_2020.csv")


ggplot(data_mortality, aes(x = week, y = deaths, group = year)) +
  geom_line(aes(col = is2020)) +
  geom_line(data = data_covid, aes(x = week, y = deaths)) +
  facet_wrap(~ country, scales = 'free_y') +
  scale_color_manual(values = c("FALSE" = 'gray', "TRUE" = 'red')) +
  guides(col = FALSE)


country <- c("Austria", "Belgium", "Denmark", "France", "Germany", "Italy", "Poland", "Portugal", "Spain", "Sweden", "Switzerland", "United_States")
country <- c("Belgium", "Italy", "Poland", "Spain")
country <- unique(deaths_2020$country)

data_mortality_2020 <- data_mortality[data_mortality$is2020,]

deaths_2020 <- merge(data_covid, data_mortality_2020, by = c("year","week","country"))
deaths_2020$deaths.x <- pmax(0, deaths_2020$deaths.x)
deaths_2020$net <- deaths_2020$deaths.y - deaths_2020$deaths.x

ggplot(data_mortality[data_mortality$country %in% country,], aes(x = week, y = deaths, group = year)) +
  geom_ribbon(data = deaths_2020[deaths_2020$country %in% country,], aes(x = week, ymin = net, ymax = deaths.y, y = deaths.y), alpha=0.3, fill = "red") +
  geom_line(aes(col = is2020), alpha=0.5) +
  geom_line(data = deaths_2020[deaths_2020$country %in% country,], aes(y = deaths.y, col = is2020)) +
  facet_wrap(~ country, scales = 'free_y', ncol = 3) +
#  facet_wrap(~ country, ncol = 3) +
  scale_color_manual(values = c("FALSE" = 'gray', "TRUE" = 'red')) +
  guides(col = FALSE)  + DALEX::theme_ema() + ylim(0,NA) +
  ggtitle("Number of deaths in 2000-2020. Red - data for 2020. Ribbon - covid deaths")



country <- c("Poland", "Spain")
ggplot(data_mortality[data_mortality$country %in% country,], aes(x = week, y = deaths, group = year)) +
  geom_ribbon(data = deaths_2020[deaths_2020$country %in% country,], aes(x = week, ymin = net, ymax = deaths.y, y = deaths.y), alpha=0.3, fill = "red") +
  geom_line(aes(col = is2020), alpha=0.5) +
  geom_line(data = deaths_2020[deaths_2020$country %in% country,], aes(y = deaths.y, col = is2020)) +
  geom_smooth(data = data_mortality[!data_mortality$is2020 &  data_mortality$country %in% country ,], aes(group=country), se=FALSE, alpha=0.5, size=0.5,color = "black") +
  facet_wrap(~ country, scales = 'free_y', ncol = 5) +
  scale_color_manual(values = c("FALSE" = 'gray', "TRUE" = 'red')) +  ylim(0,NA) +
  guides(col = FALSE)  + DALEX::theme_ema() + xlab("Tydzień w roku") + ylab("Liczba zgonów") +
  ggtitle("Liczba zgonów w latach 2000-2020.","Czerwona linia to zgony w roku 2020, \nczerwone pola to zgony raportowane jako COVID-19.\n") +
  geom_vline(xintercept = seq(0,50,5), lty=3, color="grey") +
  geom_hline(yintercept = 0, color="grey") +
  theme(plot.subtitle = element_text(hjust = 0))

