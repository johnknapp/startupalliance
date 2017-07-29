traits = [
  'Charismatic',
  'Confident',
  'Creative',
  'Decisive',
  'Empathetic',
  'Flexible',
  'Honorable',
  'Intelligent',
  'Optimistic',
  'Persistent',
  'Resilient',
  'Stable'
]

traits.each do |t|
  trait = Trait.where(name: t).first_or_initialize
  if trait.new_record?
    trait.save
  end
end

# New traits get added
# Existing traits get left where they are so join records are fine
# Things get messy when a trait is retired
