BEGIN;
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
  coalesce(floor(natballot.total*100.0/natballot.regpop), 0)::int as nat_turnout,
  coalesce(floor(provballot.total*100.0/provballot.regpop), 0)::int as prov_turnout,
  coalesce(floor(nat_anc.perc), 0)::int as nat_anc,
  coalesce(floor(prov_anc.perc), 0)::int as prov_anc,
  coalesce(floor(nat_da.perc), 0)::int as nat_da,
  coalesce(floor(prov_da.perc), 0)::int as prov_da,
  coalesce(floor(nat_eff.perc), 0)::int as nat_eff,
  coalesce(floor(prov_eff.perc), 0)::int as prov_eff,
  coalesce(floor(nat_ifp.perc), 0)::int as nat_ifp,
  coalesce(floor(prov_ifp.perc), 0)::int as prov_ifp,
  coalesce(floor(nat_vfplus.perc), 0)::int as nat_vfplus,
  coalesce(floor(prov_vfplus.perc), 0)::int as prov_vfplus,
  vd.geom
FROM vd
  JOIN vd_single_winner natwin ON vd.id = natwin.vd_id and natwin.ballot_id = 1
  LEFT JOIN party natp ON natwin.party_id = natp.id
  JOIN vd_single_winner provwin ON vd.id = provwin.vd_id and provwin.ballot_id = 2 and natwin.election_id = provwin.election_id
  LEFT JOIN party provp ON provwin.party_id = provp.id
  LEFT JOIN vd_ballot_total natballot ON (vd.id = natballot.vd_id and natwin.election_id = natballot.election_id and natballot.ballot_id = 1)
  LEFT JOIN vd_ballot_total provballot ON (vd.id = provballot.vd_id and natwin.election_id = provballot.election_id and provballot.ballot_id = 2)
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

--

DROP MATERIALIZED VIEW tiles.ward;
CREATE MATERIALIZED VIEW tiles.ward AS
SELECT 
  ward.id,
  natwin.election_id,
  ward.code,
  COALESCE(natp.abbrev, 'TIE') as nat_win_party,
  floor(natwin.perc)::int as nat_win_perc,
  COALESCE(provp.abbrev, 'TIE') as prov_win_party,
  floor(provwin.perc)::int as prov_win_perc,
  coalesce(floor(natballot.total*100.0/natballot.regpop), 0)::int as nat_turnout,
  coalesce(floor(provballot.total*100.0/provballot.regpop), 0)::int as prov_turnout,
  coalesce(floor(nat_anc.perc), 0)::int as nat_anc,
  coalesce(floor(prov_anc.perc), 0)::int as prov_anc,
  coalesce(floor(nat_da.perc), 0)::int as nat_da,
  coalesce(floor(prov_da.perc), 0)::int as prov_da,
  coalesce(floor(nat_eff.perc), 0)::int as nat_eff,
  coalesce(floor(prov_eff.perc), 0)::int as prov_eff,
  coalesce(floor(nat_ifp.perc), 0)::int as nat_ifp,
  coalesce(floor(prov_ifp.perc), 0)::int as prov_ifp,
  coalesce(floor(nat_vfplus.perc), 0)::int as nat_vfplus,
  coalesce(floor(prov_vfplus.perc), 0)::int as prov_vfplus,
  ward.geom
FROM ward
  JOIN ward_single_winner natwin ON ward.id = natwin.ward_id and natwin.ballot_id = 1
  LEFT JOIN party natp ON natwin.party_id = natp.id
  JOIN ward_single_winner provwin ON ward.id = provwin.ward_id and provwin.ballot_id = 2 and natwin.election_id = provwin.election_id
  LEFT JOIN party provp ON provwin.party_id = provp.id
  LEFT JOIN ward_ballot_total natballot ON (ward.id = natballot.ward_id and natwin.election_id = natballot.election_id and natballot.ballot_id = 1)
  LEFT JOIN ward_ballot_total provballot ON (ward.id = provballot.ward_id and natwin.election_id = provballot.election_id and provballot.ballot_id = 2)
  LEFT JOIN ward_perc nat_anc ON (ward.id = nat_anc.ward_id and natwin.election_id = nat_anc.election_id and nat_anc.ballot_id = 1 and nat_anc.party_id = 24)
  LEFT JOIN ward_perc prov_anc ON (ward.id = prov_anc.ward_id and natwin.election_id = prov_anc.election_id and prov_anc.ballot_id = 2 and prov_anc.party_id = 24)
  LEFT JOIN ward_perc nat_da ON (ward.id = nat_da.ward_id and natwin.election_id = nat_da.election_id and nat_da.ballot_id = 1 and nat_da.party_id = 106)
  LEFT JOIN ward_perc prov_da ON (ward.id = prov_da.ward_id and natwin.election_id = prov_da.election_id and prov_da.ballot_id = 2 and prov_da.party_id = 106)
  LEFT JOIN ward_perc nat_eff ON (ward.id = nat_eff.ward_id and natwin.election_id = nat_eff.election_id and nat_eff.ballot_id = 1 and nat_eff.party_id = 122)
  LEFT JOIN ward_perc prov_eff ON (ward.id = prov_eff.ward_id and natwin.election_id = prov_eff.election_id and prov_eff.ballot_id = 2 and prov_eff.party_id = 122)
  LEFT JOIN ward_perc nat_ifp ON (ward.id = nat_ifp.ward_id and natwin.election_id = nat_ifp.election_id and nat_ifp.ballot_id = 1 and nat_ifp.party_id = 165)
  LEFT JOIN ward_perc prov_ifp ON (ward.id = prov_ifp.ward_id and natwin.election_id = prov_ifp.election_id and prov_ifp.ballot_id = 2 and prov_ifp.party_id = 165)
  LEFT JOIN ward_perc nat_vfplus ON (ward.id = nat_vfplus.ward_id and natwin.election_id = nat_vfplus.election_id and nat_vfplus.ballot_id = 1 and nat_vfplus.party_id = 374)
  LEFT JOIN ward_perc prov_vfplus ON (ward.id = prov_vfplus.ward_id and natwin.election_id = prov_vfplus.election_id and prov_vfplus.ballot_id = 2 and prov_vfplus.party_id = 374)
;
CREATE INDEX ON tiles.ward(election_id);
CREATE INDEX ON tiles.ward USING gist(geom);

--

DROP MATERIALIZED VIEW tiles.muni;
CREATE MATERIALIZED VIEW tiles.muni AS
SELECT 
  muni.id,
  natwin.election_id,
  muni.code,
  COALESCE(natp.abbrev, 'TIE') as nat_win_party,
  floor(natwin.perc)::int as nat_win_perc,
  COALESCE(provp.abbrev, 'TIE') as prov_win_party,
  floor(provwin.perc)::int as prov_win_perc,
  coalesce(floor(natballot.total*100.0/natballot.regpop), 0)::int as nat_turnout,
  coalesce(floor(provballot.total*100.0/provballot.regpop), 0)::int as prov_turnout,
  coalesce(floor(nat_anc.perc), 0)::int as nat_anc,
  coalesce(floor(prov_anc.perc), 0)::int as prov_anc,
  coalesce(floor(nat_da.perc), 0)::int as nat_da,
  coalesce(floor(prov_da.perc), 0)::int as prov_da,
  coalesce(floor(nat_eff.perc), 0)::int as nat_eff,
  coalesce(floor(prov_eff.perc), 0)::int as prov_eff,
  coalesce(floor(nat_ifp.perc), 0)::int as nat_ifp,
  coalesce(floor(prov_ifp.perc), 0)::int as prov_ifp,
  coalesce(floor(nat_vfplus.perc), 0)::int as nat_vfplus,
  coalesce(floor(prov_vfplus.perc), 0)::int as prov_vfplus,
  muni.geom
FROM muni
  JOIN muni_single_winner natwin ON muni.id = natwin.muni_id and natwin.ballot_id = 1
  LEFT JOIN party natp ON natwin.party_id = natp.id
  JOIN muni_single_winner provwin ON muni.id = provwin.muni_id and provwin.ballot_id = 2 and natwin.election_id = provwin.election_id
  LEFT JOIN party provp ON provwin.party_id = provp.id
  LEFT JOIN muni_ballot_total natballot ON (muni.id = natballot.muni_id and natwin.election_id = natballot.election_id and natballot.ballot_id = 1)
  LEFT JOIN muni_ballot_total provballot ON (muni.id = provballot.muni_id and natwin.election_id = provballot.election_id and provballot.ballot_id = 2)
  LEFT JOIN muni_perc nat_anc ON (muni.id = nat_anc.muni_id and natwin.election_id = nat_anc.election_id and nat_anc.ballot_id = 1 and nat_anc.party_id = 24)
  LEFT JOIN muni_perc prov_anc ON (muni.id = prov_anc.muni_id and natwin.election_id = prov_anc.election_id and prov_anc.ballot_id = 2 and prov_anc.party_id = 24)
  LEFT JOIN muni_perc nat_da ON (muni.id = nat_da.muni_id and natwin.election_id = nat_da.election_id and nat_da.ballot_id = 1 and nat_da.party_id = 106)
  LEFT JOIN muni_perc prov_da ON (muni.id = prov_da.muni_id and natwin.election_id = prov_da.election_id and prov_da.ballot_id = 2 and prov_da.party_id = 106)
  LEFT JOIN muni_perc nat_eff ON (muni.id = nat_eff.muni_id and natwin.election_id = nat_eff.election_id and nat_eff.ballot_id = 1 and nat_eff.party_id = 122)
  LEFT JOIN muni_perc prov_eff ON (muni.id = prov_eff.muni_id and natwin.election_id = prov_eff.election_id and prov_eff.ballot_id = 2 and prov_eff.party_id = 122)
  LEFT JOIN muni_perc nat_ifp ON (muni.id = nat_ifp.muni_id and natwin.election_id = nat_ifp.election_id and nat_ifp.ballot_id = 1 and nat_ifp.party_id = 165)
  LEFT JOIN muni_perc prov_ifp ON (muni.id = prov_ifp.muni_id and natwin.election_id = prov_ifp.election_id and prov_ifp.ballot_id = 2 and prov_ifp.party_id = 165)
  LEFT JOIN muni_perc nat_vfplus ON (muni.id = nat_vfplus.muni_id and natwin.election_id = nat_vfplus.election_id and nat_vfplus.ballot_id = 1 and nat_vfplus.party_id = 374)
  LEFT JOIN muni_perc prov_vfplus ON (muni.id = prov_vfplus.muni_id and natwin.election_id = prov_vfplus.election_id and prov_vfplus.ballot_id = 2 and prov_vfplus.party_id = 374)
;
CREATE INDEX ON tiles.muni(election_id);
CREATE INDEX ON tiles.muni USING gist(geom);

--

DROP MATERIALIZED VIEW tiles.dist;
CREATE MATERIALIZED VIEW tiles.dist AS
SELECT 
  dist.id,
  natwin.election_id,
  dist.code,
  COALESCE(natp.abbrev, 'TIE') as nat_win_party,
  floor(natwin.perc)::int as nat_win_perc,
  COALESCE(provp.abbrev, 'TIE') as prov_win_party,
  floor(provwin.perc)::int as prov_win_perc,
  coalesce(floor(natballot.total*100.0/natballot.regpop), 0)::int as nat_turnout,
  coalesce(floor(provballot.total*100.0/provballot.regpop), 0)::int as prov_turnout,
  coalesce(floor(nat_anc.perc), 0)::int as nat_anc,
  coalesce(floor(prov_anc.perc), 0)::int as prov_anc,
  coalesce(floor(nat_da.perc), 0)::int as nat_da,
  coalesce(floor(prov_da.perc), 0)::int as prov_da,
  coalesce(floor(nat_eff.perc), 0)::int as nat_eff,
  coalesce(floor(prov_eff.perc), 0)::int as prov_eff,
  coalesce(floor(nat_ifp.perc), 0)::int as nat_ifp,
  coalesce(floor(prov_ifp.perc), 0)::int as prov_ifp,
  coalesce(floor(nat_vfplus.perc), 0)::int as nat_vfplus,
  coalesce(floor(prov_vfplus.perc), 0)::int as prov_vfplus,
  dist.geom
FROM dist
  JOIN dist_single_winner natwin ON dist.id = natwin.dist_id and natwin.ballot_id = 1
  LEFT JOIN party natp ON natwin.party_id = natp.id
  JOIN dist_single_winner provwin ON dist.id = provwin.dist_id and provwin.ballot_id = 2 and natwin.election_id = provwin.election_id
  LEFT JOIN party provp ON provwin.party_id = provp.id
  LEFT JOIN dist_ballot_total natballot ON (dist.id = natballot.dist_id and natwin.election_id = natballot.election_id and natballot.ballot_id = 1)
  LEFT JOIN dist_ballot_total provballot ON (dist.id = provballot.dist_id and natwin.election_id = provballot.election_id and provballot.ballot_id = 2)
  LEFT JOIN dist_perc nat_anc ON (dist.id = nat_anc.dist_id and natwin.election_id = nat_anc.election_id and nat_anc.ballot_id = 1 and nat_anc.party_id = 24)
  LEFT JOIN dist_perc prov_anc ON (dist.id = prov_anc.dist_id and natwin.election_id = prov_anc.election_id and prov_anc.ballot_id = 2 and prov_anc.party_id = 24)
  LEFT JOIN dist_perc nat_da ON (dist.id = nat_da.dist_id and natwin.election_id = nat_da.election_id and nat_da.ballot_id = 1 and nat_da.party_id = 106)
  LEFT JOIN dist_perc prov_da ON (dist.id = prov_da.dist_id and natwin.election_id = prov_da.election_id and prov_da.ballot_id = 2 and prov_da.party_id = 106)
  LEFT JOIN dist_perc nat_eff ON (dist.id = nat_eff.dist_id and natwin.election_id = nat_eff.election_id and nat_eff.ballot_id = 1 and nat_eff.party_id = 122)
  LEFT JOIN dist_perc prov_eff ON (dist.id = prov_eff.dist_id and natwin.election_id = prov_eff.election_id and prov_eff.ballot_id = 2 and prov_eff.party_id = 122)
  LEFT JOIN dist_perc nat_ifp ON (dist.id = nat_ifp.dist_id and natwin.election_id = nat_ifp.election_id and nat_ifp.ballot_id = 1 and nat_ifp.party_id = 165)
  LEFT JOIN dist_perc prov_ifp ON (dist.id = prov_ifp.dist_id and natwin.election_id = prov_ifp.election_id and prov_ifp.ballot_id = 2 and prov_ifp.party_id = 165)
  LEFT JOIN dist_perc nat_vfplus ON (dist.id = nat_vfplus.dist_id and natwin.election_id = nat_vfplus.election_id and nat_vfplus.ballot_id = 1 and nat_vfplus.party_id = 374)
  LEFT JOIN dist_perc prov_vfplus ON (dist.id = prov_vfplus.dist_id and natwin.election_id = prov_vfplus.election_id and prov_vfplus.ballot_id = 2 and prov_vfplus.party_id = 374)
;
CREATE INDEX ON tiles.dist(election_id);
CREATE INDEX ON tiles.dist USING gist(geom);

--

DROP MATERIALIZED VIEW tiles.prov;
CREATE MATERIALIZED VIEW tiles.prov AS
SELECT 
  prov.id,
  natwin.election_id,
  prov.code,
  COALESCE(natp.abbrev, 'TIE') as nat_win_party,
  floor(natwin.perc)::int as nat_win_perc,
  COALESCE(provp.abbrev, 'TIE') as prov_win_party,
  floor(provwin.perc)::int as prov_win_perc,
  coalesce(floor(natballot.total*100.0/natballot.regpop), 0)::int as nat_turnout,
  coalesce(floor(provballot.total*100.0/provballot.regpop), 0)::int as prov_turnout,
  coalesce(floor(nat_anc.perc), 0)::int as nat_anc,
  coalesce(floor(prov_anc.perc), 0)::int as prov_anc,
  coalesce(floor(nat_da.perc), 0)::int as nat_da,
  coalesce(floor(prov_da.perc), 0)::int as prov_da,
  coalesce(floor(nat_eff.perc), 0)::int as nat_eff,
  coalesce(floor(prov_eff.perc), 0)::int as prov_eff,
  coalesce(floor(nat_ifp.perc), 0)::int as nat_ifp,
  coalesce(floor(prov_ifp.perc), 0)::int as prov_ifp,
  coalesce(floor(nat_vfplus.perc), 0)::int as nat_vfplus,
  coalesce(floor(prov_vfplus.perc), 0)::int as prov_vfplus,
  prov.geom
FROM prov
  JOIN prov_single_winner natwin ON prov.id = natwin.prov_id and natwin.ballot_id = 1
  LEFT JOIN party natp ON natwin.party_id = natp.id
  JOIN prov_single_winner provwin ON prov.id = provwin.prov_id and provwin.ballot_id = 2 and natwin.election_id = provwin.election_id
  LEFT JOIN party provp ON provwin.party_id = provp.id
  LEFT JOIN prov_ballot_total natballot ON (prov.id = natballot.prov_id and natwin.election_id = natballot.election_id and natballot.ballot_id = 1)
  LEFT JOIN prov_ballot_total provballot ON (prov.id = provballot.prov_id and natwin.election_id = provballot.election_id and provballot.ballot_id = 2)
  LEFT JOIN prov_perc nat_anc ON (prov.id = nat_anc.prov_id and natwin.election_id = nat_anc.election_id and nat_anc.ballot_id = 1 and nat_anc.party_id = 24)
  LEFT JOIN prov_perc prov_anc ON (prov.id = prov_anc.prov_id and natwin.election_id = prov_anc.election_id and prov_anc.ballot_id = 2 and prov_anc.party_id = 24)
  LEFT JOIN prov_perc nat_da ON (prov.id = nat_da.prov_id and natwin.election_id = nat_da.election_id and nat_da.ballot_id = 1 and nat_da.party_id = 106)
  LEFT JOIN prov_perc prov_da ON (prov.id = prov_da.prov_id and natwin.election_id = prov_da.election_id and prov_da.ballot_id = 2 and prov_da.party_id = 106)
  LEFT JOIN prov_perc nat_eff ON (prov.id = nat_eff.prov_id and natwin.election_id = nat_eff.election_id and nat_eff.ballot_id = 1 and nat_eff.party_id = 122)
  LEFT JOIN prov_perc prov_eff ON (prov.id = prov_eff.prov_id and natwin.election_id = prov_eff.election_id and prov_eff.ballot_id = 2 and prov_eff.party_id = 122)
  LEFT JOIN prov_perc nat_ifp ON (prov.id = nat_ifp.prov_id and natwin.election_id = nat_ifp.election_id and nat_ifp.ballot_id = 1 and nat_ifp.party_id = 165)
  LEFT JOIN prov_perc prov_ifp ON (prov.id = prov_ifp.prov_id and natwin.election_id = prov_ifp.election_id and prov_ifp.ballot_id = 2 and prov_ifp.party_id = 165)
  LEFT JOIN prov_perc nat_vfplus ON (prov.id = nat_vfplus.prov_id and natwin.election_id = nat_vfplus.election_id and nat_vfplus.ballot_id = 1 and nat_vfplus.party_id = 374)
  LEFT JOIN prov_perc prov_vfplus ON (prov.id = prov_vfplus.prov_id and natwin.election_id = prov_vfplus.election_id and prov_vfplus.ballot_id = 2 and prov_vfplus.party_id = 374)
;
CREATE INDEX ON tiles.prov(election_id);
CREATE INDEX ON tiles.prov USING gist(geom);
END;