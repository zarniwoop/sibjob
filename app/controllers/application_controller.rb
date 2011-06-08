class ApplicationController < ActionController::Base
  protect_from_forgery

  def after_sign_in_path_for(resource_or_scope)
    # looks like resource_or_scope might be the user object, could
    # check type to determine where to send next
    jobs_sibling_path(current_sibling)
  end

  def build_date_from_params(field_name, params)
    Date.new(params["#{field_name.to_s}(1i)"].to_i,
         params["#{field_name.to_s}(2i)"].to_i,
         params["#{field_name.to_s}(3i)"].to_i)
  end
end
