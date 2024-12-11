select question_id  as survey_log 
from SurveyLog
group by question_id 
order by count(iif(action = 'answer',1,0)) / count(iif(action = 'show',1,0)) * 1.0 desc, question_id asc        
