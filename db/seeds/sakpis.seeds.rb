sakpis = [
    'Capital',
    'Cash flow',
    'Differentiation',
    'Growth',
    'Product/Market fit',
    'Team'
]

sakpis.each do |s|
  sakpi = Sakpi.where(name: s).first_or_initialize
  if sakpi.new_record?
    sakpi.save
  end
end

# See notes in traits seeds