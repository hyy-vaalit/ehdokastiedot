HYYn edustajistovaalien tietojärjestelmä
========================================

Monoliitti, joka suuren osan edustajistovaalien uurnavaaliin liittyvästä hallinnosta.

Järjestelmässä on eri tasoisia käyttäjiä:

* Pääkäyttäjä (role:admin) ja rajoitettu pääkäyttäjä (role:secretary):
  * `app/models/AdminUser.rb`
  * /admin
  * admin@example.com / pass123
  * Kaikki HYYn henkilökunnan tarvitsemat toiminnot.
  * Voi kirjautua sisään, kun tauluun `admin_users` on luotu käyttäjä,
    jolla on salasana.

* Vaaliliiton asiamies:
  * `app/models/AdvocateUser.rb`
  * /advocates
  * asiamies1@example.com / pass123
  * Vaaliliiton asiamies syöttää ehdokastiedot ja luo vaaliliiton.
  * Voi kirjautua sisään kun `GlobalConfiguration.advocate_login_enabled?`

* Uurnavaalin äänestysalueen henkilöstö:
  * `app/models/VotingAreaUser.rb`
  * /voting
  * II@hyy.fi / pass123 (äänestysalueen tunnus: EI..EV ja I..XX)
  * Äänestysalue tarkistaa äänestäjän äänioikeuden
  * Äänestyksen päätyttyä äänestysalue syöttää äänestyslipuista lasketut äänet
    äänestysalueen tuloslaskentapöytäkirjaan.
  * Voi kirjautua sisään, jos tauluun `voting_area_users` on luotu äänestysalue,
    jolla on salasana.

* Tarkastuslaskentalautakunnan puheenjohtaja:
  * `app/models/checking_minutes_user.rb`
  * /checking_minutes
  * tlkpj / pass123
  * Tuottaa äänestysalueiden tarkastuslaskentapöytäkirjat, joita vasten
    tarkastuslaskenta suoritetaan.
  * Tarkastuslaskennan korjatut äänimäärät syötetään tänne.
  * Voi kirjautua sisään, kun `Vaalit::Config::CHECKING_MINUTES_ENABLED`

Käyttöoikeudet on määritety tiedostossa `app/models/ability.rb`.
* ActiveAdmin kysyy automaattiessti jokaiselle resurssille `can? action, resource`,
  esim `can? :read, Candidate`.
* Devisen login/logout controllereissa authorization ohitetaan, koska käyttäjänä
  on silloin unauthenticated guest.
* Koska ActiveAdmin toteuttaa auktorisoinnin omalla tavallaan, `ApplicationController`
  sivuuttaa `check_authorization` defaultin ActiveAdminin alla.
  Tämä on hämmentävältä tuntuva ominaisuus, joka
  [on raportoitu issueksi](https://github.com/activeadmin/activeadmin/issues/4599).



# Yleiskuva järjestelmän toiminnoista

* Ehdokastietojen syöttö
* Ehdokasasettelun päättyminen: Alustava ehdokaslista KVL:lle
* Ehdokastietojen korjausvaihe: Uusia ehdokkaita/liittoja ei voi luoda. Korjauksista jää merkintä logiin.
* Ehdokaslistan vahvistaminen: ehdokastietoihin ei voi enää syöttää korjauksia.
* Ylläpitonäkymä vaalirenkaiden, vaaliliittojen ja ehdokkaiden hallintaan.
* Ehdokasnumerointi.
* Uurnavaalin äänioikeuden hallinta äänestysalueille.
* Uurnavaalin äänten syöttäminen: äänestysalue laskee paperilaput ja syöttää tulospöytäkirjan tiedot järjestelmään.
* Äänestysalueiden ottaminen mukaan vaalitulokseen: alustava tulos vaalivalvojaisissa ja S3:ssa
* Alustava vaalitulos on laskettu ja julkaistu.
* Tarkistuslaskenta: tlk-pj syöttää tarkastuspöytäkirjasta korjatut äänimäärät järjestelmään.
* Tarkistuslaskennan tuloksen perusteella laskettu uusi vaalitulos.
* Arvonnat KVL:n kokouksessa uuden vaalituloksen mukaan
* Lopullinen vaalitulos, jonka KVL vahvistaa.
* Lopullisen vaalituloksen julkaisu.


## Seuraaviin vaaleihin

* Varmista opiskelijarekisterin datadumpin muoto:
  - Vuoden 2014 datassa ei huomioitu 2000-luvulla syntyneitä, eli hetun erotinmerkki puuttui datasta.
    Parseriin on kovakoodattu väliviiva, tarkista pitääkö oletus edelleen paikkansa.
  - Merkistökoodauksena ISO-8859-1

## Kustannukset

* SSL Endpoint ($20 / kk)
* Sertifikaatti ($49 / vuosi)
* Postgres ($9 / kk)
* Sendgrid ($20 yhdeltä kuukaudelta)
* Rollbar (Free: 3000 occurrences per month, 30 days retention)
* Worker
  - kun ehdokasilmoittautumisen sähköposti
  - vaalivalvojaiset
  - arvonnat ja vaalituloksen vahvistaminen
* Herokun kaksi web dynoa


# Ympäristö pystyyn

Esivaatimukset:
* Asenna [RVM](https://rvm.io/)
* RVM:n asentamisen jälkeen lue `.ruby-gemset` ja `.ruby-version: `cd .. && popd`
* Asenna gemit: `bundle install`

Kopioi `.env.example` -> `.env` ja aseta sinne sopivat defaultit.

Aja testit:
```bash
rake db:runts
rspec
```

a) Alusta tietokanta ja syötä seed-data:
```bash
rake db:runts
rake db:seed:dev
```

b) Alusta tietokanta manuaalisesti:
```bash
rake db:create
rake db:schema:load
rake -T db:seed
```

Tsekkaa `Procfile` ja komenna:

~~~
foreman start
~~~ 

Avaa Admin UI
* http://localhost:5000/admin
* admin@example.com / pass123
* Seed data, ks. "rake db:seed:dev"

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



## Heroku-ympäristön pystyttäminen

Hanki uusi Rollbar access key: rollbar.com

Aseta ympäristömuuttujat: `heroku config:add key=value`.
Tiedostossa `.env.example` on lista vaadituista ympäristömuuttujista.

Syötä seed-data, jossa peruskonffit muttei vanhaa vaalidataa:
```bash
heroku run rake db:schema:load
heroku run rake db:seed:production
```

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
```bash
heroku ps:scale worker=1 -a APP_NAME
```

### Äänioikeutettujen import

~~~
rake voters:import filename=test-export.txt
~~~


### Tuotantokannan lataaminen omalle koneelle

1) Backupista dumppifileksi
https://devcenter.heroku.com/articles/heroku-postgres-import-export

```bash
# tee tuore backup
heroku pgbackups:capture -a hyy-vaalit

# SEKRIT_URL
heroku pgbackups:url -a hyy-vaalit

# Siirrä SEKRIT_URLista paikalliseen postgresiin
heroku pgbackups:restore DATABASE SEKRIT_URL -a hyy-vaalit

# Download SQL dump file
curl -o latest.dump "SEKRIT_URL"
```


2) Suoraan ilman dumppitiedostoa
```bash
rake db:drop
heroku pg:info

heroku pg:pull HEROKU_POSTGRESQL_IVORY_URL hyyvaalit -a hyy-vaalit
```

## AWS-konfiguraatio

AWS IAM sisältää konfiguraation tuotanto, staging ja koe -käyttäjätunnuksille.

Nämä on tehtävä jokaiseen bucketiin jota käytetään (tuotanto, staging, koe):

* Luo vuosiluvulle uusi hakemisto.

* Lisää kullekin AWS-käyttäjälle IAM-hallintapaneelista kirjoitusoikeus bucketin vuosilukuhakemistoon (Vaalit::Results::DIRECTORY on esim "2012").

* Poista jokaiselta AWS-käyttäjältä kirjoitusoikeus edellisten vaalien hakemistoon.
Näin vanhat tulokset ovat turvassa.

* Testaa AWS-kirjoitusoikeus tuotannossa:
```ruby
> AWS::S3::S3Object.store("#{Vaalit::Results::DIRECTORY}/lulz.txt", "Lulz: #{Time.now}", Vaalit::Results::S3_BUCKET_NAME, :content_type => 'text/html; charset=utf-8')
```


## Kehitysympäristön pystyttäminen

Vuoden 2009 vaalien data:
```bash
rake db:seed:dev
```

## Staging-ympäristön alustus
```bash
heroku pg:reset DATABASE --app APP_NAME
# paikallinen staging-branch herokun master-branchiin.
git push [-f] staging [staging:master]
heroku run rake db:schema:load --app APP_NAME
heroku run rake db:seed:[production|dev] --app APP_NAME
heroku restart --app APP_NAME
```

### AWS in Staging

```bash
heroku config:set KEY=VALUE --app APP_NAME
```
  * S3_BUCKET_NAME       (hyy-vaalitulos-staging)
  * S3_BASE_URL          (s3.amazonaws.com)
  * S3_ACCESS_KEY_ID     (IAM User)
  * S3_ACCESS_KEY_SECRET (IAM User)

NOTE (09/2011): The AWS::S3 does not work properly with any other region than US.


# Vaalien konfigurointi

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


## Esimerkkikäyttäjätunnukset (testi-seed)

* Kehitysympäristön salasanat: pass123
* Tuotantoseedin esimerkkisalasanat: salainensana


### Pääkäyttäjät

http://localhost:3000/admin
* admin@example.com / pass123
* Ks. kohta "Salasanat".

### Äänestysalueet

http://localhost:3000/voting_area/

Käyttäjätunnus: äänestysalueen tunnus, esimerkiksi:
  * EI, EII, .., EIV
  * I, II, III, .., XV

Ks. kohta "Salasanat".


### Tarkastuslaskenta

http://localhost:3000/checking_minutes

Käyttäjätunnus: tlkpj

Ks. kohta "Salasanat".


### Asiamiesten korjaukset ehdokastietoihin

http://localhost:3000/advocates

Käyttäjätunnukset (kehitysympäristössä):
  * asiamies1@example.com (123456-123K)
  * asiamies2@example.com (123456-9876)

Ks. kohta "Salasanat".


# Pekka's Tips

  * Jos Gemeissä ongelmia, päivitä `gem update --system`

  * Jos Gemfile.lock pitää luoda uudelleen ja jää
    "Resolving dependencies" -luuppiin, kommentoi pois kaikki muut gemit
    paitsi `rails` ja lisää ne takaisin ryhmä kerrallaan.

  * Debugging: luo breakpoint laittamalla koodiin `debugger` tai `byebug`.

  * Jos Formtasticin virheet ei tule näkyviin, varmista että on
    - `<%= semantic_form_for @voter ..%>` EIKÄ `:voter`
    - .. näistä jälkimmäinen antaa oudon virheen.

  * Opiskelijarekisterin data tulee `.7z`-tiedostona.
    - `brew install p7zip`
    - `7z x tiedosto.7z`

## Testit

* Aja vain yksi testi:
  - lisää `:focus` testiin, myös alias "f", esim "fit", "fdescribe", "fcontext"
  - komentoriviltä (huom, tämä ei nollaa tietokantaa ilman rakea):
    `rake spec SPEC=spec/lib/result_decorator_spec.rb`

* Seuraa muutoksia testeihin: `guard`
  - Aja `rake db:test:prepare` migraatioiden jälkeen.


# End-to-End Testikierros

  * Nollaa tietokanta: `rake db:runts`
  * Syötä seed-data: `rake db:seed:dev`
  * Avaa `rails console`
  * Merkitse vaaliliitot valmiiksi:
    - `ElectoralAlliance.all.each { |a| a.freeze! }`
  * (Tässä vaiheessa voit halutessasi jakaa ehdokasnumerot uudelleen)
  * Merkitse äänestysalueet valmiiksi ääntenlaskentaa varten:
    - `VotingArea.all.each { |a| a.submitted! }`
    - Tai: Äänestysalueen kirjautuminen > merkitse valmiiksi
  * Ota äänestysalueet mukaan ääntenlaskentaan
    - `VotingArea.all.each { |a| a.ready! }`
    - Tai: Admin > Äänestysalueet ääntenlaskentaan
  * Mene ActiveAdmin -> Vaalivalvojaiset -> Äänestysalueet ääntenlaskentaan
    - `Delayed::Job.enqueue(CreateResultJob.new)`
    - Tai: valitse halutut äänestysalueet ja paina "ota äänestysalueet laskentaan"
  * Jonossa on nyt taustatyö `CreateResultJob`. Listaa taustalle laitetut työt:
    - `Delayed::Job.all`
  * Jono purkautuu vasta, kun Worker on käynnistetty.
    - `rake jobs:work`
    - tai `Procfile`:n mukaan web+worker: `foreman start`
  * Alustava vaalitulos näkyy tulossivulla.
    - konsolista: `puts ResultDecorator.decorate(Result.last).to_html`
  * Alustavan vaalituloksen jälkeen suoritetaan tarkastuslaskenta, jossa
    tarkastuslaskentalautakunnan puheenjohtaja syöttää korjatut äänimäärät:
    - Admin > tarkastuslaskenta
  * Tarkastuslaskenta merkitään valmiiksi:
    - Admin > Danger Zone > Merkitse tarkastuslaskenta valmiiksi
  * Tarkistuslaskennan jälkeen suoritetaan arvonnat:
    - Admin > Arvonnat
  * Alustavassa tuloksessa on kolmentasoisia tasatilanteita:
    - äänimäärät tasan vaaliliiton sisällä
    - liittovertailuluku tasan vaalirenkaan liittojen kesken
    - rengasvertailuluku tasan vaalirenkaiden kesken
  * Kun suoritat arvontoja seed-datalla, tarkkaile paikkaa 60/61, jossa
    rengasvertailuluku menee tasan kahden eri renkaan kesken.
  * Arvonnat suoritetaan yksitellen joko käsin tai automaattisesti.
    HYY on perinteisesti suorittanut käsin varsinaisiin ja
    varaedustajapaikkoihin kohdistuvat arvonnat.
  * Arvontojen jälkeen lopullinen vaalitulos on valmis:
    - Admin > Lopullinen vaalitulos
  * Tuloksen esitysmuoto (html/json) generoidaan kehitysympäristössä aina
    uusiksi. Tuotannossa esitysmuoto generoidaan kerran ja talletetaan S3:een.
    - S3:een talletettu vaalitulos esitetään vaalitulos.hyy.fi -palvelusta.
    - Julkaisematon S3:n vaalitulos esitetään antamalla "salainen" tiedostonimi:
      http://vaalitulos.hyy.fi/2014/result-alustava-20160825193119.html

Kun olet generoinut vaalituloksen alusta loppuun vuoden 2009 seed-datalla,
vaalituloksen vertailulukujen, äänimäärien ja paikkojen pitää vastata [vuoden
2009 vaalitulosta](http://vaalitulos.hyy.fi/2009/). Tarkista erityisesti
edustajistopaikka 60/61, jossa rengasvertailuluku menee tasan HYAL:n ja
Kokoomusopiskelijoiden kesken. Paikka määräytyy arvonnan lopputuloksen
perusteella.

Vuoden 2009 vaalitulos on
laskettu aiemmalla vaalijärjestelmällä `vaalit.exe`, jonka toiminta on
täysin riippumatonta Rails-järjestelmästä.



### Vinkkejä testaamiseen:

  * Jos taustatyö feilaa, sen uudelleenyritys skeduloidaan eksponentiaalisesti,
  eli viimeinen yritys on joskus 2 viikon kuluttua. Rollbar ei nappaa virhettä
  jos työ ei ole failannut vaan on pelkässä retry-jonossa
  (esim. AWS permission denied).
  * Työn käynnistäminen manuaalisesti:
    - `Delayed::Job.find(XX).invoke_job`


## Muistiinpanoja

  * Draper on hidas ison collectionin koristelussa.
    Uudet decoratorit kannattaa tehdä ilman Draperia.
    Ks. esim CandidateExport ja http://thepugautomatic.com/2014/03/draper/
