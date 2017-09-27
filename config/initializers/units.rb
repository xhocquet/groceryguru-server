require 'ruby-units'

Unit.redefine!('short-ton') do |unit|
  unit.display_name = 'tons'
end

Unit.redefine!('fluid-ounce') do |floz|
  floz.aliases    = ['floz', 'fluid-ounce', 'fluid-ounces', 'fluid ounces', 'fluid ounce']
end