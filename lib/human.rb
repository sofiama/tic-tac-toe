class Human
  attr_accessor :name, :marker
  
  def initialize(name)
    @name = name
  end

  def move
    puts "#{self.name} enter your position: "
    @position = gets.chomp.to_s
  end
end