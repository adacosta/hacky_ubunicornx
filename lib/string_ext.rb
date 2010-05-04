class String
  def to_dom_id
    # would diplay cleaner to \s+ but would be harder to query for?
    # downcase.gsub(/\s+/, "_")
    downcase.gsub(/\s/, "_")
  end
end