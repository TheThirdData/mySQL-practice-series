# mySQL-practice-series
Welcome to my SQL-based data analysis project focused on exploring the relationship between personality types and social behavior. This project showcases how SQL can be used to generate behavioral insights from structured data using both foundational and advanced techniques.

📁 Dataset Overview
The dataset used is called personality_datasert and contains the following columns:
Column Name	Data Type	Description
Time_spent_Alone	BIGINT	Average number of hours spent alone daily
Stage_fear	TEXT	Indicates if the individual has stage fright (Yes/No)
Social_event_attendance	BIGINT	Frequency of attending social events
Going_outside	BIGINT	How often the individual goes outside weekly
Drained_after_socializing	TEXT	Whether socializing leaves them mentally drained
Friends_circle_size	BIGINT	Number of close friends
Post_frequency	BIGINT	Number of social media posts per week
Personality	TEXT	Personality type label

🧪 Key Analyses
✅ Behavior Summary by Personality
Used GROUP BY and AVG() to compute average time alone, outdoor activity, and post frequency for each personality.
✅ Social Activity Classification
Created custom labels such as Highly Social, Moderately Social, and Less Social using CASE.
✅ Custom Personality Labeling
Defined Likely Introvert and Likely Extrovert using combinations of solitude and fatigue indicators.
✅ Window Functions
Ranked individuals by social media activity using RANK() and ROW_NUMBER() to reveal standout users.
✅ Subqueries
Identified users whose social event attendance exceeds the dataset average.
✅ Self Join
Paired users from different personality types with similar friend circle sizes to explore possible social overlaps.
✅ Data Cleaning
Detected potential duplicates using ROW_NUMBER() and partitioning by key traits.

📌 Tools Used
SQL (MySQL)

🧠 What I Learned
This project deepened my understanding of how structured query language can be used not just to pull data but to tell powerful stories through logic and segmentation. It also sharpened my ability to combine advanced SQL functions in practical, business-relevant ways.

💼 Let's Collaborate
This is what I do — I help businesses extract valuable insights from their data using SQL and analytical thinking. If you're a company sitting on data but unsure how to leverage it for decision-making, I'm happy to help.

Let’s connect.
