
# With this module we want to realize this:

```javascript
// This example shows not how powerfull the module is, its just a showcase to see the functions

Queue = require 'Queue'
Heros = []

Queue
.loop(['Wonder Woman', 'Aquaman', 'Martian Manhunter', 'Green Lantern'])
.job(function(hero, next){
  Heros.push(hero);
  next();
})
.done(function(){
  console.log('This is the Justice League:');
  console.log(Heros);
})
.times(5);


```
