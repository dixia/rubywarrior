#https://www.bloc.io/ruby-warrior/#/warriors/10993/levels/7
class Player
  
  def think_act(warrior,space)
    spaces = warrior.look
    if not spaces.any? {|s| s.captive?} and spaces.any? {|s| s.enemy?}
        warrior.shoot!  
    else
      if space.empty?
        if warrior.health < 20
          if warrior.health >= @health
            #not in enemy's attack distance
            warrior.rest!
          else
            if warrior.health < 15
              #defensive retreat
              warrior.walk!(:backward)
            else
              #in a flight go straigt anyway
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
