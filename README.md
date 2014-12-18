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

---

<a href="https://github.com/michaelzoidl/entertain.io/blob/master/LICENCE">Licence</a>  |  <a href="https://github.com/michaelzoidl/entertain.io/blob/master/THANKS">Thanks</a>
