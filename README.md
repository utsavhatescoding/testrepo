# Studying the Impact of COVID-19 on Banking Stability in BRICS Countries

## Abstract

This study investigates the impact of the COVID-19 pandemic on banking stability across BRICS economies using a panel dataset of publicly listed commercial banks from 2013 to 2024. The findings reveal a statistically significant negative structural break in bank stability during the pandemic period. Although partial recovery is observed post-pandemic, stability does not fully return to pre-pandemic levels. The results further indicate that accommodative monetary policy and regulatory interventions contribute to financial stabilization, while targeted measures exhibit comparatively limited effectiveness. Decomposition of the Z-score suggests that the initial decline in stability is primarily driven by reduced profitability and increased earnings volatility rather than capital deterioration.

---

## 1. Introduction

The COVID-19 pandemic represents one of the most severe global economic disruptions in modern history. Following the declaration of the pandemic by the World Health Organization, emerging market and developing economies experienced unprecedented capital outflows, surpassing those observed during the 2008–2009 Global Financial Crisis.

BRICS economies—Brazil, Russia, India, China, and South Africa—are particularly relevant due to their:

* High reliance on bank-based financial systems
* Exposure to global capital flows
* Structural heterogeneity in regulatory and institutional frameworks

This study examines how an exogenous real-sector shock affects banking stability and evaluates how policy responses influence recovery dynamics.

---

## 2. Research Objectives

The primary objectives of this study are:

* To evaluate the impact of COVID-19 on bank financial stability in BRICS economies
* To identify structural breaks in stability during the pandemic period
* To analyze post-pandemic recovery patterns across countries
* To assess the role of policy interventions in moderating financial instability

---

## 3. Literature Review

Recent literature highlights the systemic impact of COVID-19 on banking performance and financial stability:

* Elnahass et al. (2021) document a significant decline in bank profitability, efficiency, and stability across global samples
* Tran et al. (2022) find increased accounting risk and return volatility during the pandemic
* Government interventions are shown to mitigate adverse effects, though their effectiveness varies across institutional contexts

Despite these contributions, limited research provides a comparative analysis of BRICS economies within a unified empirical framework.

---

## 4. Data and Methodology

### 4.1 Sample Description

The dataset consists of:

* 52 publicly listed commercial banks
* Five BRICS countries (Brazil, Russia, India, China, South Africa)
* Time period: 2013–2024
* Total observations: 624 (balanced panel)

Data sources include:

* Bank financial statements
* World Bank Development Indicators

---

### 4.2 Measurement of Financial Stability

Bank stability is measured using the Z-score:

```
Z_{i,t} = (ROA_{i,t} + CAR_{i,t}) / σ(ROA_{i,t})
```

Where:

* ROA = Return on Assets
* CAR = Capital Adequacy Ratio
* σ(ROA) = Standard deviation of returns

The Z-score represents the distance to insolvency; higher values indicate greater stability.

---

### 4.3 Empirical Model

The study employs a Panel Interrupted Time Series (PITS) framework:

```
ln(Z_{i,t}) = α + β₁ Time_t + β₂ COVID_t + β₃ (Time_t × COVID_t) + γX_{i,t} + μ_i + ε_{i,t}
```

Where:

* `COVID_t` captures the pandemic period
* Interaction term captures post-pandemic trend changes
* `X_{i,t}` includes control variables:

  * Bank size
  * Leverage
  * Loan growth
  * Inflation
  * Financial depth

Bank fixed effects are included to control for unobserved heterogeneity.

---

## 5. Results

### 5.1 Descriptive Statistics

| Variable        | Mean | Std. Dev. | Min   | Max   |
| --------------- | ---- | --------- | ----- | ----- |
| lnZ_score       | 4.08 | 1.34      | -0.72 | 8.14  |
| leverage_pct    | 8.01 | 4.19      | 0.07  | 44.40 |
| loan_growth_pct | 0.09 | 0.26      | -0.50 | 5.15  |

---

### 5.2 Key Findings

* A significant decline in bank stability is observed during COVID-19
* Profitability deterioration is the primary transmission channel
* Capital adjustments occur more gradually
* Recovery patterns differ across BRICS economies
* Broad-based policy interventions are more effective than targeted measures

---

## 6. Conclusion

The COVID-19 pandemic exerted a substantial negative impact on banking stability across BRICS economies. The results emphasize the importance of distinguishing between short-term shock effects and long-term recovery dynamics. Furthermore, policy design plays a critical role in determining the pace and extent of financial recovery.

The findings suggest that coordinated monetary easing and regulatory flexibility are more effective in restoring stability than narrow credit interventions. Despite improvements in the post-pandemic period, persistent scarring effects remain evident.

---

## 7. Limitations and Future Research

This study focuses exclusively on publicly listed banks, which may limit generalizability. Future research could:

* Include non-listed and state-owned banks
* Extend analysis to additional emerging economies
* Apply structural break and time-varying models
* Examine institutional determinants of recovery

---

## Author

Ayush Poudel
Bachelor’s Graduate, Tribhuvan University
