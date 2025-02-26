create materialized view export_follows
as select repos.did as "src",
  records.content ->> 'subject' as "dst",
  records.content ->> 'createdAt' as created_at
  from repos join records on repos.id = records.repo
  where records.collection = 'app.bsky.graph.follow'
  AND NOT records.deleted
with no data;
create index export_follow_subject on export_follows ("dst");

CREATE MATERIALIZED VIEW export_user_languages
AS SELECT rr.did,
  COALESCE(content->>'langs', '["Unknown"]') as post_langs,
  COUNT(*) AS post_count
FROM records r JOIN repos rr ON r.repo = rr.id
WHERE collection = 'app.bsky.feed.post'
AND NOT r.deleted
GROUP BY rr.did, post_langs
WITH NO DATA;

CREATE MATERIALIZED VIEW export_post_languages_over_time
AS SELECT rr.did,
  COALESCE(content->>'langs', '["Unknown"]') AS langs,
  content->>'createdAt' AS created_at
FROM records r JOIN repos rr ON r.repo = rr.id
WHERE collection = 'app.bsky.feed.post'
AND NOT r.deleted
WITH NO DATA;

create materialized view export_likes
as select repos.did as "src",
  split_part(jsonb_extract_path_text(content, 'subject',  'uri'), '/', 3) as "dst_did",
  split_part(jsonb_extract_path_text(content, 'subject',  'uri'), '/', 4) as "dst_collection",
  split_part(jsonb_extract_path_text(content, 'subject',  'uri'), '/', 5) as "dst_rkey",
  content ->> 'createdAt' AS created_at
  from records join repos on records.repo = repos.id
  where records.collection = 'app.bsky.feed.like'
  AND NOT records.deleted
with no data;
create index export_like_subject on export_likes ("dst_did");

CREATE MATERIALIZED VIEW export_profiles
AS SELECT rr.did,
r.content AS profile
FROM records r JOIN repos rr ON r.repo = rr.id
WHERE collection = 'app.bsky.actor.profile'
AND NOT r.deleted
WITH NO DATA;

CREATE MATERIALIZED VIEW export_listitems
AS SELECT rr.did,
  r.content->>'list' AS list,
  r.content->>'subject' AS subject,
  r.content->>'createdAt' AS created_at
FROM repos rr, records r
WHERE r.repo = rr.id
AND r.collection='app.bsky.graph.listitem'
AND NOT r.deleted
WITH NO DATA;'

CREATE MATERIALIZED VIEW export_starter_packs
AS SELECT rr.did,
  r.rkey,
  r.content->>'createdAt' AS created_at,
  r.content->>'list' AS list_uri,
  jsonb_path_query_array(r.content, '$.feeds[*].uri') AS feed_generator_uris
FROM records r, repos rr
WHERE r.repo = rr.id
AND r.collection='app.bsky.graph.starterpack'
AND NOT r.deleted
WITH NO DATA;

CREATE MATERIALIZED VIEW export_feed_generators
AS SELECT rr.did,
  r.rkey,
  r.content->>'createdAt' AS created_at,
  r.content->>'did' AS feed_generator_did
FROM records r, repos rr
WHERE r.repo = rr.id
AND r.collection='app.bsky.feed.generator'
AND NOT r.deleted
WITH NO DATA;

CREATE MATERIALIZED VIEW export_posts
AS SELECT rr.did,
  r.rkey,
  COALESCE(r.content->>'langs', '["Unknown"]') AS post_languages,
  r.content->>'createdAt' AS post_created_at,
  r.content->>'text' AS post_text,
  r.content->'reply'->'root'->>'uri' AS reply_root,
  r.content->'reply'->'parent'->>'uri' AS reply_parent,
  r.content->>'facets' AS post_facets
FROM records r, repos rr
WHERE r.repo = rr.id
AND r.collection='app.bsky.feed.post'
AND NOT r.deleted
WITH NO DATA;
