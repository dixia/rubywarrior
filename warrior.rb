#https://www.bloc.io/ruby-warrior/#/warriors/10993/levels/9

#ugly code
  class Player		
		def being_attacked? warrior
			warrior.health < @health
		end
	 
		def retract! warrior
			if being_attacked? warrior and warrior.health < 12
				#defensive retrea
        spaces_back = warrior.look(:backward)
				spaces_front = warrior.look(:forward)
				if spaces_back.any? {|s| s.enemy?}
					warrior.walk!(:forward)
					return true
				elsif spaces_front.any? {|s| s.enemy?}
          warrior.walk!(:backward)
          return true
        end
			else
				false
			end
		end

		def rest! warrior
				if warrior.health < 20 and not reach_staris? warrior and not being_attacked? warrior and warrior.health < 12
					warrior.rest!
					true
				else
					false
				end
		end

		def reach_staris? warrior
				spaces = warrior.look
				if not spaces.any? {|s| s.enemy?} and spaces[0].empty? and spaces[-1].stairs?
					true
				else
					false
				end
		end

		def attack! warrior
			spaces = warrior.look
			if spaces[0].empty?
				spaces_back = warrior.look(:backward)
				spaces_front = warrior.look(:forward)
				
				if spaces_back.any? {|s| s.enemy?}
					unless spaces_back.any? {|s| s.captive?}
            warrior.shoot!(:backward)
					  return true
          end
				elsif spaces_front.any? {|s| s.enemy?}
          unless spaces_front.any? {|s| s.captive?}
					  warrior.shoot!(:forward)
					  return true
          end
				else
					false
				end
			else
        if not spaces[0].captive? and not spaces[0].wall?
				  warrior.attack!
				  return true
        end
			end
		end


		def walk! warrior
			#assume not need to retract
			space = warrior.feel

      if space.wall?
        warrior.pivot!
        true
			elsif space.empty?

				warrior.walk!
				return true
        
			else
				false
			end
		end
		
		def rescue! warrior
			space = warrior.feel
				if space.captive?
					warrior.rescue!
					return true
				else
					false
				end
		end

		def play_turn(warrior)

			@health ||= warrior.health
			# ugly trick can be elgant solution if used well
			#$warrior = warrior
		 
			if retract! warrior
			elsif rest! warrior
			elsif attack! warrior
			elsif walk! warrior
			elsif rescue! warrior
			else
				puts "Something wrong."
			end

			@health = warrior.health
		end
end
