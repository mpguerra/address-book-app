module ApplicationHelper

# Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "Address Book App"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

	def flash_class(level)
  		case level
  			when :notice then 'info'
  			when :error then 'error'
  			when :alert then 'warning'
  		end
  	end
end
