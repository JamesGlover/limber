#
# Class Settings::TransferTemplate provides a means of easily
# looking up transfer templates by name.
#
class Settings::TransferTemplate
  UnknownTemplate = Class.new(StandardError)

  def initialize
    @store = {}
  end

  def uuid_for(name)
    @store[name]
  end

  def register(name:,uuid:)
    raise StandardError, "Must specify a name" if name.nil?
    raise StandardError, "Must specify a uuid" if uuid.nil?
    @store[name] = uuid
  end

  def populate(api)
    api.transfer_template.each do |template|
      register(name: template.name, uuid: template.uuid)
    end
  end

  def uuid_for!(name)
    uuid_for(name) || raise(UnknownTemplate, "Unknown template: #{name}")
  end
end
