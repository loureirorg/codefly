With CodeFly you can execute parallel / asynchronous code in Rails, in a easy way.

## This is how a classic code looks like:
```ruby
@blue_cars = Vehicle.where(type: "car", color: "blue") # 0.1 sec
@accessories = Accessory.where(type: "car") # 0.1 sec
# some code
# some code using @blue_cars and @accessories
```

## This is how a flied code looks like:
```ruby
fly(:A) { @blue_cars = Vehicle.where(type: "car", color: "blue") } # 0.1 sec
fly(:B) { @accessories = Accessory.where(type: "car") } # 0.1 sec
# some code
wait_fly(:A, :B)
# some code using @blue_cars and @accessories
```

The first code will take 0.2 sec, but the second will take only 0.1 sec, the twice of speed. On the second code, the A and B queries will be executed at the same time (I will assume that your DB have more than 1 core), and the Ruby will be freed to execute another code while these 2 queries are being processed.


## The CodeFly methods are:

- *fly(id)* { async code }
- *wait_fly(id_1[, id_2, …])*: block until the async codes terminate


## Advanced techniques

You can use CodeFly to make prediction algorithms:
```ruby
fly(:ans_a) { @blue_cars = Vehicle.where(type: "car", color: "blue") }
fly(:ans_b) { @yellow_cars = Vehicle.where(type: "car", color: "yellow") }
fly(:ans_c) { @other_cars = Vehicle.where(type: "car") }

wait_fly(:ans_a)
if @blue_cars.present?
  # ...
else
  wait_fly(:ans_b)
  if @yellow_cars.present?
    #...
  else
    wait_fly(:ans_c)
    #...
  end
end
```

In this sample, you are triggering the all queries before you know what you need. So at the time that we get the first answer, the db probally provide us the others answers, saving time.
