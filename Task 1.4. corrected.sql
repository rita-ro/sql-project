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
),
montly_reach_camp AS (
    SELECT 
        DATE_PART('year', ad_date) || '-' || DATE_PART('month', ad_date) AS ad_month,
        campaign_name,
        COALESCE(SUM(reach), 0) AS monthly_reach     --  метрика reach
    FROM all_ads_data
    GROUP BY ad_month, campaign_name
)
SELECT 
    *,
    monthly_reach - COALESCE(LAG(monthly_reach) OVER (PARTITION BY campaign_name ORDER BY ad_month), 0) AS montly_growth
FROM montly_reach_camp
ORDER BY montly_growth DESC
LIMIT 1;