# HYYn edustajistovaalien tietojärjestelmä

Järjestelmässä on eri tasoisia käyttäjiä:

* Pääkäyttäjä (role:admin) ja rajoitettu pääkäyttäjä (role:secretary):
  * `app/models/AdminUser.rb`
  * /admin
  * admin@example.com / pass123
  * Kaikki HYYn henkilökunnan tarvitsemat toiminnot.
  * Voi kirjautua sisään, kun tauluun `admin_users` on luotu käyttäjä,
    jolla on salasana.

* Vaaliliiton edustaja:
  * `app/models/AdvocateUser.rb`
  * /advocates
  * edustaja1@example.com / pass123
  * Vaaliliiton edustaja syöttää ehdokastiedot ja luo vaaliliiton.
  * Voi kirjautua sisään kun `GlobalConfiguration.advocate_login_enabled?`

Käyttöoikeudet on määritety tiedostossa `app/models/ability.rb`.
* ActiveAdmin kysyy automaattiessti jokaiselle resurssille `can? action, resource`,
  esim `can? :read, Candidate`.
* Devisen login/logout controllereissa authorization ohitetaan, koska käyttäjänä
  on silloin unauthenticated guest.
* Koska ActiveAdmin toteuttaa auktorisoinnin omalla tavallaan, `ApplicationController`
  sivuuttaa `check_authorization` defaultin ActiveAdminin alla.
  Tämä on hämmentävältä tuntuva ominaisuus, joka
  [on raportoitu issueksi](https://github.com/activeadmin/activeadmin/issues/4599).

## Ympäristö pystyyn

Esivaatimukset:
* Asenna [RVM](https://rvm.io/)
* RVM:n asentamisen jälkeen lue `.ruby-gemset` ja `.ruby-version: `cd .. && popd`
* `brew install v8`
* `bundle install`

Kopioi `.env.example` -> `.env` ja aseta sinne sopivat defaultit.

a) Putsaa tietokanta ja aja seed:
```bash
rake db:runts
rake db:seed:dev
rspec
```

b) Alusta tietokanta manuaalisesti:
```bash
rake db:create
rake db:schema:load
rake -T db:seed
```

Tsekkaa `Procfile` ja komenna:

~~~
foreman run web
foreman run worker
~~~ 

Avaa Admin UI
* http://localhost:5000/admin
* admin@example.com / pass123
* Seed data, ks. "rake db:seed:dev"

Jos ActiveAdminin tyylit ei näy, kokeile:

~~~
rake assets:precompile
~~~


HUOM! Refreshaa selain forcella, cmd-shift-r -- muutoin saattaa tulla cachesta
väärää dataa (tyylit ei näy, mutta forcella näkyy).



## Heroku-ympäristön pystyttäminen

Hanki uusi Rollbar access key: rollbar.com

Aseta ympäristömuuttujat: `heroku config:add key=value`.
Tiedostossa `.env.example` on lista vaadituista ympäristömuuttujista.

Säädä Herokun qa & production ympäristöt `heroku`-komennolle git-remoteiksi:
```bash
heroku git:remote -a hyy-ehdokastiedot
# vaihda tiedostosta .git/config branch "heroku" => "prod"
heroku git:remote  -a hyy-ehdokastiedot-qa
# vaihda .git/config branch "heroku" => "qa"
# => Nyt heroku-komennot toimivat molempiin ympäristöihin `-r qa` ja `-r prod`
```

Syötä seed-data, jossa peruskonffit muttei vanhaa vaalidataa:
```bash
heroku run rake db:schema:load [-r qa|prod]
heroku run rake db:seed:production [-r qa|prod]
```

Lisää add-onssit:

* Postgres
* Loggly (Logien vastaanottamiseen, `heroku addons:open loggly`)
* Lisää Access Key: AWS SES (kaikille ehdokkaille lähetetään sähköposti ehdokasasettelun päättymisen jälkeen)
* Worker sähköpostin lähettäjäksi (disabloi sen jälkeen kun ehdokasasettelun meilit lähetetty)

Worker:
```bash
heroku ps:scale worker=1 -a APP_NAME
```

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

See keys from .env.example

# Vaalien konfigurointi

Tarkista `config/initializers/000_vaalit.rb`

Greppaa edellisen vaalityöntekijän nimeä ja muuta se tarvittaessa uudempaan.

Aseta päivämäärät

Toimita salasanat HYY:lle
  * äänestysalueet (editoi seed:production)
  * admin (luo Active Administa, salasana tulee meilitse)
  * AWS SES Lähetystiedot (heroku config)


### Pääkäyttäjät

http://localhost:3000/admin
* admin@example.com / pass123


### Vaaliliiton edustajien korjaukset ehdokastietoihin

http://localhost:3000/advocates

Käyttäjätunnukset (kehitysympäristössä):
  * edustaja1@example.com (123456-123K)
  * edustaja2@example.com (123456-9876)

Salasana "pass123"


# Pekka's Tips

* Jos Formtasticin virheet ei tule näkyviin, varmista että on
  - `<%= semantic_form_for @example ..%>` EIKÄ `:example`
  - .. näistä jälkimmäinen antaa oudon virheen.

* Aja vain yksi testi:
  - lisää `:focus` testiin, myös alias "f", esim "fit", "fdescribe", "fcontext"

* Seuraa muutoksia testeihin: `guard`
  - Aja `rake db:test:prepare` migraatioiden jälkeen.

* Jos taustatyö feilaa, sen uudelleenyritys skeduloidaan eksponentiaalisesti,
  eli viimeinen yritys on joskus 2 viikon kuluttua. Rollbar ei nappaa virhettä
  jos työ ei ole failannut vaan on pelkässä retry-jonossa
  (esim. AWS permission denied).

* Työn käynnistäminen manuaalisesti:
    - `Delayed::Job.find(XX).invoke_job`
