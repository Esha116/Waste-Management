# Waste-Management
This project aims to develop a model capable of predicting waste load and enabling more efficient waste management solutions.

## Tools & Techniques
MySQL & Python in Google Colab.


## Dataset
The dataset consists of almost 750,000 records. The source: [open data portal of City of Austin](https://data.austintexas.gov/Utilities-and-City-Services/Waste-Collection-Diversion-Report-daily-/mbnu-4wq9/about_data).

10% of the dataset consists of missing fields which were drpoped for better analysis.


## Methods
This project combines SQL-based preprocessing and Python-driven analysis to deliver actionable insights into waste management processes.
### Part 1: SQL Analysis
- Data Aggregation: SUM(), MAX() to calculate total and maximum waste loads.
- Grouping: GROUP BY for drop-off sites, load types, and time periods.
- Window Functions: RANK() and PARTITION BY to analyze site-specific and daily trends.
- Date/Time: HOUR(), MONTHNAME() to extract daily and seasonal patterns.
- Joins and Subqueries: Used to link dominant load types with their maximum contributions.

### Part 2: Python Analysis

3 Types of RNN models were trained and evaluated.
- Vanilla RNN
- LSTM
- GRU

Compared to the Vanilla RNN and GRU models, the LSTM showed better stability and convergence, avoiding issues like exploding or vanishing gradients. 

## Results
This project can be deployed to help city planners in optimizing waste collection routes and schedules, allocating resources efficiently to high-demand areas, engaging communities and stakeholders in waste reduction efforts and designing long-term infrastructure plans based on the insights. To overcome the limitations of the project like making its application more generalized to other cities, we would like to advice to gather more past and upcoming dataset of different cities to draw city specific waste management strategies.
