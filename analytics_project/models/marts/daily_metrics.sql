with daily_activity as (
    select * from {{ ref('stg_daily_activity') }}
)

select
    event_date,
    country,
    platform,
    count(distinct user_id) as DAU,
    sum(iap_revenue) as total_iap_revenue,
    sum(ad_revenue) as total_ad_revenue,
    (sum(iap_revenue) + sum(ad_revenue)) / nullif(count(distinct user_id), 0) as arpdau,
    sum(match_start_count) as matches_started,
    sum(match_start_count) / nullif(count(distinct user_id), 0) as match_per_dau,
    sum(victory_count) / nullif(sum(match_end_count), 0) as win_ratio,
    sum(defeat_count) / nullif(sum(match_end_count), 0) as defeat_ratio,
    sum(server_connection_error) / nullif(count(distinct user_id), 0) as server_error_per_dau
from daily_activity
group by 1, 2, 3
order by event_date desc, country, platform
