json.page @pages.current_page
json.total_pages @pages.total_pages

json.pages @pages do |page|
  json.extract! page, :id, :title
  json.set! :text, "##{page.id} #{page.title} #{page.parent.present? ? ' / ' + page.parent.title : ''}"
end