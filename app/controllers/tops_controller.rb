class TopsController < ApplicationController
  skip_before_action :authenticate_user!
  def top;end

  def terms_of_use;end

  def privacy_policy;end
end
