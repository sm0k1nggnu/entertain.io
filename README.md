<img src="http://mjz.io/1416r8m17.png"/>

*Visit production version: <a href="http://entertain.io/#/">www.entertain.io</a>*<br>
*Tip: press the 'Update Feed' button, runs a websocket request to the server which response a new dummy-feed (currently there a five dummy feeds <a href="https://github.com/michaelzoidl/entertain.io/blob/master/gulp/development/webserver.coffee#L18-L44">source-code</a>*

## Getting started
Clone Repo<br>
`$ git clone git@github.com:michaelzoidl/entertain.io.git`

Install Node Packages<br>
`$ npm install`

Install Bower Packages<br>
`$ bower install`

Run Gulp<br>
*Currently there's only this one task that handle the complete process.*<br>
`$ gulp`

Now you should see the Page on the Port 63647 (<a href="http://localhost:63647" target="_blank">localhost:63647</a>)<br>
*The reason for this high port is uberspace, they reserved ports til 61000 for themself. <a href="https://wiki.uberspace.de/development:nodejs" target="_blank">source</a>*



## Deploying
Aktuell wird mit jeden Push in den Master-Branch der Source gezogen und neu deployed plus der ganze Workespace resetet, ist nichts wildes wenn man öfters commited, nur sollte jeder wissen dass der Stand der commited wird nach ~1 Min auf <a href="http://entertain.io">entertain</a>.io zu erreichen ist.



## Idea
EntertainIO hat ein relativ simples Konzept, die Zielgruppe sind Leute die zu Faul sind einen RSS-Reader einzurichten + zu pflegen (neue Sources followen, ältere kicken, das übernehmen hier die einzelnen Moderatoren die die Feeds pflegen).  Zudem gibt es noch den Community-Effekt durch Up- and Downvotes einzelner Feeds und Kommentare - so kann man trends aus dem Netz ab einer kritischen Useranzahl auf EntertainIO schon erkennen.

Alles soll in einer ähnlichen Optik wie die GAG Seiten wie Hugelol oder 9GAG aufgebaut sein (die Posts untereinander), bereits gelesene Feeds sollen dementsprechend markiert sein bzw. ausgeblendet werden (sobald die Posts auf dem Desktop zu sehen waren sind'se gelesen.

Die USPs von dem Tool sind: Idiotensicher, simple, effizient (viele Informationen auf kurze Zeit), auf jedem Device nutzbar.
Quellen der Posts: div. RSS-Feeds (wenn das Konzept aufgeht kann man Social Netzwerke mit deren APIs noch einfügen wie YouTube, Twitter, Facebook, Pinterest, etc..)
