module ApplicationHelper
  def error_title(object)
    pluralize(object.errors.count, "error") + " prohibited this record from being saved"
  end
end
