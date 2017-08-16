module ModeHelper
  def mode_no_general(mode)
    return '' if mode.name.strip.downcase == 'general'
    ' - ' + mode.name.titleize
  end
end