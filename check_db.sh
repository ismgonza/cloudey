#!/bin/bash
# Quick PostgreSQL database check commands for Cloudey.app

# 1. Count all resources (most useful)
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 RESOURCE COUNTS"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
docker exec cloudey-postgres psql -U cloudey -d cloudey -c "
SELECT 'Compartments' as table_name, COUNT(*) FROM oci_compartments
UNION ALL SELECT 'Compute', COUNT(*) FROM oci_compute
UNION ALL SELECT 'Volumes', COUNT(*) FROM oci_volumes
UNION ALL SELECT 'Buckets', COUNT(*) FROM oci_buckets
UNION ALL SELECT 'File Storage', COUNT(*) FROM oci_file_storage
UNION ALL SELECT 'Databases', COUNT(*) FROM oci_database
UNION ALL SELECT 'PostgreSQL', COUNT(*) FROM oci_database_psql
UNION ALL SELECT 'Load Balancers', COUNT(*) FROM oci_load_balancer
UNION ALL SELECT 'Costs', COUNT(*) FROM oci_costs;
"

