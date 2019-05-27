DROP MATERIALIZED VIEW tiles.vd;
CREATE MATERIALIZED VIEW tiles.vd AS
SELECT 
  vd.id,
  natwin.election_id,
  vd.code,
  COALESCE(natp.abbrev, 'TIE') as nat_win_party,
  floor(natwin.perc)::int as nat_win_perc,
  COALESCE(provp.abbrev, 'TIE') as prov_win_party,
  floor(provwin.perc)::int as prov_win_perc,
  coalesce(floor(nat_anc.perc*10), 0)::int as nat_anc,
  coalesce(floor(prov_anc.perc*10), 0)::int as prov_anc,
  coalesce(floor(nat_da.perc*10), 0)::int as nat_da,
  coalesce(floor(prov_da.perc*10), 0)::int as prov_da,
  coalesce(floor(nat_eff.perc*10), 0)::int as nat_eff,
  coalesce(floor(prov_eff.perc*10), 0)::int as prov_eff,
  coalesce(floor(nat_ifp.perc*10), 0)::int as nat_ifp,
  coalesce(floor(prov_ifp.perc*10), 0)::int as prov_ifp,
  coalesce(floor(nat_vfplus.perc*10), 0)::int as nat_vfplus,
  coalesce(floor(prov_vfplus.perc*10), 0)::int as prov_vfplus,
  vd.geom
FROM vd
  JOIN vd_single_winner natwin ON vd.id = natwin.vd_id and natwin.ballot_id = 1
  LEFT JOIN party natp ON natwin.party_id = natp.id
  JOIN vd_single_winner provwin ON vd.id = provwin.vd_id and provwin.ballot_id = 2
  LEFT JOIN party provp ON provwin.party_id = provp.id
  LEFT JOIN vd_perc nat_anc ON (vd.id = nat_anc.vd_id and natwin.election_id = nat_anc.election_id and nat_anc.ballot_id = 1 and nat_anc.party_id = 24)
  LEFT JOIN vd_perc prov_anc ON (vd.id = prov_anc.vd_id and natwin.election_id = prov_anc.election_id and prov_anc.ballot_id = 2 and prov_anc.party_id = 24)
  LEFT JOIN vd_perc nat_da ON (vd.id = nat_da.vd_id and natwin.election_id = nat_da.election_id and nat_da.ballot_id = 1 and nat_da.party_id = 106)
  LEFT JOIN vd_perc prov_da ON (vd.id = prov_da.vd_id and natwin.election_id = prov_da.election_id and prov_da.ballot_id = 2 and prov_da.party_id = 106)
  LEFT JOIN vd_perc nat_eff ON (vd.id = nat_eff.vd_id and natwin.election_id = nat_eff.election_id and nat_eff.ballot_id = 1 and nat_eff.party_id = 122)
  LEFT JOIN vd_perc prov_eff ON (vd.id = prov_eff.vd_id and natwin.election_id = prov_eff.election_id and prov_eff.ballot_id = 2 and prov_eff.party_id = 122)
  LEFT JOIN vd_perc nat_ifp ON (vd.id = nat_ifp.vd_id and natwin.election_id = nat_ifp.election_id and nat_ifp.ballot_id = 1 and nat_ifp.party_id = 165)
  LEFT JOIN vd_perc prov_ifp ON (vd.id = prov_ifp.vd_id and natwin.election_id = prov_ifp.election_id and prov_ifp.ballot_id = 2 and prov_ifp.party_id = 165)
  LEFT JOIN vd_perc nat_vfplus ON (vd.id = nat_vfplus.vd_id and natwin.election_id = nat_vfplus.election_id and nat_vfplus.ballot_id = 1 and nat_vfplus.party_id = 374)
  LEFT JOIN vd_perc prov_vfplus ON (vd.id = prov_vfplus.vd_id and natwin.election_id = prov_vfplus.election_id and prov_vfplus.ballot_id = 2 and prov_vfplus.party_id = 374)
;
CREATE INDEX ON tiles.vd(election_id);
CREATE INDEX ON tiles.vd USING gist(geom);
