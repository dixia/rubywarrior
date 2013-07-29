#https://www.bloc.io/ruby-warrior/#/warriors/10993/levels/9

#ugly code
class Player
  def initialize
    super
  end
  
  def is_not_being_attacked? warrior
    warrior.health >= @health
  end
  
  def is_being_attacked! warrior
    if is_not_being_attacked? warrior
      warrior.rest!
    else
      if warrior.health < 15
          #defensive retrea
          #TODO detect attack direction
          warrior.walk!(:backward)
      else
          #in a flight attack anyway
          warrior.walk!
      end
    end
  end
  
  def may_retract warrior
    if warrior.health < 15
      spaces_back = warrior.look(:backward)
      spaces_front = warrior.look(:forward)
      
      if spaces_back.any? {|s| s.enemy?}
        warrior.shoot!(:backward)
      elsif spaces_front.any? {|s| s.enemy?}
        warrior.shoot!(:forward)
      else
        warrior.walk!(:backward)
      end
      
    else
      warrior.rest!
    end
  end
  
  def may_use_sword space,warrior
      if space.empty?
        if warrior.health < 20
          is_being_attacked! warrior
        else
          warrior.walk!
        end
      else
          if space.enemy?
              warrior.attack!
              @health = warrior.health
              return true
          end
          if space.captive?
              warrior.rescue!
              @health = warrior.health
              return true
          end
      end
  end
  
  def think_act(warrior,space)
    spaces = warrior.look
    if not spaces.any? {|s| s.captive?} and spaces.any? {|s| s.enemy?} and space.empty?
        unless is_not_being_attacked? warrior
          unless may_use_sword space,warrior
            warrior.shoot!
            @health = warrior.health
          end
        else
          if warrior.health < 20
            may_retract warrior
            warrior
          else
            warrior.walk!
            @health = warrior.health
          end
        end
    else
      may_use_sword space,warrior
    end
  end
  
  def play_turn(warrior)
    if @health.nil?
      @health = warrior.health
    end
    
    space = warrior.feel
    if space.wall?
      warrior.pivot!
    else
      think_act warrior,space
    end
    @health = warrior.health
  end
end
