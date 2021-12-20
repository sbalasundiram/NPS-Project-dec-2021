-----------------------------------*******************STEP 1 : NPS SURVEY TITLES ARE MAPPED TO THE QUESTIONS ASKED IN THE SURVEY*********************______________________________
-----------------------------------***************NORMALIZED THE SURVEY QUESTIONS AND SAVED THEM AS NAME_STD*************------------------------------
create table "MIRANTIS"."ANALYST"."NPS_SURVEYQUESTIONS_SBALASUNDIRAM_1272021" as

select s."Id" as "SurveyId",
s."Name",
s."ActiveVersionId",
q."Name" as "Questionname",
q."QuestionType",
q."Id" as "QuestionId",
 case when q."Name" like ('%recommend%') then 'Recommend Mirantis to a Friend?' 
     when q."Name" like ('%continue%using%') then 'Continue using Mirantis Products?'
     when q."Name" like('%satisfied%') then 'Satisfied with Customer service?'end as "Name_Std"
from "MIRANTIS"."SALESFORCE"."SFDC_SYNC_SURVEY" s
left join "MIRANTIS"."SALESFORCE"."SFDC_SYNC_SURVEYQUESTION" q on s."ActiveVersionId"=q."SurveyVersionId"
where q."QuestionType"='NPS'
order by s."Name"


----------------------------------------************************SURVEY RESPONSE TABLE GENERATION*****************************------------------------

//SELECT 
//sr."SurveyId",
//sr."Name" as "SurveyName",
//sr."ActiveVersionId",
//sr."Questionname",
//sr."QuestionType",
//--sr."QuestionId",
//sr."Name_Std" as "StandardQuestion",
// qr."Id" as "SurveyQuestionResponseId",
//qr."ResponseShortText",
//qr."CreatedDate",
//qr."QuestionId",
//qr."SurveyVersionId",
//qr."InvitationId",
//qr."ResponseId"from "MIRANTIS"."ANALYST"."NPS_SURVEYQUESTIONS_SBALASUNDIRAM_1272021" sr 
//left join "MIRANTIS"."SALESFORCE"."SFDC_SYNC_SURVEYQUESTIONRESPONSE"  qr on sr."QuestionId"=qr."QuestionId"
// order by 2

-------------************************************CREATE CONSOLIDATED SURVEY TABLE*************************************************----------------------------------------
create table "MIRANTIS"."ANALYST"."NPS_SURVEYRESPONSEFINAL_SBALASUNDIRAM_1272021" AS

SELECT qr.* ,
sr."Id" as "SurveyResponseId",
sr."Name" as "CandidateName",
sr."CreatedDate" as "SR_CreatedDate",
sr."Status",
sr."Latitude",
sr."Longitude",
sr."IpAddress",
sr."SurveyVersionId" as "SR_SurveyVersionId",
sr."SurveyId" as "SR_SurveyId"

FROM "MIRANTIS"."ANALYST"."NPS_SURVEYQUESTIONRESPONSE_SBALASUNDIRAM_1272021" qr 
left join
"MIRANTIS"."SALESFORCE"."SFDC_SYNC_SURVEYRESPONSE" sr
on qr."ResponseId"=sr."Id"
order by "CandidateName"

---------------********************************************************************************************************************------------------------------------
select * from "MIRANTIS"."SALESFORCE"."SFDC_SYNC_SURVEYINVITATION" where "Unsubscribed__c"='FALSE'
drop table "MIRANTIS"."ANALYST"."NPS_SURVEYQUESTIONS_SBALASUNDIRAM_1272021"
