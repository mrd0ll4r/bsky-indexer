#!/bin/sh

set -e
DATE=$(date -u '+%Y-%m-%d')
OUTDIR="/tank/bluesky_csv/exports/$DATE"
mkdir -p "$OUTDIR"

# ------------------------------ Write data timestamp ----------------------------------

echo "export_start" > "$OUTDIR/timestamp.csv"
date -Iseconds --utc >> "$OUTDIR/timestamp.csv"

# # Follows
# docker compose exec -iT postgres psql -U postgres -d bluesky <<- EOF
# \timing
# \echo Refreshing follows...
# refresh materialized view export_follows;
# EOF
# 
# echo "Writing .csv file..."
# docker compose exec -it postgres psql -U postgres -d bluesky \
#   -c "copy (select * from export_follows) to stdout with csv header;" | gzip -9 > "$OUTDIR/follows.csv.gz"
# 
# docker compose exec -iT postgres psql -U postgres -d bluesky -c "REFRESH MATERIALIZED VIEW export_follows WITH NO DATA;"
# 
# # Likes
# docker compose exec -iT postgres psql -U postgres -d bluesky <<- EOF
# \timing
# \echo Refreshing likes...
# refresh materialized view export_likes;
# EOF
# 
# echo "Writing .csv file..."
# docker compose exec -it postgres psql -U postgres -d bluesky \
#   -c "copy (select * from export_likes) to stdout with csv header;" | gzip -9 > "$OUTDIR/likes.csv.gz"
# 
# docker compose exec -iT postgres psql -U postgres -d bluesky -c "REFRESH MATERIALIZED VIEW export_likes WITH NO DATA;"
# 
# # Post Languages over Time
# docker compose exec -iT postgres psql -U postgres -d bluesky <<- EOF
# \timing
# \echo Refreshing post languages over time...
# refresh materialized view export_post_languages_over_time;
# EOF
# 
# echo "Writing .csv file..."
# docker compose exec -it postgres psql -U postgres -d bluesky \
#   -c "copy (select * from export_post_languages_over_time) to stdout with csv header;" | gzip -9 > "$OUTDIR/post_languages_over_time.csv.gz"
# 
# docker compose exec -iT postgres psql -U postgres -d bluesky -c "REFRESH MATERIALIZED VIEW export_post_languages_over_time WITH NO DATA;"
# 
# # Profiles
# docker compose exec -iT postgres psql -U postgres -d bluesky <<- EOF
# \timing
# \echo Refreshing profiles...
# refresh materialized view export_profiles;
# EOF
# 
# echo "Writing .csv file..."
# docker compose exec -it postgres psql -U postgres -d bluesky \
#   -c "copy (select * from export_profiles) to stdout with csv header;" | gzip -9 > "$OUTDIR/profiles.csv.gz"
# 
# docker compose exec -iT postgres psql -U postgres -d bluesky -c "REFRESH MATERIALIZED VIEW export_profiles WITH NO DATA;"
# 
# # User Languages
# docker compose exec -iT postgres psql -U postgres -d bluesky <<- EOF
# \timing
# \echo Refreshing user languages...
# refresh materialized view export_user_languages;
# EOF
# 
# echo "Writing .csv file..."
# docker compose exec -it postgres psql -U postgres -d bluesky \
#   -c "copy (select * from export_user_languages) to stdout with csv header;" | gzip -9 > "$OUTDIR/user_languages.csv.gz"
# 
# docker compose exec -iT postgres psql -U postgres -d bluesky -c "REFRESH MATERIALIZED VIEW export_user_languages WITH NO DATA;"
# 
# # Starter Packs
# docker compose exec -iT postgres psql -U postgres -d bluesky <<- EOF
# \timing
# \echo Refreshing starter packs...
# refresh materialized view export_starter_packs;
# EOF
# 
# echo "Writing .csv file..."
# docker compose exec -it postgres psql -U postgres -d bluesky \
#   -c "copy (select * from export_starter_packs) to stdout with csv header;" | gzip -9 > "$OUTDIR/starter_packs.csv.gz"
# 
# docker compose exec -iT postgres psql -U postgres -d bluesky -c "REFRESH MATERIALIZED VIEW export_starter_packs WITH NO DATA;"
# 
# # List Items
# docker compose exec -iT postgres psql -U postgres -d bluesky <<- EOF
# \timing
# \echo Refreshing list items...
# refresh materialized view export_listitems;
# EOF
# 
# echo "Writing .csv file..."
# docker compose exec -it postgres psql -U postgres -d bluesky \
#   -c "copy (select * from export_listitems) to stdout with csv header;" | gzip -9 > "$OUTDIR/list_items.csv.gz"
# 
# docker compose exec -iT postgres psql -U postgres -d bluesky -c "REFRESH MATERIALIZED VIEW export_listitems WITH NO DATA;"
# 
# # Feed Generators
# docker compose exec -iT postgres psql -U postgres -d bluesky <<- EOF
# \timing
# \echo Refreshing feed generators...
# refresh materialized view export_feed_generators;
# EOF
# 
# echo "Writing .csv file..."
# docker compose exec -it postgres psql -U postgres -d bluesky \
#   -c "copy (select * from export_feed_generators) to stdout with csv header;" | gzip -9 > "$OUTDIR/feed_generators.csv.gz"
# 
# docker compose exec -iT postgres psql -U postgres -d bluesky -c "REFRESH MATERIALIZED VIEW export_feed_generators WITH NO DATA;"
# 
# # Posts
# docker compose exec -iT postgres psql -U postgres -d bluesky <<- EOF
# \timing
# \echo Refreshing posts...
# refresh materialized view export_posts;
# EOF
# 
# echo "Writing .csv file..."
# docker compose exec -it postgres psql -U postgres -d bluesky \
#   -c "copy (select * from export_posts) to stdout with csv header;" | gzip -9 > "$OUTDIR/posts.csv.gz"
# 
# docker compose exec -iT postgres psql -U postgres -d bluesky -c "REFRESH MATERIALIZED VIEW export_posts WITH NO DATA;"
# 
# 
# for i in $(seq 0 30); do d=$(echo "$i*1000000" | bc); dd=$(echo "($i+1)*1000000" | bc); echo "exporting first interactions from repo ID $d to $dd";
# 	docker compose exec -it postgres psql -U postgres -d bluesky \
#   	-c "copy (SELECT rr.did, MIN(r.content->>'createdAt') AS db_first_record_timestamp FROM repos rr, records r WHERE r.repo=rr.id AND rr.id >= $d AND rr.id <$dd GROUP BY rr.did) to stdout with csv header;" |
# 	gzip -9 > "$OUTDIR/first_record_timestamp_by_did_$i.csv.gz"
# done
