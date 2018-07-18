class ContentImportingDecorator < LittleDecorator
  def imported_contents
    imported_contents_ids.map do |content_id|
      Content.find(content_id)
    end
  end
end
