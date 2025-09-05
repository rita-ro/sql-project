WITH all_ads_data AS (
SELECT	fabd.ad_date,
		fc.campaign_name,
		fa.adset_name,
		fabd.spend,
		fabd.impressions,
		fabd.reach,
		fabd.clicks,
		fabd.leads,
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
		adset_name,
		spend,
		impressions,
		reach,
		clicks,
		leads,
		value,
		'Google' AS ad_source
	FROM google_ads_basic_daily AS gabd
)
SELECT 	ad_date,
		ad_source,
		round(avg(spend),2) AS avg_spend,
		round(max(spend),2) AS max_spend,
		round(min(spend),2) AS min_spend
FROM all_ads_data 
GROUP BY ad_date, ad_source
ORDER BY ad_date DESC;

		

