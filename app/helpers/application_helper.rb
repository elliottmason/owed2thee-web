module ApplicationHelper
  def capitalize(string)
    string.capitalize
  end

  def cpt(string)
    capitalize(punctuate(t(string)))
  end

  def pt(string)
    punctuate(t(string))
  end

  def punctuate(string)
    string + '.'
  end
end
