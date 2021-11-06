
BEGIN;
DROP MATERIALIZED VIEW IF EXISTS tiles.vd_lge;
CREATE MATERIALIZED VIEW tiles.vd_lge AS
SELECT 
  vd.id,
  prwin.election_id,
  vd.code,
  COALESCE(wardp.abbrev, 'TIE') as ward_win_party,
  floor(wardwin.perc)::int as ward_win_perc,
  COALESCE(prp.abbrev, 'TIE') as pr_win_party,
  floor(prwin.perc)::int as pr_win_perc,
  coalesce(floor(wardballot.total*100.0/nullif(wardballot.regpop, 0)), 0)::int as ward_turnout,
  coalesce(floor(prballot.total*100.0/nullif(prballot.regpop, 0)), 0)::int as pr_turnout,
  coalesce(floor(ward_anc.perc), 0)::int as ward_anc,
  coalesce(floor(pr_anc.perc), 0)::int as pr_anc,
  coalesce(floor(ward_da.perc), 0)::int as ward_da,
  coalesce(floor(pr_da.perc), 0)::int as pr_da,
  coalesce(floor(ward_eff.perc), 0)::int as ward_eff,
  coalesce(floor(pr_eff.perc), 0)::int as pr_eff,
  coalesce(floor(ward_ifp.perc), 0)::int as ward_ifp,
  coalesce(floor(pr_ifp.perc), 0)::int as pr_ifp,
  coalesce(floor(ward_vfplus.perc), 0)::int as ward_vfplus,
  coalesce(floor(pr_vfplus.perc), 0)::int as pr_vfplus,
  vd.geom
FROM vd
  JOIN vd_single_winner prwin ON vd.id = prwin.vd_id and prwin.ballot_id = 4
  LEFT JOIN party prp ON prwin.party_id = prp.id
  LEFT JOIN vd_single_winner wardwin ON vd.id = wardwin.vd_id and wardwin.ballot_id = 3 and wardwin.election_id = prwin.election_id
  LEFT JOIN party wardp ON wardwin.party_id = wardp.id
  LEFT JOIN vd_ballot_total wardballot ON (vd.id = wardballot.vd_id and wardwin.election_id = wardballot.election_id and wardballot.ballot_id = 3)
  LEFT JOIN vd_ballot_total prballot ON (vd.id = prballot.vd_id and wardwin.election_id = prballot.election_id and prballot.ballot_id = 4)
  LEFT JOIN vd_perc ward_anc ON (vd.id = ward_anc.vd_id and wardwin.election_id = ward_anc.election_id and ward_anc.ballot_id = 3 and ward_anc.party_id = 24)
  LEFT JOIN vd_perc pr_anc ON (vd.id = pr_anc.vd_id and wardwin.election_id = pr_anc.election_id and pr_anc.ballot_id = 4 and pr_anc.party_id = 24)
  LEFT JOIN vd_perc ward_da ON (vd.id = ward_da.vd_id and wardwin.election_id = ward_da.election_id and ward_da.ballot_id = 3 and ward_da.party_id = 106)
  LEFT JOIN vd_perc pr_da ON (vd.id = pr_da.vd_id and wardwin.election_id = pr_da.election_id and pr_da.ballot_id = 4 and pr_da.party_id = 106)
  LEFT JOIN vd_perc ward_eff ON (vd.id = ward_eff.vd_id and wardwin.election_id = ward_eff.election_id and ward_eff.ballot_id = 3 and ward_eff.party_id = 122)
  LEFT JOIN vd_perc pr_eff ON (vd.id = pr_eff.vd_id and wardwin.election_id = pr_eff.election_id and pr_eff.ballot_id = 4 and pr_eff.party_id = 122)
  LEFT JOIN vd_perc ward_ifp ON (vd.id = ward_ifp.vd_id and wardwin.election_id = ward_ifp.election_id and ward_ifp.ballot_id = 3 and ward_ifp.party_id = 165)
  LEFT JOIN vd_perc pr_ifp ON (vd.id = pr_ifp.vd_id and wardwin.election_id = pr_ifp.election_id and pr_ifp.ballot_id = 4 and pr_ifp.party_id = 165)
  LEFT JOIN vd_perc ward_vfplus ON (vd.id = ward_vfplus.vd_id and wardwin.election_id = ward_vfplus.election_id and ward_vfplus.ballot_id = 3 and ward_vfplus.party_id = 374)
  LEFT JOIN vd_perc pr_vfplus ON (vd.id = pr_vfplus.vd_id and wardwin.election_id = pr_vfplus.election_id and pr_vfplus.ballot_id = 4 and pr_vfplus.party_id = 374)
;
CREATE INDEX ON tiles.vd_lge(election_id);
CREATE INDEX ON tiles.vd_lge USING gist(geom);
END;


BEGIN;
DROP MATERIALIZED VIEW IF EXISTS tiles.ward_lge;
CREATE MATERIALIZED VIEW tiles.ward_lge AS
SELECT 
  ward.id,
  prwin.election_id,
  ward.code,
  COALESCE(wardp.abbrev, 'TIE') as ward_win_party,
  floor(wardwin.perc)::int as ward_win_perc,
  COALESCE(prp.abbrev, 'TIE') as pr_win_party,
  floor(prwin.perc)::int as pr_win_perc,
  coalesce(floor(wardballot.total*100.0/nullif(wardballot.regpop, 0)), 0)::int as ward_turnout,
  coalesce(floor(prballot.total*100.0/nullif(prballot.regpop, 0)), 0)::int as pr_turnout,
  coalesce(floor(ward_anc.perc), 0)::int as ward_anc,
  coalesce(floor(pr_anc.perc), 0)::int as pr_anc,
  coalesce(floor(ward_da.perc), 0)::int as ward_da,
  coalesce(floor(pr_da.perc), 0)::int as pr_da,
  coalesce(floor(ward_eff.perc), 0)::int as ward_eff,
  coalesce(floor(pr_eff.perc), 0)::int as pr_eff,
  coalesce(floor(ward_ifp.perc), 0)::int as ward_ifp,
  coalesce(floor(pr_ifp.perc), 0)::int as pr_ifp,
  coalesce(floor(ward_vfplus.perc), 0)::int as ward_vfplus,
  coalesce(floor(pr_vfplus.perc), 0)::int as pr_vfplus,
  ward.geom
FROM ward
  JOIN ward_single_winner prwin ON ward.id = prwin.ward_id and prwin.ballot_id = 4
  LEFT JOIN party prp ON prwin.party_id = prp.id
  LEFT JOIN ward_single_winner wardwin ON ward.id = wardwin.ward_id and wardwin.ballot_id = 3 and wardwin.election_id = prwin.election_id
  LEFT JOIN party wardp ON wardwin.party_id = wardp.id
  LEFT JOIN ward_ballot_total wardballot ON (ward.id = wardballot.ward_id and prwin.election_id = wardballot.election_id and wardballot.ballot_id = 3)
  LEFT JOIN ward_ballot_total prballot ON (ward.id = prballot.ward_id and prwin.election_id = prballot.election_id and prballot.ballot_id = 4)
  LEFT JOIN ward_perc ward_anc ON (ward.id = ward_anc.ward_id and prwin.election_id = ward_anc.election_id and ward_anc.ballot_id = 3 and ward_anc.party_id = 24)
  LEFT JOIN ward_perc pr_anc ON (ward.id = pr_anc.ward_id and prwin.election_id = pr_anc.election_id and pr_anc.ballot_id = 4 and pr_anc.party_id = 24)
  LEFT JOIN ward_perc ward_da ON (ward.id = ward_da.ward_id and prwin.election_id = ward_da.election_id and ward_da.ballot_id = 3 and ward_da.party_id = 106)
  LEFT JOIN ward_perc pr_da ON (ward.id = pr_da.ward_id and prwin.election_id = pr_da.election_id and pr_da.ballot_id = 4 and pr_da.party_id = 106)
  LEFT JOIN ward_perc ward_eff ON (ward.id = ward_eff.ward_id and prwin.election_id = ward_eff.election_id and ward_eff.ballot_id = 3 and ward_eff.party_id = 122)
  LEFT JOIN ward_perc pr_eff ON (ward.id = pr_eff.ward_id and prwin.election_id = pr_eff.election_id and pr_eff.ballot_id = 4 and pr_eff.party_id = 122)
  LEFT JOIN ward_perc ward_ifp ON (ward.id = ward_ifp.ward_id and prwin.election_id = ward_ifp.election_id and ward_ifp.ballot_id = 3 and ward_ifp.party_id = 165)
  LEFT JOIN ward_perc pr_ifp ON (ward.id = pr_ifp.ward_id and prwin.election_id = pr_ifp.election_id and pr_ifp.ballot_id = 4 and pr_ifp.party_id = 165)
  LEFT JOIN ward_perc ward_vfplus ON (ward.id = ward_vfplus.ward_id and prwin.election_id = ward_vfplus.election_id and ward_vfplus.ballot_id = 3 and ward_vfplus.party_id = 374)
  LEFT JOIN ward_perc pr_vfplus ON (ward.id = pr_vfplus.ward_id and prwin.election_id = pr_vfplus.election_id and pr_vfplus.ballot_id = 4 and pr_vfplus.party_id = 374)
;
CREATE INDEX ON tiles.ward_lge(election_id);
CREATE INDEX ON tiles.ward_lge USING gist(geom);
END;

BEGIN;
DROP MATERIALIZED VIEW IF EXISTS tiles.muni_lge;
CREATE MATERIALIZED VIEW tiles.muni_lge AS
SELECT 
  muni.id,
  prwin.election_id,
  muni.code,
  COALESCE(wardp.abbrev, 'TIE') as ward_win_party,
  floor(wardwin.perc)::int as ward_win_perc,
  COALESCE(prp.abbrev, 'TIE') as pr_win_party,
  floor(prwin.perc)::int as pr_win_perc,
  coalesce(floor(wardballot.total*100.0/wardballot.regpop), 0)::int as ward_turnout,
  coalesce(floor(prballot.total*100.0/prballot.regpop), 0)::int as pr_turnout,
  coalesce(floor(ward_anc.perc), 0)::int as ward_anc,
  coalesce(floor(pr_anc.perc), 0)::int as pr_anc,
  coalesce(floor(ward_da.perc), 0)::int as ward_da,
  coalesce(floor(pr_da.perc), 0)::int as pr_da,
  coalesce(floor(ward_eff.perc), 0)::int as ward_eff,
  coalesce(floor(pr_eff.perc), 0)::int as pr_eff,
  coalesce(floor(ward_ifp.perc), 0)::int as ward_ifp,
  coalesce(floor(pr_ifp.perc), 0)::int as pr_ifp,
  coalesce(floor(ward_vfplus.perc), 0)::int as ward_vfplus,
  coalesce(floor(pr_vfplus.perc), 0)::int as pr_vfplus,
  muni.geom
FROM muni
  JOIN muni_single_winner prwin ON muni.id = prwin.muni_id and prwin.ballot_id = 4
  LEFT JOIN party prp ON prwin.party_id = prp.id
  LEFT JOIN muni_single_winner wardwin ON muni.id = wardwin.muni_id and wardwin.ballot_id = 3 and wardwin.election_id = prwin.election_id
  LEFT JOIN party wardp ON wardwin.party_id = wardp.id
  LEFT JOIN muni_ballot_total wardballot ON (muni.id = wardballot.muni_id and prwin.election_id = wardballot.election_id and wardballot.ballot_id = 3)
  LEFT JOIN muni_ballot_total prballot ON (muni.id = prballot.muni_id and prwin.election_id = prballot.election_id and prballot.ballot_id = 4)
  LEFT JOIN muni_perc ward_anc ON (muni.id = ward_anc.muni_id and prwin.election_id = ward_anc.election_id and ward_anc.ballot_id = 3 and ward_anc.party_id = 24)
  LEFT JOIN muni_perc pr_anc ON (muni.id = pr_anc.muni_id and prwin.election_id = pr_anc.election_id and pr_anc.ballot_id = 4 and pr_anc.party_id = 24)
  LEFT JOIN muni_perc ward_da ON (muni.id = ward_da.muni_id and prwin.election_id = ward_da.election_id and ward_da.ballot_id = 3 and ward_da.party_id = 106)
  LEFT JOIN muni_perc pr_da ON (muni.id = pr_da.muni_id and prwin.election_id = pr_da.election_id and pr_da.ballot_id = 4 and pr_da.party_id = 106)
  LEFT JOIN muni_perc ward_eff ON (muni.id = ward_eff.muni_id and prwin.election_id = ward_eff.election_id and ward_eff.ballot_id = 3 and ward_eff.party_id = 122)
  LEFT JOIN muni_perc pr_eff ON (muni.id = pr_eff.muni_id and prwin.election_id = pr_eff.election_id and pr_eff.ballot_id = 4 and pr_eff.party_id = 122)
  LEFT JOIN muni_perc ward_ifp ON (muni.id = ward_ifp.muni_id and prwin.election_id = ward_ifp.election_id and ward_ifp.ballot_id = 3 and ward_ifp.party_id = 165)
  LEFT JOIN muni_perc pr_ifp ON (muni.id = pr_ifp.muni_id and prwin.election_id = pr_ifp.election_id and pr_ifp.ballot_id = 4 and pr_ifp.party_id = 165)
  LEFT JOIN muni_perc ward_vfplus ON (muni.id = ward_vfplus.muni_id and prwin.election_id = ward_vfplus.election_id and ward_vfplus.ballot_id = 3 and ward_vfplus.party_id = 374)
  LEFT JOIN muni_perc pr_vfplus ON (muni.id = pr_vfplus.muni_id and prwin.election_id = pr_vfplus.election_id and pr_vfplus.ballot_id = 4 and pr_vfplus.party_id = 374)
;
CREATE INDEX ON tiles.muni_lge(election_id);
CREATE INDEX ON tiles.muni_lge USING gist(geom);
END;

select * FROM muni
  JOIN muni_single_winner prwin ON muni.id = prwin.muni_id and prwin.ballot_id = 4
  LEFT JOIN party prp ON prwin.party_id = prp.id
  LEFT JOIN muni_single_winner wardwin ON muni.id = wardwin.muni_id and wardwin.ballot_id = 3 and wardwin.election_id = prwin.election_id
  LEFT JOIN party wardp ON wardwin.party_id = wardp.id
where muni.id = 164

BEGIN;
DROP MATERIALIZED VIEW tiles.dist_lge;
CREATE MATERIALIZED VIEW tiles.dist_lge AS
SELECT 
  dist.id,
  wardwin.election_id,
  dist.code,
  COALESCE(wardp.abbrev, 'TIE') as ward_win_party,
  floor(wardwin.perc)::int as ward_win_perc,
  COALESCE(prp.abbrev, 'TIE') as pr_win_party,
  floor(prwin.perc)::int as pr_win_perc,
  coalesce(floor(wardballot.total*100.0/wardballot.regpop), 0)::int as ward_turnout,
  coalesce(floor(prballot.total*100.0/prballot.regpop), 0)::int as pr_turnout,
  coalesce(floor(ward_anc.perc), 0)::int as ward_anc,
  coalesce(floor(pr_anc.perc), 0)::int as pr_anc,
  coalesce(floor(ward_da.perc), 0)::int as ward_da,
  coalesce(floor(pr_da.perc), 0)::int as pr_da,
  coalesce(floor(ward_eff.perc), 0)::int as ward_eff,
  coalesce(floor(pr_eff.perc), 0)::int as pr_eff,
  coalesce(floor(ward_ifp.perc), 0)::int as ward_ifp,
  coalesce(floor(pr_ifp.perc), 0)::int as pr_ifp,
  coalesce(floor(ward_vfplus.perc), 0)::int as ward_vfplus,
  coalesce(floor(pr_vfplus.perc), 0)::int as pr_vfplus,
  dist.geom
FROM dist
  JOIN dist_single_winner wardwin ON dist.id = wardwin.dist_id and wardwin.ballot_id = 3
  LEFT JOIN party wardp ON wardwin.party_id = wardp.id
  JOIN dist_single_winner prwin ON dist.id = prwin.dist_id and prwin.ballot_id = 4 and wardwin.election_id = prwin.election_id
  LEFT JOIN party prp ON prwin.party_id = prp.id
  LEFT JOIN dist_ballot_total wardballot ON (dist.id = wardballot.dist_id and wardwin.election_id = wardballot.election_id and wardballot.ballot_id = 3)
  LEFT JOIN dist_ballot_total prballot ON (dist.id = prballot.dist_id and wardwin.election_id = prballot.election_id and prballot.ballot_id = 4)
  LEFT JOIN dist_perc ward_anc ON (dist.id = ward_anc.dist_id and wardwin.election_id = ward_anc.election_id and ward_anc.ballot_id = 3 and ward_anc.party_id = 24)
  LEFT JOIN dist_perc pr_anc ON (dist.id = pr_anc.dist_id and wardwin.election_id = pr_anc.election_id and pr_anc.ballot_id = 4 and pr_anc.party_id = 24)
  LEFT JOIN dist_perc ward_da ON (dist.id = ward_da.dist_id and wardwin.election_id = ward_da.election_id and ward_da.ballot_id = 3 and ward_da.party_id = 106)
  LEFT JOIN dist_perc pr_da ON (dist.id = pr_da.dist_id and wardwin.election_id = pr_da.election_id and pr_da.ballot_id = 4 and pr_da.party_id = 106)
  LEFT JOIN dist_perc ward_eff ON (dist.id = ward_eff.dist_id and wardwin.election_id = ward_eff.election_id and ward_eff.ballot_id = 3 and ward_eff.party_id = 122)
  LEFT JOIN dist_perc pr_eff ON (dist.id = pr_eff.dist_id and wardwin.election_id = pr_eff.election_id and pr_eff.ballot_id = 4 and pr_eff.party_id = 122)
  LEFT JOIN dist_perc ward_ifp ON (dist.id = ward_ifp.dist_id and wardwin.election_id = ward_ifp.election_id and ward_ifp.ballot_id = 3 and ward_ifp.party_id = 165)
  LEFT JOIN dist_perc pr_ifp ON (dist.id = pr_ifp.dist_id and wardwin.election_id = pr_ifp.election_id and pr_ifp.ballot_id = 4 and pr_ifp.party_id = 165)
  LEFT JOIN dist_perc ward_vfplus ON (dist.id = ward_vfplus.dist_id and wardwin.election_id = ward_vfplus.election_id and ward_vfplus.ballot_id = 3 and ward_vfplus.party_id = 374)
  LEFT JOIN dist_perc pr_vfplus ON (dist.id = pr_vfplus.dist_id and wardwin.election_id = pr_vfplus.election_id and pr_vfplus.ballot_id = 4 and pr_vfplus.party_id = 374)
;
CREATE INDEX ON tiles.dist_lge(election_id);
CREATE INDEX ON tiles.dist_lge USING gist(geom);
END;

BEGIN;
DROP MATERIALIZED VIEW tiles.prov_lge;
CREATE MATERIALIZED VIEW tiles.prov_lge AS
SELECT 
  prov.id,
  wardwin.election_id,
  prov.code,
  COALESCE(wardp.abbrev, 'TIE') as ward_win_party,
  floor(wardwin.perc)::int as ward_win_perc,
  COALESCE(prp.abbrev, 'TIE') as pr_win_party,
  floor(prwin.perc)::int as pr_win_perc,
  coalesce(floor(wardballot.total*100.0/wardballot.regpop), 0)::int as ward_turnout,
  coalesce(floor(prballot.total*100.0/prballot.regpop), 0)::int as pr_turnout,
  coalesce(floor(ward_anc.perc), 0)::int as ward_anc,
  coalesce(floor(pr_anc.perc), 0)::int as pr_anc,
  coalesce(floor(ward_da.perc), 0)::int as ward_da,
  coalesce(floor(pr_da.perc), 0)::int as pr_da,
  coalesce(floor(ward_eff.perc), 0)::int as ward_eff,
  coalesce(floor(pr_eff.perc), 0)::int as pr_eff,
  coalesce(floor(ward_ifp.perc), 0)::int as ward_ifp,
  coalesce(floor(pr_ifp.perc), 0)::int as pr_ifp,
  coalesce(floor(ward_vfplus.perc), 0)::int as ward_vfplus,
  coalesce(floor(pr_vfplus.perc), 0)::int as pr_vfplus,
  prov.geom
FROM prov
  JOIN prov_single_winner wardwin ON prov.id = wardwin.prov_id and wardwin.ballot_id = 3
  LEFT JOIN party wardp ON wardwin.party_id = wardp.id
  JOIN prov_single_winner prwin ON prov.id = prwin.prov_id and prwin.ballot_id = 4 and wardwin.election_id = prwin.election_id
  LEFT JOIN party prp ON prwin.party_id = prp.id
  LEFT JOIN prov_ballot_total wardballot ON (prov.id = wardballot.prov_id and wardwin.election_id = wardballot.election_id and wardballot.ballot_id = 3)
  LEFT JOIN prov_ballot_total prballot ON (prov.id = prballot.prov_id and wardwin.election_id = prballot.election_id and prballot.ballot_id = 4)
  LEFT JOIN prov_perc ward_anc ON (prov.id = ward_anc.prov_id and wardwin.election_id = ward_anc.election_id and ward_anc.ballot_id = 3 and ward_anc.party_id = 24)
  LEFT JOIN prov_perc pr_anc ON (prov.id = pr_anc.prov_id and wardwin.election_id = pr_anc.election_id and pr_anc.ballot_id = 4 and pr_anc.party_id = 24)
  LEFT JOIN prov_perc ward_da ON (prov.id = ward_da.prov_id and wardwin.election_id = ward_da.election_id and ward_da.ballot_id = 3 and ward_da.party_id = 106)
  LEFT JOIN prov_perc pr_da ON (prov.id = pr_da.prov_id and wardwin.election_id = pr_da.election_id and pr_da.ballot_id = 4 and pr_da.party_id = 106)
  LEFT JOIN prov_perc ward_eff ON (prov.id = ward_eff.prov_id and wardwin.election_id = ward_eff.election_id and ward_eff.ballot_id = 3 and ward_eff.party_id = 122)
  LEFT JOIN prov_perc pr_eff ON (prov.id = pr_eff.prov_id and wardwin.election_id = pr_eff.election_id and pr_eff.ballot_id = 4 and pr_eff.party_id = 122)
  LEFT JOIN prov_perc ward_ifp ON (prov.id = ward_ifp.prov_id and wardwin.election_id = ward_ifp.election_id and ward_ifp.ballot_id = 3 and ward_ifp.party_id = 165)
  LEFT JOIN prov_perc pr_ifp ON (prov.id = pr_ifp.prov_id and wardwin.election_id = pr_ifp.election_id and pr_ifp.ballot_id = 4 and pr_ifp.party_id = 165)
  LEFT JOIN prov_perc ward_vfplus ON (prov.id = ward_vfplus.prov_id and wardwin.election_id = ward_vfplus.election_id and ward_vfplus.ballot_id = 3 and ward_vfplus.party_id = 374)
  LEFT JOIN prov_perc pr_vfplus ON (prov.id = pr_vfplus.prov_id and wardwin.election_id = pr_vfplus.election_id and pr_vfplus.ballot_id = 4 and pr_vfplus.party_id = 374)
;
CREATE INDEX ON tiles.prov_lge(election_id);
CREATE INDEX ON tiles.prov_lge USING gist(geom);
END;
