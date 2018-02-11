module SakpiHelper

  # The problem is Sakpi names have &nbsp; instead of spaces
  # see sakpi.rb#display_name
  # cruft?
  def spaced_sakpis
    sakpis = [
        ['Capital',1],
        ['Cash flow',2],
        ['Differentiation',3],
        ['Growth',4],
        ['Product/Market fit',5],
        ['Team',6]
    ]
  end

end
