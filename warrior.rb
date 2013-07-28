#https://www.bloc.io/ruby-warrior/#/warriors/10993/levels/7
class Player
  
  def initialize
    super
    @explored_back = false
    @direction = :forward
  end
  
  #def think_act(warrior,space,direction)
  def think_act(warrior,space)
    if space.empty?
      if warrior.health < 20
        current_health = warrior.health
        if current_health >= @health
          warrior.rest!
        else
          if warrior.health < 15
            warrior.walk!(:backward)
          else
            warrior.walk!
          end
        end
      else
        warrior.walk! 
      end
    else
        if space.enemy?
            warrior.attack!
        end
        if space.captive?
            warrior.rescue!
        end
    end
  end
  
  def play_turn(warrior)
    space = warrior.feel
    if space.wall?
      warrior.pivot!
    else
      think_act warrior,space
    end
    
    @health = warrior.health
  end
end
