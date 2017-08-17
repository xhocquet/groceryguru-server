require 'ruby-units'

Unit.redefine!('short-ton') do |unit|
  unit.display_name = 'tons'
end