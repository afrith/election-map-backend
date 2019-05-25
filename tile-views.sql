CREATE MATERIALIZED VIEW tiles.vd AS
SELECT 
  vd.id,
  natwin.election_id,
  vd.code,
  COALESCE(natp.abbrev, 'TIE') as nat_win_party,
  natwin.perc::float as nat_win_perc,
  COALESCE(provp.abbrev, 'TIE') as prov_win_party,
  provwin.perc::float as prov_win_perc,
  vd.geom
FROM vd
  JOIN vd_single_winner natwin ON vd.id = natwin.vd_id and natwin.ballot_id = 1
  LEFT JOIN party natp ON natwin.party_id = natp.id
  JOIN vd_single_winner provwin ON vd.id = provwin.vd_id and provwin.ballot_id = 2
  LEFT JOIN party provp ON provwin.party_id = provp.id
;
CREATE INDEX ON tiles.vd(election_id);
CREATE INDEX ON tiles.vd USING gist(geom);
