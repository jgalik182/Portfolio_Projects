# Credit Card Fraud Detection — ML Project

## Overview
Analysis of 284,807 credit card transactions to detect fraudulent 
activity using anomaly detection and machine learning. The dataset 
contains a 0.17% fraud rate — a real-world class imbalance challenge 
that required specific techniques to build an effective model.

## Key Findings
- Fraud transactions averaged $122 vs $88 for legitimate transactions
- Fraudsters avoided large amounts — max fraud was $2,125 vs $25,691 legitimate
- No strong time-of-day clustering in fraud activity
- Feature V14 was the strongest fraud predictor (importance score: 0.237)

## Approach
1. **Exploratory Data Analysis** — Distributions, fraud patterns, class imbalance
2. **Baseline Model** — Isolation Forest achieved only 25% precision/recall 
   due to severe class imbalance (492 fraud vs 284,315 legitimate transactions)
3. **Improved Model** — Applied SMOTE to balance training data, then trained 
   a Random Forest classifier

## Results

| Model | Precision | Recall | F1 Score |
|-------|-----------|--------|----------|
| Isolation Forest (baseline) | 25% | 25% | 25% |
| Random Forest + SMOTE | 84% | 83% | 84% |

**Final model performance on held-out test set:**
- Fraud cases caught: 81 of 98 (83% recall)
- False alarms generated: 15
- Legitimate transactions correctly cleared: 56,849

## Why This Matters
In fraud detection, recall is the critical metric — every missed fraud 
case represents real financial loss. Accuracy alone is misleading when 
the dataset is this imbalanced. A model predicting "everything is 
legitimate" would be 99.8% accurate but completely useless.

Applying SMOTE to address class imbalance improved all metrics by 3x 
and produced a model that would be viable as a first-pass fraud screening 
layer in a real payments environment.

## Tools & Libraries
- Python (pandas, numpy, scikit-learn, imbalanced-learn)
- Matplotlib, Seaborn
- JupyterLab

## Data Source
[Kaggle Credit Card Fraud Detection Dataset](https://www.kaggle.com/datasets/mlg-ulb/creditcardfraud)
— 284,807 transactions, 492 confirmed fraud cases, 48-hour window
