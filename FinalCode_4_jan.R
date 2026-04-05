install.packages(c("readxl","dplyr","janitor","plm","lmtest","sandwich"))
library(readxl)
library(dplyr)
library(janitor)
library(plm)
library(lmtest)
library(sandwich)

df <- read_excel("Copy of masterfile.xlsx", sheet = "Panel_Merged") %>%
  clean_names()xc


library(dplyr)

names(df)xc

library(dplyr)
library(plm)

# Choose the intervention year (commonly 2020)
intervention_year <- 2020

df2 <- df %>%
  arrange(country, bank_name, year) %>%
  mutate(
    bank_id = interaction(bank_name, drop = TRUE),
    country_id = interaction(country , drop = TRUE) ,
    
    lnZ_score = log(z_score),
    
    # Time starts at 1
    Time = year - min(year, na.rm = TRUE) + 1,
    
    Covid = ifelse(year >= intervention_year, 1, 0),
    
    PostCovidTime = ifelse(year >= intervention_year,
                           year - intervention_year ,
                           0),
    
    leverage_pct = leverage_percent,
    loan_growth_pct = loan_growth_percent
  )

covid_start <- 2020
covid_end   <- 2021




## Categorical 
df2 <- df2 %>%
  mutate(
    Covid_f = factor(Covid, levels = c(0, 1))
  )

df2 <- df2 %>%
  mutate(
    Time_Covid = Time * Covid_f
  )

df2$ea_sdroa <- df2$ea_ratio / df2$sd_of_roa_3_year_rolling
df2$aa=log(df2$roa_sdroa)
df2$bb=log(df2$ea_sdroa)

pdata <- pdata.frame(df2, index = c("bank_id", "year"))

pdata$ea_sdroa <- pdata$ea_ratio / pdata$sd_of_roa_3_year_rolling

##Main Model : lnZ_score

sink("Regression_Updated.txt")
m_fe   <- plm(lnZ_score ~ Time + Covid_f + Time:Covid_f + lag(lnZ_score, 1) +
                log_total_assets + leverage_pct + loan_growth_pct + broad_money_gdp + infl_cpi ,
              data = pdata, model = "within")
z
summary(m_fe)
se_fe_cl   <- vcovHC(m_fe,   type = "HC1", cluster = "group")

cat("\n--- Fixed effects (cluster-robust) ---\n")
print(coeftest(m_fe, vcov = se_fe_cl))



## Hausman Test 

m_re <- plm(
  lnZ_score ~ Time + Covid + Time:Covid +
    log_total_assets + leverage_pct + loan_growth_pct + infl_cpi + broad_money_gdp,
  data  = pdata,
  model = "random",
  random.method = "walhus",
  random.dfcor=3
)

hausman_test <- phtest(m_fe, m_re)
hausman_test

sink()
## All 3 regressions : 
m_pool <- plm(lnZ_score ~ Time + Covid_f + Time:Covid_f + lag(lnZ_score, 1) +
                log_total_assets + leverage_pct + loan_growth_pct + gdp_growth + infl_cpi + broad_money_gdp,
              data = pdata, model = "pooling")
m_fe   <- plm(lnZ_score ~ Time + Covid_f + Time:Covid_f + lag(lnZ_score, 1) +
                log_total_assets + leverage_pct + loan_growth_pct + gdp_growth + infl_cpi + broad_money_gdp , data = pdata, model = "within")
m_re   <- plm(lnZ_score ~ Time + Covid_f + Time:Covid_f + lag(lnZ_score, 1) +
                log_total_assets + leverage_pct + loan_growth_pct + gdp_growth + infl_cpi, data = pdata, model = "random")

summary(m_pool)
summary(m_re)
summary(m_fe)

## Robust SE 
se_pool_cl <- vcovHC(m_pool, type = "HC1", cluster = "group")
se_fe_cl   <- vcovHC(m_fe,   type = "HC1", cluster = "group")
se_re_cl   <- vcovHC(m_re,   type = "HC1", cluster = "group")

cat("\n--- Pooled (cluster-robust ) ---\n")
print(coeftest(m_pool, vcov = se_pool_cl))

cat("\n--- Fixed effects (cluster-robust) ---\n")
print(coeftest(m_fe, vcov = se_fe_cl))

cat("\n--- Random effects (cluster-robust) ---\n")
print(coeftest(m_re, vcov = se_re_cl))

sink("Regression_Updated.txt")

cat("Model 1\n")
summary(m_fe)

cat("\n\nRobust Error \n")
print(coeftest(m_fe, vcov = se_fe_cl))

sink()

## Replacing y for CAR , ROA , Total Risk and Beta 

m_fe_roa   <- plm(roa ~ Time + Covid_f + Time:Covid_f + lag(roa, 1) +
                log_total_assets + leverage_pct + loan_growth_pct + gdp_growth + infl_cpi + broad_money_gdp , data = pdata, model = "within")
m_fe_car   <- plm(car_percent ~ Time + Covid_f + Time:Covid_f + lag(car_percent) +
                log_total_assets + leverage_pct + loan_growth_pct + gdp_growth + infl_cpi + broad_money_gdp , data = pdata, model = "within")
m_fe_trisk   <- plm(total_risk_sd ~ Time + Covid_f + Time:Covid_f + lag(total_risk_sd, 1) +
                log_total_assets + leverage_pct + loan_growth_pct + gdp_growth + infl_cpi + broad_money_gdp , data = pdata, model = "within")
m_fe_beta   <- plm(beta ~ Time + Covid_f + Time:Covid_f + lag(beta, 1) +
                log_total_assets + leverage_pct + loan_growth_pct + gdp_growth + infl_cpi + broad_money_gdp , data = pdata, model = "within")

se_fe_roa   <- vcovHC(m_fe_roa,   type = "HC1", cluster = "group")
se_fe_car   <- vcovHC(m_fe_car,   type = "HC1", cluster = "group")
se_fe_trisk   <- vcovHC(m_fe_trisk,   type = "HC1", cluster = "group")
se_fe_beta   <- vcovHC(m_fe_beta,   type = "HC1", cluster = "group")


##_________Countrywise _____________

df_brazil <- df2 %>% filter(country == "BRAZIL")
df_russia <- df2 %>% filter(country == "RUSSIA")
df_china <- df2 %>% filter(country == "CHINA")
df_india <- df2 %>% filter(country == "INDIA")
df_southafrica <- df2 %>% filter(country == "SOUTH AFRICA")

pdata <- pdata.frame(df_southafrica, index = c("bank_id", "year"))

m_fe_southafrica   <- plm(lnZ_score ~ Time + Covid_f + Time:Covid_f + lag(lnZ_score, 1) +
                log_total_assets + leverage_pct + loan_growth_pct + gdp_growth + infl_cpi + broad_money_gdp , data = pdata, model = "within")


summary(m_fe)

se_fe_cl   <- vcovHC(m_fe,   type = "HC1", cluster = "group")

cat("\n--- Fixed effects for South Africa (cluster-robust) ---\n")
print(coeftest(m_fe_southafrica, vcov = se_fe_cl))


##Descriptive Stats

vars <- c(
  "lnZ_score","z_score","log_total_assets", "leverage_pct", "loan_growth_pct",
  "gdp_growth", "infl_cpi", "broad_money_gdp","total_risk_sd" , "roa" , "npl" , "total_assets_usd_bn" , "beta" , "car_percent" 
)

desc_stats <- summary(df[vars])
desc_stats

library(dplyr)
library(tidyr)
library(officer)
library(flextable)

library(psych)

vars <- c("Time","Covid","lnZ_score","log_total_assets","leverage_pct","loan_growth_pct",
  "gdp_growth","infl_cpi","broad_money_gdp","car_percent"
)

desc <- psych::describe(df2[vars])

desc_table <- data.frame(
  Variable = rownames(desc),
  N = desc$n,
  Mean = desc$mean,
  SD = desc$sd,
  Min = desc$min,
  Max = desc$max,
  row.names = NULL
)

library(officer)
library(flextable)

ft <- flextable(desc_table) |>
  colformat_num(j = c("Mean","SD","Min","Max"), digits = 3) |>
  set_header_labels(
    Variable = "Variable",
    N = "N",
    Mean = "Mean",
    SD = "Std. Dev.",
    Min = "Min",
    Max = "Max"
  ) |>
  autofit()

doc <- read_docx() |>
  body_add_par("Table 1: Descriptive Statistics", style = "heading 1") |>
  body_add_flextable(ft)

print(doc, target = "Table_1_Descriptive_Statistics.docx")


##Correlation 

cor_mat <- round(cor(df2[vars], use = "pairwise.complete.obs"), 3)

library(officer)
library(flextable)

cor_df <- as.data.frame(cor_mat)
cor_df <- cbind(Variable = rownames(cor_df), cor_df)
rownames(cor_df) <- NULL

ft_cor <- flextable(cor_df) |>
  autofit()

doc <- read_docx() |>
  body_add_par("Table 2: Correlation Matrix", style = "heading 1") |>
  body_add_flextable(ft_cor)

print(doc, target = "Table_2_Correlation_Matrix.docx")

##VIF 

lm_pool <- lm(
  lnZ_score ~ Time + Covid_f + Time:Covid_f + lag(lnZ_score, 1) +
    log_total_assets + leverage_pct + loan_growth_pct +
    gdp_growth + infl_cpi + broad_money_gdp,
  data = pdata
)

vif(lm_pool)



