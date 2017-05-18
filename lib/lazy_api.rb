# frozen_string_literal: true

#
# Class LazyApi provides a safe means of configuring an API
# which will only initialize itself when used, and will
# continue to wait around until the API is ready
#
#
class LazyApi
  def initialize(*args)
    @config = args
  end

  delegate_missing_to :_api

  private

  def _api
    @api ||= Sequencescape::Api.new(*@config)
  end
end
