== Vaalien vaiheet
* Ehdokastietojen syöttö
* Ehdokasasettelun päättyminen: Alustava ehdokaslista KVL:lle
* Ehdokastietojen korjausvaihe: Uusia ehdokkaita/liittoja ei voi luoda. Korjauksista jää merkintä logiin.
* Ehdokaslistan vahvistaminen: ehdokastietoihin ei voi enää syöttää korjauksia.
* Ehdokasnumerointi.
* Äänten syöttäminen: äänestysalue laskee paperilaput ja syöttää tulospöytäkirjan tiedot järjestelmään.
* Äänestysalueiden ottaminen mukaan vaalitulokseen: alustava tulos vaalivalvojaisissa ja S3:ssa
* Alustava vaalitulos on laskettu ja julkaistu.
* Tarkistuslaskenta: tlk-pj syöttää tarkastuspöytäkirjasta korjatut äänimäärät järjestelmään.
* Tarkistuslaskennan tuloksen perusteella laskettu uusi vaalitulos.
* Arvonnat KVL:n kokouksessa uuden vaalituloksen mukaan
* Lopullinen vaalitulos, jonka KVL vahvistaa.
* Lopullisen vaalituloksen julkaisu.


== Yleisen ympäristön pystyttäminen

Projektissa on (väärin)käytössä redis (poistuu kun tlk-pj tunnarit pois redisistä)

$ brew install redis
$ redis-server

Kehitysympäristön reset, tietokannan alustus ja seedidatan syöttö:
$ rake runts

Pelkän tietokannan alustaminen

$ rake db:create
$ rake db:schema:load
$ rake -T seed

Taustaprosessointia varten Delayed Job, worker kehitysympäristössä:

$ rake jobs:work

Herokuun projekti tarvitsee myös workerin.


== Tuotantoympäristön pystyttäminen

Tuotantoympäristö vaatii seuraavat ympäristömuuttujat (heroku config:add):
- S3_ACCESS_KEY_ID
- S3_ACCESS_KEY_SECRET
- S3_BUCKET_NAME
- RESULT_ADDRESS (http://vaalitulos.hyy.fi)
- TZ=Europe/Helsinki (Railsin oma timezone-määritys ei riitä)

$ heroku config:add S3_ACCESS_KEY_ID=... S3_ACCESS_KEY_SECRET=... S3_BASE_URL=s3.amazonaws.com --app hyy-vaalit

Anna AWS-käyttäjälle IAM-hallintapaneelista kirjoitusoikeus bucketin vuosilukuhakemistoon (Vaalit::Results::DIRECTORY on esim "2012").

Testaa AWS-kirjoitusoikeus tuotannossa:
> AWS::S3::S3Object.store("#{Vaalit::Results::DIRECTORY}/lulz.txt", "Lulz: #{Time.now}", Vaalit::Results::S3_BUCKET_NAME, :content_type => 'text/html; charset=utf-8')

Tuotanto-seed vaatii äänestysalueiden salasanojen syötön ennen `rake production_seed` komennon ajamista.
Ympäristö, jossa peruskonffit muttei vanhaa vaalidataa:

$ rake seed:production

Addons:
* Sendgrid Pro (kaikille ehdokkaille lähetetään sähköposti ehdokasasettelun päättymisen jälkeen)
* Worker sähköpostin lähettäjäksi (disabloi sen jälkeen kun ehdokasasettelun meilit lähetetty)
* Worker vaalituloksen laskemiseen (enabloi ennen vaalivalojaisia, disabloi seuraavana päivänä)
* Worker tarkastuslaskentaan (enabloi ennen viimeistä KVL-kokousta, disabloi kun lopullinen tulos julki)
  (Vaihtoehtona myös pitää worker koko ajan päällä, jos siitä halutaan maksaa.)
* PG Backups
* PG database plan, jossa rajat ei ota vastaan (viimeistään päivää ennen ääntenlaskentaa)
  https://devcenter.heroku.com/articles/migrating-from-a-dev-to-a-basic-database

Worker:
$ heroku ps:scale worker=1 -a APP_NAME

Muuta ennen vaaleja `config/initializers/secret_token.rb`.


== Kehitysympäristön pystyttäminen

Vuoden 2009 vaalien data:

$ rake seed:development

== Staging-ympäristön runtsaus

$ heroku pg:reset DATABASE --app APP_NAME
$ git push [-f] staging [staging:master]  # paikallinen staging-branch herokun master-branchiin.
$ heroku run rake db:schema:load --app APP_NAME
$ heroku run rake seed:[production|development] --app APP_NAME
$ heroku restart --app APP_NAME

== AWS
$ heroku config:set KEY=VALUE --app APP_NAME, seuraaville:
  * S3_BUCKET_NAME       (hyy-vaalitulos-staging)
  * S3_BASE_URL          (s3.amazonaws.com)
  * S3_ACCESS_KEY_ID     (IAM User)
  * S3_ACCESS_KEY_SECRET (IAM User)

NOTE: The AWS::S3 does not work properly with any other region than US.
Should try e.g. https://github.com/qoobaa/s3 for better S3 integration

== Heroku
  * Redis to go
    - Lisää Add-on
    - Tarkista että `config/initializers/redis.rb` on ajantasalla
  * AWS-ympäristömuuttujat
    - Ks. yllä
  * Sendgrid (tuotantoon tarvii maksullisen)
    - ENV["SENDGRID_DOMAIN"]=hyy.fi

== Airbrake

Konfiguroi Airbrake ajonaikaisten virheiden nappaamiseksi sekä stagingiin että tuotantoon.

Tarkista `config/initializers/hoptoad.rb`


== Vaalien konfigurointi

Tarkista `config/initializers/000_vaalit.rb`

Aseta päivämäärät
  * ehdokasasettelun päättymiselle
  * tietojen korjaamiselle
  * GlobalConfiguration#candidate_nomination_ends_at
  * GlobalConfiguration#candidate_data_is_freezed_at

== Esimerkkikäyttäjätunnukset (testi-seed)

=== Salasanat
Kehitysympäristön salasanat: pass123
Tuotantoseedin esimerkkisalasanat: salainensana


=== ATK-vastaava
http://localhost:3000/admin
admin@example.com / pass123
Ks. kohta "Salasanat".


=== Äänestysalueet

http://localhost:3000/voting_area/

Käyttäjätunnus tuotannossa: äänestysalueen tunnus, esimerkiksi:
  EI, EII, .., EIV
  I, II, III, .., XV

Käyttäjätunnus kehitysdatassa:
  E1, E2, .., E5
  1, 2, 3, ..., 20

Ks. kohta "Salasanat".


=== Tarkastuslaskenta

http://localhost:3000/checking_minutes

Käyttäjätunnus: tlkpj

Ks. kohta "Salasanat".


=== Asiamiesten korjaukset

http://localhost:3000/advocates

Käyttäjätunnukset (kehitysympäristössä):
  asiamies1@example.com (123456-123K)
  asiamies2@example.com (123456-9876)

Ks. kohta "Salasanat".


=== Pekka's Tips

  * Jos CSS ei generoidu, tarkista `config/initializers/sass.rb`

=== Testirundi

  * Merkitse vaaliliitot valmiiksi:
    - `ElectoralAlliance.all.each { |a| a.freeze! }`
