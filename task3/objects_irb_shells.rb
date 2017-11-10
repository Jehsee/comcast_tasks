#################################
#### Terminal #1 IRB Session ####
#################################
class Apple

  attr_reader :variety, :origin, :history
  def initialize(**args)
    @variety = args[:variety]
    @origin = args[:origin]
    @history = args[:history]
  end
end

apple = Apple.new(variety: 'Honeycrisp', origin: 'Minnesota', history: 'Introduction to Market: 1991')

require 'YAML'

File.open('apple.rb', 'w') {|f| f.write(YAML.dump(apple)) }


#################################
#### Terminal #2 IRB Session ####
#################################
class Apple

  attr_reader :variety, :origin, :history
  def initialize(**args)
    @variety = args[:variety]
    @origin = args[:origin]
    @history = args[:history]
  end
end

require 'YAML'

apple = YAML.load(File.read('apple.rb'))

