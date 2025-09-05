WITH all_ads_data AS (
SELECT	fabd.ad_date,
		fc.campaign_name,
		fabd.value,
		'Facebook' AS ad_source
FROM facebook_ads_basic_daily AS fabd
LEFT JOIN facebook_adset AS fa
ON fa.adset_id=fabd.adset_id
LEFT JOIN facebook_campaign AS fc
ON fc.campaign_id=fabd.campaign_id
UNION ALL
SELECT	ad_date,
		campaign_name,
		value,
		'Google' AS ad_source
	FROM google_ads_basic_daily AS gabd
)
SELECT 	date_trunc('week', ad_date) AS start_week,
		campaign_name,
		SUM(COALESCE(value, 0)) AS week_value
FROM all_ads_data
GROUP BY start_week,campaign_name 
ORDER BY week_value DESC
LIMIT 1;