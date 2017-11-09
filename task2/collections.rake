# Write a rake task add_apple_to_basket that accepts two arguments, variety and count. Once executed the task should:

# 3. Whenever a basket has a new apple, the fill_rate should be re-calculated as a 
#    percentage of the count of the associated records divided by the capacity of the basket.

# 4. If the selected basket is full, the remainder of apples should be carried over to the next basket.

# 5. If no baskets are available, the rake task should output the next message as a standard output: 
#    "All baskets are full. We couldn't find the place for \[X\] apples"


# CREATE TABLE apples (
#     id:         integer,
#     basket_id:  integer,
#     variety:    string,
#     created_at: timestamp without time zone NOT NULL,
#     updated_at: timestamp without time zone NOT NULL
# );

# CREATE TABLE baskets (
#     id:         integer,
#     capacity:   integer,
#     fill_rate:  character varying,
#     created_at: timestamp without time zone NOT NULL,
#     updated_at: timestamp without time zone NOT NULL
# );

# One basket can have many apples or can have no apples. The database is pre-filled with 50 baskets each having a capacity between 2 and 27, inclusive.

desc 'Fill the proper baskets to capacity with the given number of apples'
task :add_apple_to_basket, [:variety, :count] => :environment do |task, args|
  variety = args[:variety]
  count   = args[:count].to_i

# 1. Find an available basket that has 0 OR is filled with at least 1 apple of the same sort as the variety argument.
	qualifying_baskets = Basket.left_joins(:apples).where(' "apples"."variety" = ? OR "apples"."basket_id" IS NULL', variety)

# 2. Create as many apple records as are passed in the count argument.
  apples = []
  count.times do
    apples << Apple.create(variety: variety)
  end

  apples.each do |apple|
    qualifying_baskets.each do |basket|
      next if basket.apples.count == basket.capacity
      add_apple(apple, basket)
      count -= 1
      update_fill_rate(basket)
      break
    end
  end

  # 5. If no baskets are available, the rake task should output the next message as a standard output: "All baskets are full. We couldn't find the place for \[X\] apples"
  puts "All baskets are full. We couldn't find the place for #{count} apple(s)" if count > 0
end

def add_apple(apple, basket)
    apple.update(basket_id: basket.id)
end

def update_fill_rate(basket)
	# 3. Whenever a basket has a new apple, the fill_rate should be re-calculated as a percentage of the count of the associated records divided by the capacity of the basket.
  new_fill_rate = ((basket.apples.count.to_f / basket.capacity.to_f)*100).round(2).to_s
  basket.update(fill_rate: new_fill_rate)
end