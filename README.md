CodeFly is a gem that allows you to execute parallel / asynchronous code in Rails, in a easy way.

This is how a classic code looks like:
```ruby
blue_cars = Vehicle.where(type: "car", color: "blue") # 1 sec
accessories = Accessory.where(type: "car") # 1 sec
some_code(blue_cars, accessories) # 0.5 sec
```

This is how a flied code looks like:
```ruby
fly(:A) { blue_cars = Vehicle.where(type: "car", color: "blue") } # 1 sec
fly(:B) { accessories = Accessory.where(type: "car") } # 1 sec
wait_fly(:A, :B)
some_code(blue_cars, accessories) # 0.5 sec
```

The first code will take 2.5 sec, but the second will take only 1.5, almost the twice of speed. On the second code, the A and B queries will be executed at the same time (I will assume that your DB have more than 1 core), and the Ruby will be free to execute your own code while these 2 queries are being processed.

The CodeFly methods are:

fly(id) { async code }
wait_fly(id_1[, id_2, …]): block until the async codes terminate