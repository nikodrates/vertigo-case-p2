with source as (
    select * from {{ source('raw_data', 'daily_activity') }}
)

select
    user_id,
    cast(event_date as date) as event_date,
    cast(install_date as date) as install_date,
    upper(platform) as platform,
    coalesce(country, 'UNKNOWN') as country,
    total_session_count,
    total_session_duration,
    match_start_count,
    match_end_count,
    victory_count,
    defeat_count,
    server_connection_error,
    iap_revenue,
    ad_revenue
from source
