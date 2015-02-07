CodeFly is a gem that allows you to execute parallel / asynchronous code in Rails, in a easy way.

This is how a classic code looks like:
```ruby
blue_cars = Vehicle.where(type: "car", color: "blue") # 0.1 sec
accessories = Accessory.where(type: "car") # 0.1 sec
# some code
```

This is how a flied code looks like:
```ruby
fly(:A) { blue_cars = Vehicle.where(type: "car", color: "blue") } # 0.1 sec
fly(:B) { accessories = Accessory.where(type: "car") } # 0.1 sec
# some code
wait_fly(:A, :B)
```

The first code will take 0.2 sec, but the second will take only 0.1 sec, the twice of speed. On the second code, the A and B queries will be executed at the same time (I will assume that your DB have more than 1 core), and the Ruby will be freed to execute another code while these 2 queries are being processed.

The CodeFly methods are:

* *fly(id)* { async code }
* *wait_fly(id_1[, id_2, …])*: block until the async codes terminate
