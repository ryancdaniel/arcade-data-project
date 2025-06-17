/* Joining Data together prior to moving to dashboard */
SELECT
    m.machine_id,
    m.machine_name,
    m.manufacturer_id,
    mf.name,
    m.is_multiplayer,
    m.release_year,
    l.location_id,
    l.arcade_name,
    l.city,
    l.state,
    l.install_date,
    ul.date AS usage_date,
    ul.total_plays,
    ul.total_revenue,
    COALESCE(ma.issue_description, 'None') AS Issue,
    COALESCE(ma.service_date, '1900-01-01') AS Service_Date,
    COALESCE(ma.resolved_date, '1900-01-01') AS Resolved_Date,
    COALESCE(DATEDIFF(Resolved_Date, ma.service_date), 0) AS days_to_resolve
FROM machines m
LEFT JOIN manufacturers mf ON m.manufacturer_id = mf.manufacturer_id
LEFT JOIN locations l ON m.machine_id = l.machine_id
LEFT JOIN usage_logs ul ON m.machine_id = ul.machine_id
LEFT JOIN maintenance ma ON m.machine_id = ma.machine_id
ORDER BY m.machine_id, ul.date;
