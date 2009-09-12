module EventsHelper
  def priority_color(e) 
    colors = ["red", "yellow", "green"]
    "<font color=#{colors[e-1]}>#{priority_title(e)}</font>"
  end  
  
  def priority_title(num)
    return num unless [1,2,3].include? num.to_i    
    Event::PRIORITIES[num-1][0]    
  end
  
  def check_box_to_remote(name, value = "1", checked = false, options = {}, html_options = nil)
    check_box_to_function(name, value, checked, remote_function(options), html_options || options.delete(:html))
  end

  private
  def check_box_to_function(name, value = "1", checked = false, *args, &block)
    html_options = args.extract_options!.symbolize_keys
    html_options = { "type" => "checkbox", "name" => name, "id" => sanitize_to_id(name), "value" => value }.update(args.extract_options!.stringify_keys)
    html_options["checked"] = "checked" if checked

    function = block_given? ? update_page(&block) : args[0] || ''
    onclick = "#{"#{html_options[:onclick]}; " if html_options[:onclick]}#{function}; return false;"
    href = html_options[:href] || '#'

    tag(:input, html_options.merge(:onclick => onclick))
    # tag :input, html_options    
  end  
end
