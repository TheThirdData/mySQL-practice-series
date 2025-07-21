SELECT *
FROM personality_datasert;

-- 1. Summary of Total Records and Personality Types
SELECT 
  COUNT(*) AS total_records,
  COUNT(DISTINCT Personality) AS unique_personality_types
FROM personality_datasert;

-- 2. Average Behavior Metrics by Personality Type
SELECT 
  Personality,
  AVG(Time_spent_Alone) AS avg_alone_time,
  AVG(Social_event_attendance) AS avg_events,
  AVG(Going_outside) AS avg_outdoor_activity,
  AVG(Post_frequency) AS avg_post_frequency,
  AVG(Friends_circle_size) AS avg_friend_circle
FROM personality_datasert
GROUP BY Personality;

-- 3. Stage Fear vs Personality
SELECT 
  Personality,
  Stage_fear,
  COUNT(*) AS count
FROM personality_datasert
GROUP BY Personality, Stage_fear
ORDER BY Personality;

-- 4. Most Common Trait After Socializing
SELECT 
  Drained_after_socializing,
  COUNT(*) AS total
FROM personality_datasert
GROUP BY Drained_after_socializing
ORDER BY total DESC;

-- 5. Above-Average Social Event Attendance
SELECT *
FROM personality_datasert
WHERE Social_event_attendance > (
  SELECT AVG(Social_event_attendance)
  FROM personality_datasert
);

-- 6. Personality Types with Amount of Outdoor Activity in Hours
SELECT Personality, AVG(Going_outside) AS avg_outdoors
FROM personality_datasert
GROUP BY Personality
ORDER BY avg_outdoors DESC;

-- 7. Self-Join to Match Users with Similar Friend Circle Size, not less than 2
SELECT A.Personality AS person_a, B.Personality AS person_b,
       A.Friends_circle_size, B.Friends_circle_size
FROM personality_datasert A
JOIN personality_datasert B
  ON ABS(A.Friends_circle_size - B.Friends_circle_size) <= 2
WHERE A.Personality != B.Personality;

-- 8. Social Activity Classification Using CASE
SELECT *,
  CASE 
    WHEN Social_event_attendance >= 8 THEN 'Highly Social'
    WHEN Social_event_attendance BETWEEN 4 AND 7 THEN 'Moderately Social'
    ELSE 'Less Social'
  END AS social_level
FROM personality_datasert;

-- 9. Custom Introvert vs Extrovert Classification
SELECT *,
  CASE 
    WHEN Time_spent_Alone > 7 AND Drained_after_socializing = 'Yes' THEN 'Likely Introvert'
    WHEN Time_spent_Alone < 4 AND Drained_after_socializing = 'No' THEN 'Likely Extrovert'
    ELSE 'Ambivert or Undefined'
  END AS personality_label
FROM personality_datasert;

-- 10. Rank Users by Post Frequency On Social Media Within Each Personality
SELECT Post_frequency,
  RANK() OVER (PARTITION BY Personality ORDER BY Post_frequency DESC) AS post_rank
FROM personality_datasert;

-- 11. Rolling Average of Going Outside (example)
SELECT *,
  AVG(Going_outside) OVER (ORDER BY Going_outside ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS rolling_avg_outdoor
FROM personality_datasert;

-- 12. Detect Duplicate Records.
SELECT *,
  ROW_NUMBER() OVER (PARTITION BY Personality, Stage_fear, Time_spent_Alone ORDER BY Personality) AS row_num
FROM personality_datasert;

-- 13. Subquery + CASE: Label Users Based on Above-Average Post Frequency for Their Personality
SELECT *,
  CASE 
    WHEN Post_frequency > (
        SELECT AVG(Post_frequency)
        FROM personality_datasert AS p2
        WHERE p2.Personality = p1.Personality
    ) THEN 'Active Poster'
    ELSE 'Less Active'
  END AS posting_behavior
FROM personality_datasert AS p1;
