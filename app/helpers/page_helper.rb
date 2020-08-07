module PageHelper
  def page_title(title)
    # this will add both page title and header below topnav
    content_for(:page_title) { title }
    content_for(:page_header) { title }
  end


  def page_description(description)
    content_for(:page_description) { description.html_safe }
  end

  def breadcrumb(list)
    @breadcrumb = list
  end

  def get_breadcrumb_list
    @breadcrumb || []
  end

  def login_layout(login_additional_class = "")
    @login_layout = true
    @login_additional_class = login_additional_class
  end

  def login_additional_class
    @login_additional_class
  end

  def landing_page_layout
    @landing_page_layout = true
  end

  def javascript_include(url)
    content_for(:javascript_include) { "<script src='#{url}'></script>".html_safe }
  end


  def hidden_with_stars(text)
    return '' unless text.present?
    if text.length > 2
      text.first + '*' * (text.length - 2) + text.last
    else
      '*' * text.length
    end
  end

  def date_in_popover(date)
    return unless date.present?
    content_tag :span, date.to_date.to_s, 'data-toggle': 'tooltip', 'data-html': true, title: date.to_s
  end

  def strip_with_dots(text, max_length = 30)
    return unless text.present?
    if text.length > max_length
      text.first(max_length - 3) + '...'
    else
      text
    end
  end


  def add_alternative_helper(selector, text = 'alternative')
    <<~HTML
      <div data-controller='activate'
           data-activate-selector='#{selector}'
           >
           <a href='#' data-action='click->activate#toggleAndRemoveMe'>
             Add #{text}
           </a>
       </div>
    HTML
      .html_safe
  end
end
