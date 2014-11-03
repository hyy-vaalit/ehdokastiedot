Vaalien vaiheet
===============

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


Seuraaviin vaaleihin
====================
* Varmista opiskelijarekisterin datadumpin muoto:
  - Vuoden 2014 datassa ei huomioitu 2000-luvulla syntyneitä, eli hetun erotinmerkki puuttui datasta.
    Parseriin on kovakoodattu väliviiva, tarkista pitääkö oletus edelleen paikkansa.
  - Merkistökoodauksena ISO-8859-1

Kustannukset
============

* SSL Endpoint ($20 / kk)
* Sertifikaatti ($49 / vuosi)
* Postgres ($9 / kk)
* Sendgrid ($20 yhdeltä kuukaudelta)
* Rollbar (Free: 3000 occurrences per month, 30 days retention)
* Worker
  - kun ehdokasilmoittautumisen sähköposti
  - vaalivalvojaiset
  - arvonnat ja vaalituloksen vahvistaminen
* Tarvitseeko toisen dynon?


Järjestelmä käyntiin
====================

Kopioi `.env.example` -> `.env` ja aseta sinne sopivat defaultit.

Tsekkaa `Procfile` ja komenna:

~~~
foreman start
~~~

Jos ActiveAdminin tyylit ei näy, esikäännä assetit:

~~~
rake assets:precompile
~~~

Tämä luo tiedostot hakemistoon `public/assets`.
Tätä EI PITÄISI tarvita development-modessa, mutta en keksinyt
miksei ActiveAdminin tyylit näy ilman precompilea (muut tyylit löytyy
paitsi active_admin.css).

HUOM! Refreshaa selain forcella, cmd-shift-r -- muutoin saattaa tulla cachesta
väärää dataa (tyylit ei näy, mutta forcella näkyy).

Ympäristön pystyttäminen
========================

Kehitysympäristön reset, tietokannan alustus ja seedidatan syöttö:
~~~
$ rake runts
~~~

Pelkän tietokannan alustaminen
~~~
$ rake db:create
$ rake db:schema:load
$ rake -T seed
~~~

Äänioikeutettujen import

~~~
rake voters:import filename=test-export.txt
~~~


Tuotantokannan lataaminen omalle koneelle

1) Backupista dumppifileksi
https://devcenter.heroku.com/articles/heroku-postgres-import-export

2) Suoraan ilman dumppitiedostoa
~~~
rake db:drop
heroku pg:info

heroku pg:pull HEROKU_POSTGRESQL_IVORY_URL hyyvaalit -a hyy-vaalit
~~~

Heroku-ympäristön pystyttäminen
===============================

Konfiguroi Airbraken access key ja asenna Gem.

Heroku-ympäristö vaatii seuraavat ympäristömuuttujat (heroku config:add):
  - S3_ACCESS_KEY_ID
  - S3_ACCESS_KEY_SECRET
  - S3_BUCKET_NAME
  - RESULT_ADDRESS (http://vaalitulos.hyy.fi; huom! muista http:// alkuun)
  - TZ=Europe/Helsinki (Railsin oma timezone-määritys ei riitä)
  - ROLLBAR_ACCESS_TOKEN (exceptions, http://rollbar.com, valitse vaihtoehdoista "post_server_item")
    Huom! Default-token on määritetty `config/initializers/rollbar.rb`

~~~
$ heroku config:add S3_ACCESS_KEY_ID=... S3_ACCESS_KEY_SECRET=... S3_BASE_URL=s3.amazonaws.com --app hyy-vaalit
~~~

Tuotanto-seed vaatii äänestysalueiden salasanojen syötön ennen `rake production_seed` komennon ajamista.
Ympäristö, jossa peruskonffit muttei vanhaa vaalidataa:
~~~
$ rake seed:production
~~~

Lisää add-onssit:

  * Postgres
  * Loggly (Logien vastaanottamiseen, `heroku addons:open loggly`)
  * Sendgrid Pro (kaikille ehdokkaille lähetetään sähköposti ehdokasasettelun päättymisen jälkeen)
  * Worker sähköpostin lähettäjäksi (disabloi sen jälkeen kun ehdokasasettelun meilit lähetetty)
  * Worker vaalituloksen laskemiseen (enabloi ennen vaalivalojaisia, disabloi seuraavana päivänä)
  * Worker tarkastuslaskentaan (enabloi ennen viimeistä KVL-kokousta, disabloi kun lopullinen tulos julki)
    (Vaihtoehtona myös pitää worker koko ajan päällä, jos siitä halutaan maksaa.)
  * PG Backups
  * PG database plan, jossa rajat ei ota vastaan (viimeistään päivää ennen ääntenlaskentaa)
    https://devcenter.heroku.com/articles/migrating-from-a-dev-to-a-basic-database

Worker:
~~~
$ heroku ps:scale worker=1 -a APP_NAME
~~~

Muuta ennen vaaleja `config/initializers/secret_token.rb`.


AWS-konfiguraatio
-----------------

Nämä on tehtävä jokaiseen bucketiin jota käytetään (tuotanto, staging, koe):

Luo vuosiluvulle uusi hakemisto.

AWS IAM sisältää konfiguraation tuotanto, staging ja koe -käyttäjätunnuksille.

Lisää kullekin AWS-käyttäjälle IAM-hallintapaneelista kirjoitusoikeus bucketin vuosilukuhakemistoon (Vaalit::Results::DIRECTORY on esim "2012").

Poista jokaiselta AWS-käyttäjältä kirjoitusoikeus edellisten vaalien hakemistoon.
Näin vanhat tulokset ovat turvassa.

Testaa AWS-kirjoitusoikeus tuotannossa:
> AWS::S3::S3Object.store("#{Vaalit::Results::DIRECTORY}/lulz.txt", "Lulz: #{Time.now}", Vaalit::Results::S3_BUCKET_NAME, :content_type => 'text/html; charset=utf-8')



Kehitysympäristön pystyttäminen
===============================

Vuoden 2009 vaalien data:
~~~
$ rake seed:development
~~~

Staging-ympäristön runts
========================
~~~
$ heroku pg:reset DATABASE --app APP_NAME
$ git push [-f] staging [staging:master]  # paikallinen staging-branch herokun master-branchiin.
$ heroku run rake db:schema:load --app APP_NAME
$ heroku run rake seed:[production|development] --app APP_NAME
$ heroku restart --app APP_NAME
~~~

AWS
===

~~~
$ heroku config:set KEY=VALUE --app APP_NAME
~~~
  * S3_BUCKET_NAME       (hyy-vaalitulos-staging)
  * S3_BASE_URL          (s3.amazonaws.com)
  * S3_ACCESS_KEY_ID     (IAM User)
  * S3_ACCESS_KEY_SECRET (IAM User)

NOTE: The AWS::S3 does not work properly with any other region than US.
Should try e.g. https://github.com/qoobaa/s3 for better S3 integration

Heroku
------

  * AWS-ympäristömuuttujat
    - Ks. yllä
  * Sendgrid (tuotantoon tarvii maksullisen)
    - ENV["SENDGRID_DOMAIN"]=hyy.fi


Vaalien konfigurointi
=====================

Tarkista `config/initializers/000_vaalit.rb`

Greppaa edellisen vaalityöntekijän nimeä ja muuta se tarvittaessa uudempaan.

Aseta päivämäärät
  * ehdokasasettelun päättymiselle
  * tietojen korjaamiselle
  * GlobalConfiguration#candidate_nomination_ends_at
  * GlobalConfiguration#candidate_data_is_freezed_at

Toimita salasanat HYY:lle
  * äänestysalueet (editoi seed:production)
  * admin (luo Active Administa, salasana tulee meilitse)
  * Sendgrid (heroku config)


Esimerkkikäyttäjätunnukset (testi-seed)
=======================================

* Kehitysympäristön salasanat: pass123
* Tuotantoseedin esimerkkisalasanat: salainensana


ATK-vastaava
------------

* http://localhost:3000/admin
* admin@example.com / pass123
* Ks. kohta "Salasanat".


Äänestysalueet
--------------

http://localhost:3000/voting_area/

Käyttäjätunnus tuotannossa: äänestysalueen tunnus, esimerkiksi:
  * EI, EII, .., EIV
  * I, II, III, .., XV

Käyttäjätunnus kehitysdatassa:
  * E1, E2, .., E5
  * 1, 2, 3, ..., 20

Ks. kohta "Salasanat".


Tarkastuslaskenta
-----------------

http://localhost:3000/checking_minutes

Käyttäjätunnus: tlkpj

Ks. kohta "Salasanat".


Asiamiesten korjaukset
----------------------

http://localhost:3000/advocates

Käyttäjätunnukset (kehitysympäristössä):
  * asiamies1@example.com (123456-123K)
  * asiamies2@example.com (123456-9876)

Ks. kohta "Salasanat".


Pekka's Tips
------------

  * Jos Gemeissä ongelmia, päivitä `gem update --system`
  * Jos Gemfile.lock pitää luoda uudelleen ja jää "Resolving dependencies" -luuppiin, kommentoi pois kaikki muut gemit paitsi rails ja lisää ne takaisin ryhmä kerrallaan.
  * Debugging: luo breakpoint laittamalla koodiin `byebug` -- toimii vaan vähän huonosti foreman/unicornin kanssa.
  * Aja vain yksi testi:
    * lisää `:focus` testiin, esim. it 'something', :focus do .. end, jonka jälkeen `rake spec`
    * (huom, ei nollaa tietokantaa ilman rakea):
    `rake spec SPEC=spec/lib/result_decorator_spec.rb`
    * `guard` (voi käyttää `:focus` tai ilman, jos ilman niin ajaa ensin kaikki testit
      ja jää sen jälkeen kuuntelemaan muutoksia)
    * Muista ajaa `rake db:test:prepare` migraatioiden jälkeen.
  * Jos Formtasticin virheet ei tule näkyviin, varmista että on
    `<%= semantic_form_for @voter ..%>` EIKÄ `:voter` .. näistä jälkimmäinen antaa oudon virheen.
  * Opiskelijarekisterin data tulee `.7z`-tiedostona.
    - `brew install p7zip`
    - `7z x tiedosto.7z`

Testirundi
==========

  * Merkitse vaaliliitot valmiiksi:
    - `ElectoralAlliance.all.each { |a| a.freeze! }`
  * Äänestysalueet laskentaan:
    - `VotingArea.all.each { |a| a.submitted! }`
  * Listaa taustalle laitetut työt:
    - `Delayed::Job.all`
  * Jos taustatyö feilaa, sen uudelleenyritys skeduloidaan eksponentiaalisesti, eli viimeinen yritys
   on joskus 2 viikon kuluttua ... Rollbar ei nappaa virhettä jos työ ei ole failannut vaan on
   pelkässä retry-jonossa (esim. AWS permission denied).
  * Työn käynnistäminen manuaalisesti:
    - `Delayed::Job.find(XX).invoke_job`
  * Esimerkkidatassa seed:development on 2009 vaalitulos.
    - Tsekkaa vaalisija 60/61 jonka äänet menevät tasan ja lopputulos rengasvertailuluvn arvontaan.


Muistiinpanoja
--------------
  * Draper on tosi hidas ison collectionin koristelussa.
    CandidateDecorator toimii n. 1000 alkiolla, mutta
    sama pattern 28000 äänestäjällä jumahti täysin.
    Jos Draperista pitää refaktoroida, tsekkaa http://thepugautomatic.com/2014/03/draper/
