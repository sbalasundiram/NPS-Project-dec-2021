"MIRANTIS"-----***************************************drop created tables*****************************--------------
drop table if exists "MIRANTIS"."ANALYST"."NPS_ACCOUNTTABLE_SBALASUNDIRAM_1282021";

drop table if exists "MIRANTIS"."ANALYST"."NPS_SURVEYRESPONSE_SBALASUNDIRAM_1282021";

drop table if exists "MIRANTIS"."ANALYST"."NPS_SURVEY_SBALASUNDIRAM_1292021";
-------***************************************************************************************---------------
-------------------------------------************************Accounts Table*******************************----------------------------------
--------------------------------------**********Establish Contacts table first. Then join to Accounts Table****************-----------------
CREATE TABLE "MIRANTIS"."ANALYST"."NPS_ACCOUNTTABLE_SBALASUNDIRAM_1282021" as
select distinct s."Id" as "SurveyId",
s."Name" as "SurveyName",
i."Id" as "InvitationId",
i."ParticipantId",
C.CREATED_DATE,
C.ID,
C.OWNER_ID,
C.LAST_NAME,
C.FIRST_NAME,
C.NAME,
C.ACCOUNT_ID,
C.ACCOUNT_TYPE_C,
C.ROLE_C,
C.MAILING_CITY,
C.MAILING_STATE,
C.MAILING_POSTAL_CODE,
C.MAILING_COUNTRY_CODE,
C.TITLE,
C.EMAIL,
C.PHONE,
C.IS_ACTIVE_C,
C.TECHNOLOGY_INTEREST_C,
C.ELIGIBILITY_C,
C.REVENUE_C,
C.SUBSCRIBED_FOR_PRODUCT_UPDATES_C,
C.SUBSCRIBED_FOR_NEWSLETTER_C,
C.SUBSCRIBED_FOR_MARKETING_EMAILS_C,
C.MIRANTIS_RELATIONSHIP_ROLE_C,
C.GEO_C,
C.NPS_PROMOTER_C,
C.NPS_DETRACTOR_C,
C.MEANINGFUL_CONTACT_C,
a.CREATED_BY_ID AS CREATED_BY_ID_ACC,
a.IS_DELETED AS IS_DELETED_ACC,
a.LAST_ACTIVITY_DATE AS LAST_ACTIVITY_DATE_ACC,
a.OWNER_ID as OwnerID_ACC,
a.TYPE AS TYPE_ACC,
a.SHIPPING_STATE_CODE AS SHIPPING_STATE_CODE_ACC,
a.SHIPPING_COUNTRY_CODE AS SHIPPING_COUNTRY_CODE_ACC,
a.ID as ID_ACC,
a.ANNUAL_REVENUE AS ANNUAL_REVENUE_ACC,
a.DESCRIPTION AS DESCRIPTION_ACC,
a.NAME AS NAME_ACC,
a.CREATED_DATE AS CREATED_DATE_ACC,
a.INDUSTRY AS INDUSTRY_ACC,
a.TOP_10_ACCOUNT_C AS TOP_10_ACCOUNT_C_ACC,
a.TOTAL_WON_AMOUNT_C AS TOTAL_WON_AMOUNT_C_ACC,
a.CUSTOMER_TIER_C AS CUSTOMER_TIER_C_ACC,
a.IS_PARTNER AS IS_PARTNER_ACC,
a.ENTITLEMENT_C AS ENTITLEMENT_C_ACC,
a.PARTNER_LEVEL_C AS PARTNER_LEVEL_C_ACC,
a.TP_ACCOUNT_STATUS_C AS TP_ACCOUNT_STATUS_C_ACC,
a.ACCOUNT_C AS ACCOUNT_C_ACC,
a.RESELLER_CONTRACT_SENT_C AS RESELLER_CONTRACT_SENT_C_ACC,
a.ENTITLEMENT_CREATED_C AS ENTITLEMENT_CREATED_C_ACC,
a.LIFETIME_SUBSCRIPTION_SPEND_C AS LIFETIME_SUBSCRIPTION_SPEND_C_ACC,
a.ARR_C AS ARR_C_ACC,
a.LIFETIME_SERVICES_SPEND_C AS LIFETIME_SERVICES_SPEND_C_ACC,
a.ACCOUNT_BAND_C AS ACCOUNT_BAND_C_ACC,
a.ACTIVE_CUSTOMER_C AS ACTIVE_CUSTOMER_C_ACC,
a.PARTNER_ACTIVE_C AS PARTNER_ACTIVE_C_ACC,
a.GEO_C AS GEO_C_ACC,
a.ACCOUNT_HEALTH_C AS ACCOUNT_HEALTH_C_ACC,
a.TECHNOLOGY_SUB_C AS TECHNOLOGY_SUB_C_ACC,
a.ACCOUNT_PROFILE_FIT_6_SENSE_C AS ACCOUNT_PROFILE_FIT_6_SENSE_C_ACC,
a.TECHNOLOGY_C AS TECHNOLOGY_C_ACC,
a.HIGH_GROWTH_TARGET_ACCOUNT_C AS HIGH_GROWTH_TARGET_ACCOUNT_C_ACC,
a.ACCOUNT_OWNER_ID_C AS ACCOUNT_OWNER_ID_C_ACC,
a.ARR_HISTORY_C AS ARR_HISTORY_C_ACC,
a.LAST_ACTIVE_ENTITLEMENT_C AS LAST_ACTIVE_ENTITLEMENT_C_ACC
from "MIRANTIS"."SALESFORCE"."SFDC_SYNC_SURVEY" s
join "MIRANTIS"."SALESFORCE"."SFDC_SYNC_SURVEYINVITATION" i on s."Id"=i."SurveyId"
join "SEGMENT"."SALESFORCE_MIRANTIS"."CONTACTS" c on i."ParticipantId"=c.ID
join "SEGMENT"."SALESFORCE_MIRANTIS"."ACCOUNTS" a on a.id=c.Account_id
ORDER BY C.ID;
-------------------------------&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&----------------------------------------------------
-----------------------------*********************************************^^^^^Survey File^^^^^^********************************************---------------------
--------------------------------***********Find Invitations: Survey.Id -> SurveyInvitation.SurveyId***********************************************---------------
-------------------------------*************Using Invitations, find Responses: SurveyInvitation.Id -> SurveyResponse.SurveyInvitationId**************------------
-------------------------------****************Then get Question Responses: SurveyReponse.Id -> SurveyQuestionResonse.SurveyReponseId****************------------
-------------------------------*****************And finally get the Questions: SurveyQuestionResonse.QuestionId -> SurveyQuestion.Id (edited)*********-----------
--------------++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----------
CREATE TABLE "MIRANTIS"."ANALYST"."NPS_SURVEYRESPONSE_SBALASUNDIRAM_1282021" as
SELECT 
q."Name" as "Questionname",
q."QuestionType",
q."Id" as "QuestionId_Q",
 case when q."Name" like ('%recommend%') then 'Recommend Mirantis to a Friend?' 
     when q."Name" like ('%continue%using%') then 'Continue using Mirantis Products?'
     when q."Name" like('%satisfied%') then 'Satisfied with Customer service?'end as "Name_Std",
cast(qr."ResponseShortText" as float) as "ResponseShortText",
qr."InvitationId" as "InvitationId_qr",
sr."Id" as "SurveyResponseId",
sr."Name" as "CandidateName",
left(sr."CreatedDate",4) as "SR_CreatedDate",
sr."Status",
sr."Latitude",
sr."Longitude",
sr."IpAddress",
sr."SurveyVersionId" as "SR_SurveyVersionId",
sr."SurveyId" as "SR_SurveyId"
FROM "MIRANTIS"."SALESFORCE"."SFDC_SYNC_SURVEYQUESTION" Q
JOIN "MIRANTIS"."SALESFORCE"."SFDC_SYNC_SURVEYQUESTIONRESPONSE" QR ON Q."Id"=QR."QuestionId" 
JOIN "MIRANTIS"."SALESFORCE"."SFDC_SYNC_SURVEYRESPONSE"SR ON QR."ResponseId"=SR."Id"
where "QuestionType"='NPS';
------------------------&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&-------------------------------
create table "MIRANTIS"."ANALYST"."NPS_SURVEY_SBALASUNDIRAM_1292021" as
select * from "MIRANTIS"."ANALYST"."NPS_SURVEYRESPONSE_SBALASUNDIRAM_1282021" x
left join "MIRANTIS"."ANALYST"."NPS_ACCOUNTTABLE_SBALASUNDIRAM_1282021" y on x."InvitationId_qr"=y."InvitationId"

select distinct "Name" from "MIRANTIS"."SALESFORCE"."SFDC_SYNC_SURVEY"

select * from "MIRANTIS"."ANALYST"."NPS_SURVEY_SBALASUNDIRAM_1292021" where "ResponseShortText">=0 and "ResponseShortText"<=4
