class ContentDecorator < LittleDecorator
  def keywords
    content_tag :div, class: "content-keywords" do
      record.keywords.map do |keyword|
        content_tag :span, keyword, class: "label label-info"
      end.join.html_safe
    end
  end
end
