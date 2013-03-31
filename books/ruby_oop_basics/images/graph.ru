core = [:Class, :Object, :Module]
klass = [:Array, :Hash, :Module, :Class,  :Fixnum, :Regexp, :String, :Symbol, :Object].shuffle

global layout:'osage'
nodes shape:'circle', width:2, penwidth:20, colorscheme:'purd9', fontname:'Helvetica', fontsize:32

klass.each { |n| node n, color:rand(2..6), fontcolor:'#55000033' }
core.each { |n| node n, fontcolor:'maroon', color:rand(7..9)}

save :pic


__END__

require "colorable"

color = Colorable::Color.new(:black)

global layout:'neato', size:20
nodes shape:'circle', style:'filled', width:20

loop do
  nxt = color.next(:hsb)
  route color.name.to_id => nxt.name.to_id
  [color, nxt].each do |c|
    fcolor = c.dark? ? '#FFFFFF' : '#000000'
    node c.name.to_id, label:c.name, fillcolor:"#{c.hex}22", fontcolor:fcolor, color:c.hex
  end
  color = nxt
  break if color.name == "Black"
end

save :cover

__END__

klass = [:Class, :Object, :Module]
global layout:'twopi'
nodes shape:'circle', width:1.8, penwidth:3
edges arrowhead:'none'

route :c => klass
node :c, label:'', shape:'none', width:0.5
klass.zip(['#FF0000', '#00FF00', '#0000FF']).each do |n, c|
  node n, color:"#{c}99", fontname:'Helvetica', fontsize:32
end


save :cover