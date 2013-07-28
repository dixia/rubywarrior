#https://www.bloc.io/ruby-warrior/#/warriors/10993/levels/7
class Player
  
  def initialize
    super
    @explored_back = false
    @direction = :forward
  end
  
  def think_act(warrior,space,direction)
    if space.empty?
      if warrior.health < 20
        current_health = warrior.health
        if current_health >= @health
          warrior.rest!
        else
          if warrior.health < 15
            warrior.walk!(:backward)
          else
            warrior.walk! direction
          end
        end
      else
        warrior.walk! direction
      end
    else
        if space.enemy?
            warrior.attack! direction 
        end
        if space.captive?
            warrior.rescue! direction  
        end
    end
  end
  
  def play_turn(warrior)
    space = warrior.feel(@direction)
    if space.wall?
      warrior.pivot!
        if @direction == :backward
          @direction = :forward
        else
          @direction = :backward
        end
    else
      think_act warrior,space,@direction
    end
    
    @health = warrior.health
  end
end
