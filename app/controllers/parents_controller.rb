class ParentsController < ApplicationController

  def index
    @siblings = Sibling.all
  end
end
