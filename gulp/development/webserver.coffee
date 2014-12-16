express   = require('express')
app       = express()
http      = require('http').Server(app)
io        = require('socket.io')(http)

module.exports = (gulp) ->
  gulp.task 'build:webserver', ->

    app.get '/', (req, res) ->
      res.sendFile(__projectdir + '/index.html')

    app.use( express.static(__projectdir) )

    http.listen 63647, ->
      console.log "yea listengin!"


    feeds = [
      {
        caption: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'
        image: 'http://localhost:61337/images/dummy_00.png'
        description: 'Vestibulum id ligula porta felis euismod semper. Aenean eu leo quam. Pellentesque ornare sem lacinia quam venenatis vestibulum. Cras justo odio, dapibus ac facilisis in, egestas eget quam. Praesent commodo cursus magna, vel scelerisque nisl consectetur et.'
      },{
        caption: 'Aenean lacinia bibendum nulla sed consectetur.'
        image: 'http://localhost:61337/images/dummy_01.png'
        description: 'Morbi leo risus, porta ac consectetur ac, vestibulum at eros. Sed posuere consectetur est at lobortis. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Morbi leo risus, porta ac consectetur ac, vestibulum at eros. Nullam quis risus eget urna mollis ornare vel eu leo. Cras mattis consectetur purus sit amet fermentum. Aenean lacinia bibendum nulla sed consectetur.'
      },{
        caption: 'Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum ma.'
        image: 'http://localhost:61337/images/dummy_02.png'
        description: 'Aenean lacinia bibendum nulla sed consectetur. Vestibulum id ligula porta felis euismod semper. Cras justo odio, dapibus ac facilisis in, egestas eget quam. Nulla vitae elit libero, a pharetra augue. Aenean eu leo quam. Pellentesque ornare sem lacinia quam venenatis vestibulum. Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit. Nulla vitae elit libero, a pharetra augue.'
      },{
        caption: 'Vestibulum id ligula porta felis euismod semper.'
        image: 'http://localhost:61337/images/dummy_03.png'
        description: 'Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit. Donec id elit non mi porta gravida at eget metus. Aenean eu leo quam. Pellentesque ornare sem lacinia quam venenatis vestibulum. Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit. Nulla vitae elit libero, a pharetra augue. Vivamus sagittis lacus vel augue laoreet rutrum faucibus dolor auctor. Donec sed odio dui.'
      },{
        caption: 'Nullam quis risus eget urna mollis ornare vel eu leo.'
        image: 'http://localhost:61337/images/dummy_04.png'
        description: 'Praesent commodo cursus magna, vel scelerisque nisl consectetur et. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras justo odio, dapibus ac facilisis in, egestas eget quam. Etiam porta sem malesuada magna mollis euismod. Donec ullamcorper nulla non metus auctor fringilla. Aenean lacinia bibendum nulla sed consectetur. Nullam id dolor id nibh ultricies vehicula ut id elit.'
      },{
        caption: 'Sed posuere consectetur est at lobortis.'
        image: 'http://localhost:61337/images/dummy_05.png'
        description: 'Aenean eu leo quam. Pellentesque ornare sem lacinia quam venenatis vestibulum. Cras mattis consectetur purus sit amet fermentum. Nullam quis risus eget urna mollis ornare vel eu leo. Donec id elit non mi porta gravida at eget metus. Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit. Maecenas faucibus mollis interdum. Sed posuere consectetur est at lobortis.' 
      }
    ]
    io.on 'connection', (socket) ->
      console.log "User Connected"
      sent = 0
      # Update User-Counter
      io.emit 'feedUpdate', feeds[sent]

      socket.on 'disconnect', ->
        console.log "User disconnected"

      socket.on 'updateFeed', (msg) ->
        ++sent
        io.emit 'feedUpdate', feeds[sent]






