# MLB-Relief-Pitcher-Categorization-and-Analysis

Final project for the Stat 306: Multivariate Sports Analytics class with Professor Bradley A. Hartlaub at Kenyon College. May 7th, 2024.

In this project, I sought to identify MLB relief pitchers who are prone to breaking out (having much more success than they currently are having) if they change their pitching strategy. First, I classified 1,087 MLB relief pitcher seasons from 2018 to 2023 using K-means clustering, which resulted in 7 distinct clusters. These 7 clusters represent 7 different relief pitcher pitching styles/strategies, and are based on only things within a pitcher's control (outcome independent), such as their pitch repertoire, percent of pitches thrown in the strike zone, etc. 

Next, I used gradient boosting (specifically XGBoost) to create 7 different models to predict ERA, a different model for pitchers in each cluster. Then, I applied all 7 models to every pitcher, in order to predict what ERA each pitcher would have had if he were in each of the different clusters. Finally, I looked into a handful of specific case studies of relief pitchers who, according to one of the XGBoost models, would have had a much better season if they had pitched according to the strategy of a different cluster. In multiple examples, these models correctly predict adjustments that relievers made, which led to their increased success. 

This repository includes a 14 page final paper outlining methodology and results, the code (written in R) used to create the models and do the analysis, and the data I considered. If you have any questions or are interested in the process, data, models, code, or analysis, please do not hesitate to reach out!
